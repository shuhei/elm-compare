module NativeUi.ART.Elements exposing (surface, shape, text, group, clippingRectangle)

import NativeUi exposing (Property, Node, customNode)
import Native.NativeUi.ART.Elements as E


surface : List (Property msg) -> List (Node msg) -> Node msg
surface =
    customNode "Surface" E.surface


shape : List (Property msg) -> List (Node msg) -> Node msg
shape =
    customNode "Shape" E.shape


text : List (Property msg) -> List (Node msg) -> Node msg
text =
    customNode "Text" E.text


group : List (Property msg) -> List (Node msg) -> Node msg
group =
    customNode "Group" E.group


clippingRectangle : List (Property msg) -> List (Node msg) -> Node msg
clippingRectangle =
    customNode "ClippingRectangle" E.clippingRectangle


animatedShape : List (Property msg) -> List (Node msg) -> Node msg
animatedShape =
    customNode "AnimatedShape" E.animatedShape
