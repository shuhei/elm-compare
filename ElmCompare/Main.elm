module Main exposing (..)

import Date exposing (Date)
import NativeUi as Ui exposing (Node, Property)
import NativeUi.Style as Style exposing (defaultTransform)
import NativeUi.Elements as Elements exposing (..)
import NativeUi.Events exposing (..)
import NativeUi.Image as Image exposing (..)
import NativeUi.Properties as P
import NativeApi.Dimensions exposing (window)
import Events exposing (ScrollEvent, onMomentumScrollEnd)
import DateUtils exposing (..)


-- MODEL


type alias Forecast =
    { time : Int
    , temperature : Float
    , windBearing : Float
    , windSpeed : Float
    , summary : Maybe String
    , icon : Maybe String
    }


type alias Coords =
    { lat : Float
    , lng : Float
    }


type alias Location =
    { name : String
    , coords : Coords
    }


type alias Day =
    { date : Date
    , candidates : List Date
    , weather : List Forecast
    }


type alias Model =
    { location : Maybe Location
    , today : Date
    , future : Day
    , past : Day
    }


type alias Flags =
    { timestamp : Float
    }


init : Flags -> ( Model, Cmd msg )
init flags =
    let
        today =
            Date.fromTime flags.timestamp

        yesterday =
            subDays 1 today

        model =
            { location = Nothing
            , today = today
            , future =
                { date = today
                , candidates = List.map (flip addDays <| today) <| List.range 0 6
                , weather = []
                }
            , past =
                { date = yesterday
                , candidates = [ yesterday, today ]
                , weather = []
                }
            }
    in
        ( model, Cmd.none )



-- UPDATE


type Msg
    = FutureDateChange Date
    | PastDateChange Date
    | NoOp


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



-- PROGRAM


main : Program Flags Model Msg
main =
    Ui.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
