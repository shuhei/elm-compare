const { AppRegistry } = require('react-native');
const Elm = require('./elm');
const secret = require('./secret.json');
const component = Elm.Main.start(null, {
  apiKey: secret.apiKey,
  timestamp: Date.now()
});

AppRegistry.registerComponent('ElmCompare', () => component);
