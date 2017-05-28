module Main exposing (..)

import Date exposing (Date)
import NativeUi as Ui exposing (Node)
import NativeUi.Style as Style exposing (defaultTransform)
import NativeUi.Elements as Elements exposing (..)
import NativeUi.Events exposing (..)
import NativeUi.Image as Image exposing (..)


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


model : Model
model =
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ({ model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ({ model | count = model.count - 1 }, Cmd.none )



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
            [ Ui.style [ Style.alignItems "center" ]
            ]
            [ image
                [ Ui.style
                    [ Style.height 64
                    , Style.width 64
                    , Style.marginBottom 30
                    , Style.marginTop 30
                    ]
                , source imageSource
                ]
                []
            , text
                [ Ui.style
                    [ Style.textAlign "center"
                    , Style.marginBottom 30
                    ]
                ]
                [ Ui.string ("Counter: " ++ toString model.count)
                ]
            , Elements.view
                [ Ui.style
                    [ Style.width 80
                    , Style.flexDirection "row"
                    , Style.justifyContent "space-between"
                    ]
                ]
                [ button Decrement "#d33" "-"
                , button Increment "#3d3" "+"
                ]
            ]


button : Msg -> String -> String -> Node Msg
button msg color content =
    text
        [ Ui.style
            [ Style.color "white"
            , Style.textAlign "center"
            , Style.backgroundColor color
            , Style.paddingTop 5
            , Style.paddingBottom 5
            , Style.width 30
            , Style.fontWeight "bold"
            , Style.shadowColor "#000"
            , Style.shadowOpacity 0.25
            , Style.shadowOffset 1 1
            , Style.shadowRadius 5
            ]
        , onPress msg
        ]
        [ Ui.string content ]



-- PROGRAM


main : Program Never Model Msg
main =
    Ui.program
        { init = ( model, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
