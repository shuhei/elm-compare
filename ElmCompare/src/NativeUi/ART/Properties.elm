module NativeUi.ART.Properties exposing (..)

import Json.Encode
import NativeUi exposing (Property, property)


d : String -> Property msg
d val =
    property "d" (Json.Encode.string val)



-- TODO: Support gradient


fill : String -> Property msg
fill val =
    property "fill" (Json.Encode.string val)


stroke : String -> Property msg
stroke val =
    property "stroke" (Json.Encode.string val)


width : Float -> Property msg
width val =
    property "width" (Json.Encode.float val)


height : Float -> Property msg
height val =
    property "height" (Json.Encode.float val)
