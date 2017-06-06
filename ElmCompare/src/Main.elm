port module Main exposing (..)

import Date exposing (Date)
import Http
import NativeUi as Ui exposing (Node, Property)
import NativeUi.Style as Style exposing (defaultTransform)
import NativeUi.Elements as Elements exposing (..)
import NativeUi.Events exposing (..)
import NativeUi.Image as Image exposing (..)
import NativeUi.Properties as P
import NativeApi.Dimensions exposing (window)
import Model exposing (..)
import DateUtils exposing (..)
import Weather
import DateSelector exposing (dateSelector)
import HourlyChart exposing (hourlyChart)


-- INIT
-- TODO: Get location from the device.


dummyLocation : Location
dummyLocation =
    { name = "Berlin, Germany"
    , coords = { lat = 52.52, lng = 13.405 }
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        today =
            Date.fromTime flags.timestamp

        yesterday =
            subDays 1 today

        model =
            { apiKey = flags.apiKey
            , location = Just dummyLocation
            , today = today
            , future =
                { date = today
                , candidates = List.map (flip addDays <| today) <| List.range 0 6
                , forecasts = emptyForecasts
                }
            , past =
                { date = yesterday
                , candidates = [ yesterday, today ]
                , forecasts = emptyForecasts
                }
            }

        commands =
            [ Weather.getWeather model.apiKey dummyLocation.coords today
                |> Http.send FutureForecastsReceived
            , Weather.getWeather model.apiKey dummyLocation.coords yesterday
                |> Http.send PastForecastsReceived
            ]
    in
        ( model, Cmd.batch commands )



-- UPDATE


updateDate : Day -> Date -> Day
updateDate day date =
    { day | date = date }


updateForecasts : Day -> List Forecast -> Day
updateForecasts day forecasts =
    { day | forecasts = forecasts }



-- TODO: Show HTTP error message


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "update" msg of
        ChangeFutureDate date ->
            ( { model | future = updateDate model.future date }
            , getWeather model date FutureForecastsReceived
            )

        ChangePastDate date ->
            ( { model | past = updateDate model.past date }
            , getWeather model date PastForecastsReceived
            )

        FutureForecastsReceived (Ok forecasts) ->
            ( { model | future = updateForecasts model.future forecasts }
            , animateLayout ()
            )

        FutureForecastsReceived (Err _) ->
            ( model, Cmd.none )

        PastForecastsReceived (Ok forecasts) ->
            ( { model | past = updateForecasts model.past forecasts }
            , animateLayout ()
            )

        PastForecastsReceived (Err _) ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


-- COMMAND


getWeather : Model -> Date -> (Result Http.Error (List Forecast) -> Msg) -> Cmd Msg
getWeather model date tagger =
    case model.location of
        Just location ->
            Weather.getWeather model.apiKey location.coords date
                |> Http.send tagger

        Nothing ->
            Cmd.none


port animateLayout : () -> Cmd msg


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
                [ Ui.string <|
                    case model.location of
                        Just location ->
                            location.name

                        Nothing ->
                            ""
                ]
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
            ChangeFutureDate
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
            ChangePastDate
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
            , Style.backgroundColor "#f5fccc"
            ]
        ]
        [ header model
        , hourlyChart model
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
