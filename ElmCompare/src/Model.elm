module Model exposing (..)

import Date exposing (Date)
import DateUtils exposing (..)


type alias Model =
    { location : Maybe Location
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
    , icon : String
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


type Msg
    = FutureDateChange Date
    | PastDateChange Date
    | NoOp
