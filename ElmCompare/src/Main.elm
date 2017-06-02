module Main exposing (..)

import Date exposing (Date)
import NativeUi as Ui exposing (Node, Property)
import NativeUi.Style as Style exposing (defaultTransform)
import NativeUi.Elements as Elements exposing (..)
import NativeUi.Events exposing (..)
import NativeUi.Image as Image exposing (..)
import NativeUi.Properties as P
import NativeApi.Dimensions exposing (window)
import Model exposing (..)
import DateUtils exposing (..)
import DateSelector exposing (dateSelector)


-- UPDATE


updateDate : Day -> Date -> Day
updateDate day date =
    { day | date = date }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "update" msg of
        FutureDateChange date ->
            ( { model | future = updateDate model.future date }, Cmd.none )

        PastDateChange date ->
            ( { model | past = updateDate model.past date }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- VIEW


header : Model -> Node Msg
header model =
    let
        location =
            Elements.text
                [ Ui.style
                    [ Style.color "#ff6666cc"
                    , Style.fontSize 20
                    ]
                ]
                [ Ui.string "Dummy" ]
    in
        Elements.view
            [ Ui.style
                [ Style.flex 1
                , Style.paddingTop 10
                , Style.justifyContent "center"
                , Style.alignItems "center"
                ]
            ]
            [ location ]


footer : Model -> Node Msg
footer model =
    Elements.view
        [ Ui.style
            [ Style.flex 1.2
            , Style.paddingBottom 10
            , Style.justifyContent "center"
            , Style.alignItems "center"
            ]
        ]
        [ dateSelector
            FutureDateChange
            model.today
            model.future.candidates
            "#ff6666cc"
        , Elements.text
            [ Ui.style
                [ Style.color "#88998899"
                , Style.fontSize 20
                ]
            ]
            [ Ui.string "vs" ]
        , dateSelector
            PastDateChange
            model.today
            model.past.candidates
            "#889988dd"
        ]


view : Model -> Node Msg
view model =
    Elements.view
        [ Ui.style
            [ Style.flex 1
            , Style.flexDirection "column"
            , Style.justifyContent "flex-end"
            , Style.alignItems "center"
            ]
        ]
        [ header model
        , footer model
        ]



-- PROGRAM


main : Program Flags Model Msg
main =
    Ui.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
