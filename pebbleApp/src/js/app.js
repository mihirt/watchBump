/**
 * Welcome to Pebble.js!
 *
 * This is where you write your app.
 */

var Accel = require('ui/accel');
var UI = require('ui');
var Vector2 = require('vector2');
Accel.init();

var currentCard = "main"

var main = new UI.Card({
  title: 'BUMP for Pebble',
  subtitle: 'Tap the screen next to someone else with the BUMP app'
});

Accel.on('tap', function(e) {
  console.log("tap")
  var transactionId = Pebble.sendAppMessage( { '0': 42, '1': 'String value' },
    function(e) {
      console.log('Successfully delivered message with transactionId='
        + e.data.transactionId);
    },
    function(e) {
      console.log('Unable to deliver message with transactionId='
        + e.data.transactionId
        + ' Error is: ' + e.error.message);
    }
  );
  if (currentCard == "main"){
    currentCard = "push";
    var card = new UI.Card();
    card.title('BUMPED');
    card.subtitle('Looking for partner');
    card.body('(This is where something would happen)');

    card.on('hide', function() {
      currentCard = "main"
    });

    card.show();
  }
});

Pebble.addEventListener('appmessage',
  function(e) {
    if (e.payload["3"] != null){
      var card = new UI.Card();
      card.title('MSG RECEIVED');
      card.body(JSON.stringify(e.payload));
      card.show();
    }
  });


main.show();

