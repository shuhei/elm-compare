const { AppRegistry } = require('react-native');
const Elm = require('./elm');
const component = Elm.Main.start(null, { timestamp: Date.now() });

AppRegistry.registerComponent('ElmCompare', () => component);
