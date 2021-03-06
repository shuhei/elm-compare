module HourlyChart exposing (hourlyChart, calcHeight)

import NativeUi as Ui exposing (Node, Property)
import NativeUi.Elements as E
import NativeUi.Style as S
import NativeUi.Properties as P
import NativeUi.ART.Elements as AE
import NativeUi.ART.Properties as AP
import NativeUi.ART.Path as Path
import NativeApi.Dimensions exposing (window)
import Model exposing (..)
import Icons
import AnimatedValues as AV


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
                        { head | start = item.start } :: tail
                    else
                        item :: ranges
    in
        forecasts
            |> List.indexedMap
                (\i f -> { icon = f.icon, start = i, end = i })
            |> List.foldr mergeItems []


calcHeight : Float -> Float -> Float -> Float
calcHeight min max temperature =
    if min == max then
        0
    else
        let
            ratio =
                (temperature - min) / (max - min)
        in
            chartHeight * (ratio * 0.6 + 0.1)



-- heights are a list of 24 items for 00:00-23:00.
-- To keep enough space to show icons at the screen edge, draw:
-- - the previous days' 23:30-24:00 with the value of 00:00.
-- - 23:00-23:30 with the value of 23:00.


areaChartPath : Float -> Float -> List Float -> List String
areaChartPath w h heights =
    let
        makePoint i height =
            { x = (0.5 + toFloat i) * unitSize
            , y = h - height
            }

        points =
            List.indexedMap makePoint heights

        nextPoints =
            List.tail points
                |> Maybe.withDefault []

        -- http://stackoverflow.com/questions/7054272/how-to-draw-smooth-curve-through-n-points-using-javascript-html5-canvas
        makeCurve i p q =
            if i == 0 then
                [ Path.moveTo 0 h
                , Path.lineTo 0 p.y
                , Path.curveTo (p.x / 2) p.y
                , Path.curveTo ((p.x + q.x) / 2) ((p.y + q.y) / 2)
                ]
            else if i > 0 && i < 22 then
                [ Path.curveTo ((p.x + q.x) / 2) ((p.y + q.y) / 2) ]
            else if i == 22 then
                [ Path.curveTo ((p.x + q.x) / 2) ((p.y + q.y) / 2)
                , Path.curveTo ((q.x + chartWidth) / 2) q.y
                , Path.curveTo chartWidth q.y
                , Path.lineTo w h
                , Path.close
                ]
            else
                []
    in
        Debug.log "curves" <|
            List.concat <|
                List.map3 makeCurve (List.range 0 22) points nextPoints



-- VIEWS


hourLabel : Int -> Node Msg
hourLabel hour =
    AE.text
        [ hourLabelStyle ]
        [ Ui.string <| toString hour ]


weatherIcon : WeatherRange -> Node Msg
weatherIcon range =
    let
        children =
            case Maybe.andThen Icons.getIcon range.icon of
                Just icon ->
                    [ E.image
                        [ iconStyle
                        , Icons.localSource icon
                        ]
                        []
                    ]

                Nothing ->
                    []
    in
        E.view [ iconBoxStyle range ] children


weatherIcons : List WeatherRange -> Node Msg
weatherIcons ranges =
    E.view [ topStyle ] <|
        List.map weatherIcon ranges


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
            List.map (hourLabel << (*) 2) <| List.range 0 11

        ranges =
            Debug.log "ranges" <|
                makeRanges model.future.forecasts

        temperatures =
            List.concatMap
                (List.map .temperature << .forecasts)
                [ model.future, model.past ]

        minTemp =
            List.foldl min (1 / 0) temperatures

        maxTemp =
            List.foldl max (-1 / 0) temperatures

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
                        , AP.d <|
                            areaChartPath chartWidth chartHeight <|
                                AV.interpolate model.past.heights
                        ]
                        []
                    , AE.shape
                        [ AP.fill "#ff666666"
                        , AP.d <|
                            areaChartPath chartWidth chartHeight <|
                                AV.interpolate model.future.heights
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
