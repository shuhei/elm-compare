module Main exposing (..)

import Date exposing (Date)
import NativeUi as Ui exposing (Node, Property)
import NativeUi.Style as Style exposing (defaultTransform)
import NativeUi.Elements as Elements exposing (..)
import NativeUi.Events exposing (..)
import NativeUi.Image as Image exposing (..)
import NativeUi.Properties as P
import NativeApi.Dimensions exposing (window)

-- MODEL


type alias Forecast =
    { time: Int
    , temperature: Float
    , windBearing: Float
    , windSpeed: Float
    , summary: Maybe String
    , icon: Maybe String
    }


type alias Coords =
    { lat: Float
    , lng: Float
    }


type alias Location =
    { name: String
    , coords: Coords
    }


type alias Day =
    { date: Date
    , candidates: List Date
    , weather: List Forecast
    }


type alias Model =
    { location: Maybe Location
    , today: Maybe Date
    , future: Maybe Day
    , past: Maybe Day
    , count: Int
    }


initialModel : Model
initialModel =
  { location = Nothing
  , today = Nothing
  , future = Nothing
  , past = Nothing
  , count = 9000
  }


-- UPDATE


type Msg
    = Increment
    | Decrement
    | DateChange Date
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "update" msg of
        Increment ->
            ({ model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ({ model | count = model.count - 1 }, Cmd.none )

        DateChange date ->
            -- TODO: Update date
            (model, Cmd.none)

        NoOp ->
            (model, Cmd.none)


-- VIEW


view : Model -> Node Msg
view model =
    let
        imageSource =
            { uri = "https://raw.githubusercontent.com/futurice/spiceprogram/master/assets/img/logo/chilicorn_no_text-128.png"
            , cache = Just ForceCache
            }
    in
        Elements.view
            [ Ui.style
                [ Style.alignItems "center"
                , Style.paddingTop 100
                ]
            ]
            [ dateSelector
                (Date.fromTime 1496010919896)
                [ Date.fromTime 1496010919896, Date.fromTime 1496010919896 ]
                "#000"
            ]


formatDate : Date -> String
formatDate date =
    toString (Date.year date) ++ ", dummy"


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
                [ Ui.string (formatDate date) ]
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

dateSelector : Date -> List Date -> String -> Node Msg
dateSelector today candidates textColor =
    let
        items = List.map (dateOptions textColor today) candidates
        selector =
            scrollView
                [ P.horizontal True
                , P.pagingEnabled True
                , P.showsHorizontalScrollIndicator False
                , P.scrollEventThrottle 100
                , P.alwaysBounceHorizontal False
                -- https://github.com/facebook/react-native/issues/2251
                , onMomentumScrollEnd <| onScrollEnd candidates
                ]
                items
    in
        Elements.view
            [ Ui.style
                [ Style.width window.width ]
            ]
            [ selector ]


onScrollEnd : List Date -> ScrollEvent -> Msg
onScrollEnd candidates event =
    let
        index = floor (event.contentOffset.x / window.width)
        -- TODO: Call only when the index changes.
    in
        case List.head <| List.drop index candidates of
            Just date ->
                DateChange date
            Nothing ->
                NoOp


-- PROGRAM


main : Program Never Model Msg
main =
    Ui.program
        { init = (initialModel, Cmd.none)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
