const { AppRegistry, LayoutAnimation, Animated } = require('react-native');
const Geocoder = require('react-native-geocoder').default;
const Elm = require('./elm');
const secret = require('./secret.json');
const component = Elm.Main.start((app) => {
  const progress = new Animated.Value(0);
  progress.addListener((state) => {
    app.ports.progresses.send(state.value);
  });

  app.ports.animateLayout.subscribe(() => {
    LayoutAnimation.spring();
  });
  app.ports.getLocation.subscribe(() => {
    navigator.geolocation.getCurrentPosition((position) => {
      app.ports.locations.send({
        lat: position.coords.latitude,
        lng: position.coords.longitude
      });
    }, (err) => {
      // Berlin for a dummy location.
      app.ports.locations.send({
        lat: 52.52,
        lng: 13.405,
      });
    });
  });
  app.ports.geocode.subscribe((coords) => {
    Geocoder.geocodePosition(coords)
      .then((res) => {
        const geocode = res[0];
        const name = `${geocode.adminArea}, ${geocode.country}`;
        app.ports.geocodes.send(name);
      })
      .catch((err) => {
        console.error('Failed to geocode', err);
        app.ports.geocodes.send('Not Found');
      });
  });
  app.ports.animateChart.subscribe(() => {
    spring(progress);
  });

  function spring(animated) {
    animated.setValue(0);
    Animated.spring(animated, {
      toValue: 1,
      friction: 3,
      tension: 50
    }).start();
  }
}, {
  apiKey: secret.apiKey,
  timestamp: Date.now()
});

AppRegistry.registerComponent('ElmCompare', () => component);
