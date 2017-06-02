module NativeUi.ART.Properties exposing (..)

import Json.Encode
import NativeUi exposing (Property, property)


d : String -> Property msg
d val =
    property "d" (Json.Encode.string val)


fill : String -> Property msg
fill val =
    property "fill" (Json.Encode.string val)
