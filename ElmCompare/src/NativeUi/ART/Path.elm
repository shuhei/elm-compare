module NativeUi.ART.Path exposing (moveTo, lineTo, curveTo, close)


moveTo : Float -> Float -> String
moveTo x y =
    "M" ++ toString x ++ "," ++ toString y


lineTo : Float -> Float -> String
lineTo x y =
    "L" ++ toString x ++ "," ++ toString y


curveTo : Float -> Float -> Float -> Float -> String
curveTo c1x c1y x y =
    "S " ++
        toString c1x ++ "," ++ toString c1y ++ " " ++
        toString x ++ "," ++ toString y


close : String
close =
    "z"
