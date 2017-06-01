module Events exposing (onMomentumScrollEnd, ScrollEvent)

import Json.Decode as Decode exposing (Decoder)
import NativeUi exposing (Property, on)


onMomentumScrollEnd : (ScrollEvent -> msg) -> Property msg
onMomentumScrollEnd tagger =
    on "onMomentumScrollEnd" (Decode.map tagger <| Decode.field "nativeEvent" scrollEvent)


inset : Decoder Inset
inset =
    Decode.map4 Inset
        (Decode.field "bottom" Decode.float)
        (Decode.field "left" Decode.float)
        (Decode.field "right" Decode.float)
        (Decode.field "top" Decode.float)


offset : Decoder Offset
offset =
    Decode.map2 Offset
        (Decode.field "x" Decode.float)
        (Decode.field "y" Decode.float)


size : Decoder Size
size =
    Decode.map2 Size
        (Decode.field "width" Decode.float)
        (Decode.field "height" Decode.float)


scrollEvent : Decoder ScrollEvent
scrollEvent =
    Decode.map5 ScrollEvent
        (Decode.field "contentInset" inset)
        (Decode.field "contentOffset" offset)
        (Decode.field "contentSize" size)
        (Decode.field "layoutMeasurement" size)
        (Decode.field "zoomScale" Decode.float)


type alias Inset =
    { bottom : Float
    , left : Float
    , right : Float
    , top : Float
    }


type alias Offset =
    { x : Float
    , y : Float
    }


type alias Size =
    { width : Float
    , height : Float
    }


type alias ScrollEvent =
    { contentInset : Inset
    , contentOffset : Offset
    , contentSize : Size
    , layoutMeasurement : Size
    , zoomScale : Float
    }
