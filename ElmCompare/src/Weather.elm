module Weather exposing (getWeather)

import Http
import Date exposing (Date)
import Json.Decode as Decode
import Model exposing (Coords, Forecast)


getWeather : String -> Coords -> Date -> Http.Request (List Forecast)
getWeather apiKey coords date =
    let
        url =
            weatherUrl apiKey coords date
    in
        Http.get url decodeWeather


weatherUrl : String -> Coords -> Date -> String
weatherUrl apiKey coords date =
    let
        seconds =
            floor <| (Date.toTime date) / 1000
    in
        "https://api.forecast.io/forecast/"
            ++ apiKey
            ++ "/"
            ++ toString coords.lat
            ++ ","
            ++ toString coords.lng
            ++ ","
            ++ toString seconds


decodeForecast : Decode.Decoder Forecast
decodeForecast =
    Decode.map6 Forecast
        (Decode.field "time" Decode.int)
        (Decode.field "temperature" Decode.float)
        (Decode.field "windBearing" Decode.float)
        (Decode.field "windSpeed" Decode.float)
        (Decode.field "summary" <| Decode.nullable Decode.string)
        (Decode.field "icon" <| Decode.nullable Decode.string)



-- TODO: Get res.hourly.data


decodeWeather : Decode.Decoder (List Forecast)
decodeWeather =
    Decode.field "hourly" <|
        Decode.field "data" <|
            Decode.list decodeForecast
