module AnimatedValues exposing (..)


type AnimatedValues = AnimatedValues (List Float) (List Float) Float


interpolate : AnimatedValues -> List Float
interpolate (AnimatedValues froms tos progress) =
    List.map2
        (\from to -> from + (to - from) * progress)
        froms
        tos


updateProgress : Float -> AnimatedValues -> AnimatedValues
updateProgress progress (AnimatedValues froms tos _) =
    AnimatedValues froms tos progress


setTarget : List Float -> AnimatedValues -> AnimatedValues
setTarget newTos (AnimatedValues _ oldTos _) =
    AnimatedValues oldTos newTos 0
