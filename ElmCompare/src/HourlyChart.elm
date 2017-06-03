module HourlyChart exposing (hourlyChart)

import NativeUi as Ui exposing (Node, Property)
import NativeUi.Elements as E
import NativeUi.Style as S
import NativeUi.ART.Elements as AE
import NativeUi.ART.Properties as AP
import NativeApi.Dimensions exposing (window)
import Model exposing (..)


type alias WeatherRange =
    { icon : Maybe String
    , start : Int
    , end : Int
    }



-- DIMENSIONS


chartWidth : Float
chartWidth =
    window.width


chartHeight : Float
chartHeight =
    250


unitSize : Float
unitSize =
    chartWidth / 24


iconSize : Float
iconSize =
    unitSize * 1.6



-- COORDINATES


makeRanges : List Forecast -> List WeatherRange
makeRanges forecasts =
    let
        mergeItems item ranges =
            case ranges of
                [] ->
                    [ item ]

                head :: tail ->
                    if item.start % 2 == 1 || item.icon == head.icon then
                        { head | end = item.end } :: tail
                    else
                        item :: ranges
    in
        forecasts
            |> List.indexedMap
                (\i f -> { icon = f.icon, start = i, end = i })
            |> List.foldr mergeItems []
            |> List.reverse



-- VIEWS


hourLabel : Int -> Node Msg
hourLabel hour =
    AE.text
        [ hourLabelStyle ]
        [ Ui.string <| toString hour ]


weatherIcons : List WeatherRange -> Node Msg
weatherIcons ranges =
    let
        -- TODO: Set source to the image
        makeIcon range =
            E.view
                [ iconBoxStyle range ]
                [ E.image [ iconStyle ] [] ]

        icons =
            []
    in
        E.view [ topStyle ] icons


weatherBorders : List WeatherRange -> Node Msg
weatherBorders ranges =
    let
        makeBorder i range =
            E.view [ borderStyle i range ] []

        borders =
            List.indexedMap makeBorder ranges
    in
        E.view [ topStyle ] borders


hourlyChart : Model -> Node Msg
hourlyChart model =
    let
        labels =
            List.map (hourLabel << ((*) 2)) <| List.range 0 11

        ranges =
            makeRanges model.future.forecasts

        chart =
            E.view
                [ chartContainerStyle ]
                [ AE.surface
                    [ AP.width chartWidth
                    , AP.height chartHeight
                    , Ui.style [ S.backgroundColor "#00000000" ]
                    ]
                    [ AE.shape
                        [ AP.fill "#99999944"
                        , AP.d "M37,17v15H14V17z M50,0H0v50h50z"
                        ]
                        []
                    , AE.shape
                        [ AP.fill "#ff666666"
                        , AP.d "M37,17v15H14V17z M50,0H0v50h50z"
                        ]
                        []
                    ]
                ]
    in
        E.view
            [ containerStyle ]
            [ weatherBorders ranges
            , chart
            , weatherIcons ranges
            , E.view [ labelsStyle ] labels
            ]



-- STYLES


containerStyle : Property Msg
containerStyle =
    Ui.style
        [ S.width chartWidth
        , S.height <| chartHeight + 25
        , S.justifyContent "flex-end"
        ]


chartContainerStyle : Property Msg
chartContainerStyle =
    Ui.style
        [ S.width chartWidth
        , S.height chartHeight
        , S.position "absolute"
        , S.top 0
        ]


labelsStyle : Property Msg
labelsStyle =
    Ui.style
        [ S.alignItems "flex-end"
        , S.flexDirection "row"
        ]


hourLabelStyle : Property Msg
hourLabelStyle =
    Ui.style
        [ S.textAlign "center"
        , S.marginTop 4
        , S.marginRight 9
        , S.width <| unitSize * 2 - 9
        , S.fontWeight "bold"
        , S.color "#99999988"
        ]


iconStyle : Property Msg
iconStyle =
    Ui.style
        [ S.width iconSize
        , S.height iconSize
        ]


topStyle : Property Msg
topStyle =
    Ui.style
        [ S.position "absolute"
        , S.top 0
        , S.height 50
        ]


iconBoxStyle : WeatherRange -> Property Msg
iconBoxStyle range =
    Ui.style
        [ S.position "absolute"
        , S.left <| unitSize * toFloat range.start
        , S.width <| unitSize * toFloat (range.end - range.start + 1)
        , S.justifyContent "flex-start"
        , S.alignItems "center"
        ]


borderStyle : Int -> WeatherRange -> Property Msg
borderStyle i range =
    Ui.style
        [ S.position "absolute"
        , S.left <| unitSize * toFloat range.start
        , S.width <| unitSize * toFloat (range.end - range.start + 1)
        , S.top 0
        , S.borderStyle "solid"
        , S.borderLeftColor "#ff666633"
        , S.borderLeftWidth <|
            if i == 0 then
                0
            else
                1
        , S.height chartHeight
        ]
