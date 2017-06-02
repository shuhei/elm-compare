module DateSelector exposing (dateSelector)

import Date exposing (Date)
import NativeUi as Ui exposing (Node, Property)
import NativeUi.Elements as Elements exposing (..)
import NativeUi.Style as Style
import NativeUi.Properties as P
import NativeApi.Dimensions exposing (window)
import Model exposing (..)
import Events exposing (ScrollEvent, onMomentumScrollEnd)
import DateUtils exposing (relativeDate)


dateSelector : (Date -> Msg) -> Date -> List Date -> String -> Node Msg
dateSelector tagger today candidates textColor =
    let
        items =
            List.map (dateOptions textColor today) candidates

        selector =
            scrollView
                [ P.horizontal True
                , P.pagingEnabled True
                , P.showsHorizontalScrollIndicator False
                , P.scrollEventThrottle 100
                , P.alwaysBounceHorizontal False

                -- https://github.com/facebook/react-native/issues/2251
                , onMomentumScrollEnd <| onScrollEnd tagger candidates
                ]
                items
    in
        Elements.view
            [ Ui.style
                [ Style.width window.width ]
            ]
            [ selector ]


dateOptions : String -> Date -> Date -> Node Msg
dateOptions textColor today date =
    let
        textView =
            text
                [ Ui.style
                    [ Style.color textColor
                    , Style.textAlign "center"
                    , Style.paddingVertical 12
                    , Style.fontSize 22
                    ]
                ]
                [ Ui.string <| relativeDate today date ]
    in
        Elements.view
            [ Ui.style
                [ Style.flexDirection "row"
                , Style.justifyContent "center"
                , Style.alignItems "center"
                , Style.width window.width
                ]
            ]
            [ textView ]


onScrollEnd : (Date -> Msg) -> List Date -> ScrollEvent -> Msg
onScrollEnd tagger candidates event =
    let
        index =
            floor (event.contentOffset.x / window.width)

        -- TODO: Call only when the index changes.
    in
        case List.head <| List.drop index candidates of
            Just date ->
                tagger date

            Nothing ->
                NoOp
