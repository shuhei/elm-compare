module HourlyChart exposing (hourlyChart)

import NativeUi as Ui exposing (Node, Property)
import NativeUi.Elements as E
import NativeUi.Style as S
import NativeUi.ART.Elements as AE
import NativeUi.ART.Properties as AP
import NativeApi.Dimensions exposing (window)
import Model exposing (..)


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


hourLabel : Int -> Node Msg
hourLabel hour =
    AE.text
        [ hourLabelStyle ]
        [ Ui.string <| toString hour ]


hourlyChart : Model -> Node Msg
hourlyChart model =
    let
        labels =
            List.map (hourLabel << ((*) 2)) <| List.range 0 11

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
            [ chart
            , E.view [ labelsStyle ] labels
            ]


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
