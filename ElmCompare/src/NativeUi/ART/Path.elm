module NativeUi.ART.Path exposing (moveTo, lineTo, curveTo, close)


moveTo : Float -> Float -> String
moveTo x y =
    "M" ++ toString x ++ "," ++ toString y


lineTo : Float -> Float -> String
lineTo x y =
    "L" ++ toString x ++ "," ++ toString y


curveTo : Float -> Float -> Float -> Float -> String
curveTo x1 y1 x2 y2 =
    ""


close : String
close =
    "z"
