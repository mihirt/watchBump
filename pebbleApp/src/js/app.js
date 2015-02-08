// ------------------------------
//  Start of Strap API
// ------------------------------


// ------------------------------
//  End of Strap API
// ------------------------------

/**
 * Welcome to Pebble.js!
 *
 * This is where you write your app.
 */

var UI = require('ui');
var Vector2 = require('vector2');
var Accel = require('ui/accel');
Accel.init();
var lightState = new Boolean(false);
var ajax = require('ajax');
var Vibrator = require('ui/vibe');


var main = new UI.Card({
  title: 'Bump app',
  subtitle: 'Send a contact!',
  body: 'Bump to communicate.' ,
  

});

main.show();




Accel.on('tap', function(e) {
	Vibrator.vibrate('double');
	console.log("sent");
	ajax(
	{
	 	/*url: 'http://192.168.2.3/?9',
	    method: 'get'*/
	    url: 'https://kvtest.firebaseio.com/pebble_bumped_1.json',
	    method: 'post',
	    type: 'json',
	    data: {val: 'device 1'}
	    

	    /*url: 'https:api.spark.io/v1/access_tokens',
	    method: 'post',
	   	data: */
	    
//-d access_token=b0ca5a17f3e792da964848a381417f7201ae45e6
	
	},

	function(error) {
	
    console.log('The ajax request failed: ' + error);
  	},
  	function(data)
  	{
  		console.log("data:"+data);
  	}
  	);


	/*var onTap = new UI.Card({
		title: 'You tapped',
		body: lightState.toString(),
	});
onTap.show();*/
});








main.on('click', 'down', function(e) {
  var card = new UI.Card();
  card.title('Bump Request sent!');
  card.subtitle('Confirmed!');
  card.body('Check your phone to send information.');
  card.show();
});
