module NativeUi.ART.Path exposing (moveTo, lineTo, curveTo2, close)


moveTo : Float -> Float -> String
moveTo x y =
    "M" ++ pointToString x y


lineTo : Float -> Float -> String
lineTo x y =
    "L" ++ pointToString x y


curveTo2 : Float -> Float -> Float -> Float -> String
curveTo2 cx cy x y =
    "Q" ++ pointToString cx cy ++ " " ++ pointToString x y


close : String
close =
    "z"


-- UTILITY


pointToString : Float -> Float -> String
pointToString x y =
    toString x ++ "," ++ toString y
