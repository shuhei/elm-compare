# Elm Compare

## Set up

Check out repositories:

```sh
git clone git@github.com:shuhei/elm-compare.git
cd elm-compare
git clone git@github.com:ohanhi/elm-native-ui.git
git clone git@github.com:NoRedInk/elm-ops-tooling.git
```

Comment out `require()`s in `elm-native-ui/src/Native/NativeUi/Elements.js`. This setup uses the latest version of React Native while elm-native-ui was developed against `react-native@0.37.0`. The tweak in `Element.js` is necessary because `NavigationExperimental` module was removed from React Native. If you want to use React Navigation, you need to write your own adapter. This app just turns it off because it doesn't use the navigation stuff.


```js
const _ohanhi$elm_native_ui$Native_NativeUi_Elements = function () {
  return {
    // navigationCardStack: require("NavigationCardStack"),
    // navigationHeader: require("NavigationHeader"),
    // navigationHeaderTitle: require("NavigationHeaderTitle"),
  };
}();
```

Publish `elm-native-ui` to `ElmCompare`:

```
./self_publish.sh
```

Get a [Dark Sky API](https://darksky.net/dev/) key and put it into a secret JSON file at `ElmCompare/secret.json`:

```json
{
  "apiKey": "Your API key"
}
```

## Run

```sh
cd ElmCompare
react-native run-ios
```

```sh
cd ElmCompare
npm run watch
```
