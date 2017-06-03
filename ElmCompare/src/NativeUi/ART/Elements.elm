module NativeUi.ART.Elements exposing (surface, shape, text, group, clippingRectangle)

import NativeUi exposing (Property, Node, customNode)
import Native.NativeUi.ART.Elements


surface : List (Property msg) -> List (Node msg) -> Node msg
surface =
    customNode "Surface" Native.NativeUi.ART.Elements.surface


shape : List (Property msg) -> List (Node msg) -> Node msg
shape =
    customNode "Shape" Native.NativeUi.ART.Elements.shape


text : List (Property msg) -> List (Node msg) -> Node msg
text =
    customNode "Text" Native.NativeUi.ART.Elements.text


group : List (Property msg) -> List (Node msg) -> Node msg
group =
    customNode "Group" Native.NativeUi.ART.Elements.group


clippingRectangle : List (Property msg) -> List (Node msg) -> Node msg
clippingRectangle =
    customNode "ClippingRectangle" Native.NativeUi.ART.Elements.clippingRectangle


animatedShape : List (Property msg) -> List (Node msg) -> Node msg
animatedShape =
    customNode "AnimatedShape" Native.NativeUi.ART.Elements.animatedShape
