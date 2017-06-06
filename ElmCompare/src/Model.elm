module Model exposing (..)

import Date exposing (Date)
import Http
import DateUtils exposing (..)


type alias Model =
    { apiKey : String
    , location : Location
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
    { name : Maybe String
    , coords : Maybe Coords
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


type Msg
    = ChangeFutureDate Date
    | ChangePastDate Date
    | FutureForecastsReceived (Result Http.Error (List Forecast))
    | PastForecastsReceived (Result Http.Error (List Forecast))
    | LocationReceived Coords
    | GeocodeReceived String
    | NoOp
