var _ohanhi$elm_native_ui$Native_NativeUi_ART_Elements = (function () {
  var ART = require('ReactNativeART');
  var Animated = require('react-native').Animated;

  return {
    surface: ART.Surface,
    shape: ART.Shape,
    text: ART.Text,
    group: ART.Group,
    clippingRectangle: ART.ClippingRectangle,
    animatedShape: Animated.createAnimatedComponent(ART.Shape)
  };
})();
