module NativeUi.ART.Path exposing (move, moveTo, line, lineTo, curve, curveTo, curve2, curveTo2, curve3, curveTo3, arc, arcTo, counterArc, counterArcTo, close)


move : Float -> Float -> String
move =
    makePoint "m"


moveTo : Float -> Float -> String
moveTo =
    makePoint "M"


line : Float -> Float -> String
line =
    makePoint "l"


lineTo : Float -> Float -> String
lineTo =
    makePoint "L"


curve : Float -> Float -> String
curve =
    makePoint "l"


curveTo : Float -> Float -> String
curveTo =
    makePoint "T"


curve2 : Float -> Float -> Float -> Float -> String
curve2 =
    makeCurve2 "q"


curveTo2 : Float -> Float -> Float -> Float -> String
curveTo2 =
    makeCurve2 "Q"


curve3 : Float -> Float -> Float -> Float -> Float -> Float -> String
curve3 =
    makeCurve3 "c"


curveTo3 : Float -> Float -> Float -> Float -> Float -> Float -> String
curveTo3 =
    makeCurve3 "C"


arc : Float -> Float -> Float -> Float -> Bool -> Float -> String
arc =
    makeArc "a" False


arcTo : Float -> Float -> Float -> Float -> Bool -> Float -> String
arcTo =
    makeArc "A" False


counterArc : Float -> Float -> Float -> Float -> Bool -> Float -> String
counterArc =
    makeArc "a" True


counterArcTo : Float -> Float -> Float -> Float -> Bool -> Float -> String
counterArcTo =
    makeArc "A" True


close : String
close =
    "z"



-- UTILITY


makePoint : String -> Float -> Float -> String
makePoint command x y =
    command ++ pointToString x y


makeCurve2 : String -> Float -> Float -> Float -> Float -> String
makeCurve2 command cx cy x y =
    command ++ pointToString cx cy ++ " " ++ pointToString x y


makeCurve3 : String -> Float -> Float -> Float -> Float -> Float -> Float -> String
makeCurve3 command c1x c1y c2x c2y x y =
    command
        ++ pointToString c1x c1y
        ++ " "
        ++ pointToString c2x c2y
        ++ " "
        ++ pointToString x y


makeArc : String -> Bool -> Float -> Float -> Float -> Float -> Bool -> Float -> String
makeArc command counterClockwise x y rx ry outer xAxisRotate =
    command
        ++ pointToString (abs rx) (abs ry)
        ++ " "
        ++ toString xAxisRotate
        ++ " "
        ++ flagToString outer
        ++ ","
        ++ flagToString (not counterClockwise)
        ++ " "
        ++ pointToString x y


pointToString : Float -> Float -> String
pointToString x y =
    toString x ++ "," ++ toString y


flagToString : Bool -> String
flagToString flag =
    if flag then
        "1"
    else
        "0"
