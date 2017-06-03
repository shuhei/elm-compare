# Elm Compare

## Set up

```sh
# Clone this repo
# Put `{ "apiKey": "Your Dark Sky API key" }` as ElmCompare/secret.json
cd elm-compare
hub clone ohanhi/elm-native-ui
hub clone elm-ops-tooling
# Comment out require()s in Element.js
./self_publish.sh
```

This setup uses the latest version of React Native while elm-native-ui was developed against `react-native@0.37.0`. The tweak in `Element.js` is necessary because `NavigationExperimental` module was removed from React Native. If you want to use React Navigation, you need to write your own adapter. This app just turns it off because it doesn't use the navigation stuff.

## Run

```sh
cd ElmCompare
react-native run-ios
```

```sh
cd ElmCompare
npm run watch
```
