const { AppRegistry, LayoutAnimation } = require('react-native');
const Geocoder = require('react-native-geocoder').default;
const Elm = require('./elm');
const secret = require('./secret.json');
const component = Elm.Main.start((app) => {
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
        console.log(geocode);
        const name = `${geocode.adminArea}, ${geocode.country}`;
        app.ports.geocodes.send(name);
      })
      .catch((err) => {
        console.error('Failed to geocode', err);
      });
  });
}, {
  apiKey: secret.apiKey,
  timestamp: Date.now()
});

AppRegistry.registerComponent('ElmCompare', () => component);
