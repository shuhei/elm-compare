module Model exposing (..)

import Date exposing (Date)
import Http
import DateUtils exposing (..)


type alias Model =
    { apiKey : String
    , location : Maybe Location
    , today : Date
    , future : Day
    , past : Day
    }


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
    , forecasts : List Forecast
    }


type alias Flags =
    { apiKey : String
    , timestamp : Float
    }


emptyForecasts : List Forecast
emptyForecasts =
    let
        makeForecast hour =
            { time = hour
            , temperature = 0
            , windSpeed = 0
            , windBearing = 0
            , summary = Nothing
            , icon = Nothing
            }
    in
        List.map makeForecast <| List.range 0 23



-- TODO: Get location from the device.


dummyLocation : Location
dummyLocation =
    { name = "Berlin, Germany"
    , coords = { lat = 52.52, lng = 13.405 }
    }


init : Flags -> ( Model, Cmd msg )
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
    in
        ( model, Cmd.none )


type Msg
    = ChangeFutureDate Date
    | ChangePastDate Date
    | FutureForecastsReceived (Result Http.Error (List Forecast))
    | PastForecastsReceived (Result Http.Error (List Forecast))
    | NoOp
