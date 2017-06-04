module Icons exposing (getIcon, localSource)

import Json.Encode as Encode
import Json.Decode as Decode
import NativeUi exposing (Property, property)
import Native.Icons


getIcon : String -> Maybe Int
getIcon name =
    Native.Icons.getIcon name
        |> Decode.decodeValue (Decode.nullable Decode.int)
        |> Result.withDefault Nothing


localSource : Int -> Property msg
localSource val =
    property "source" (Encode.int val)
