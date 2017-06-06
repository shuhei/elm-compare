const { AppRegistry, LayoutAnimation } = require('react-native');
const Elm = require('./elm');
const secret = require('./secret.json');
const component = Elm.Main.start((app) => {
  console.log(app);
  app.ports.animateLayout.subscribe(() => {
    LayoutAnimation.spring();
  });
}, {
  apiKey: secret.apiKey,
  timestamp: Date.now()
});

AppRegistry.registerComponent('ElmCompare', () => component);
