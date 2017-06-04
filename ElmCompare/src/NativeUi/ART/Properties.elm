module NativeUi.ART.Properties exposing (..)

import Json.Encode
import NativeUi exposing (Property, property)

-- https://github.com/react-native-china/react-native-ART-doc/blob/master/doc.md

d : List String -> Property msg
d val =
    property "d" (Json.Encode.list <| List.map Json.Encode.string val)



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


visible : Bool -> Property msg
visible val =
    property "visible" (Json.Encode.bool val)


strokeWidth : String -> Property msg
strokeWidth val =
    property "strokeWidth" (Json.Encode.string val)


-- TODO: strokeDash


type StrokeCap
    = StrokeCapButt
    | StrokeCapRound
    | StrokeCapSquare


strokeCap : StrokeCap -> Property msg
strokeCap val =
    let
        stringValue = case val of
            StrokeCapButt -> "butt"
            StrokeCapRound -> "round"
            StrokeCapSquare -> "square"
    in
        property "strokeCap" (Json.Encode.string stringValue)


type StrokeJoin
    = StrokeJoinMiter
    | StrokeJoinRound
    | StrokeJoinBevel


strokeJoin : StrokeJoin -> Property msg
strokeJoin val =
    let
        stringValue = case val of
            StrokeJoinMiter -> "miter"
            StrokeJoinRound -> "round"
            StrokeJoinBevel -> "Bevel"
    in
        property "strokeJoin" (Json.Encode.string stringValue)


type Alignment
    = AlignmentLeft
    | AlignmentRight
    | AlignmentCenter


alignment : Alignment -> Property msg
alignment val =
    let
        stringValue = case val of
            AlignmentLeft -> "left"
            AlignmentRight -> "right"
            AlignmentCenter -> "center"
    in
        property "alignment" (Json.Encode.string stringValue)


-- TODO: font
