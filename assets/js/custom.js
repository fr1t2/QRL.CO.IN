
/*
$( '#mainAddressForm' ).submit(function( event ) {
  event.preventDefault();
  var form = $( this );

// Post Function for submit button after coinhive
  $.ajax({
    type: 'POST',
    url: '/test/web/php/main.php',
    data: form.serialize(),
    dataType: 'json',
    success: function( resp ) {
      console.log( resp );
      success = resp.success;
      if (success) {
        console.log( "Success value is: "+success );
      } else {
        console.log( "Success value is: "+success );   
      }

      console.log( "data Submitted through POST" );
  //alert the user of the goings on here...
      if (success === true) {
        document.getElementById("a").innerHTML = 
        "<div class='callout success'>" + 
        "<h1>SUCCESS!</h1>"+
        "<h5>Your Address Has Been Submitted!</h5>"+
        "<p>You will receive a payment soon...</p>"+
        "</div>";
        }
      else {
       document.getElementById("a").innerHTML = 
        "<div class='callout alert'>" + 
        "<h3>Sorry, No Dice For You</h3>" +
        "<p>You've been here recently... </p><p>" + resp.DATETIME + " UTC</p>"+
        "<p>Come back later ;-)</p>" +
        "</div>"; 
      }
      //$("#addressForm")[0].reset();
    }
  });
});

// Mobile address form script
$( '#mobileAddressForm' ).submit(function( event ) {
  event.preventDefault();
  var form = $( this );

// Post Function for submit button after coinhive
  $.ajax({
    type: 'POST',
    url: '/test/web/php/main.php',
    data: form.serialize(),
    dataType: 'json',
    success: function( resp ) {
      console.log( resp );
      success = resp.success;
      if (success) {
        console.log( "Success value is: "+success );
      } else {
        console.log( "Success value is: "+success );   
      }

      console.log( "data Submitted through POST" );
  //alert the user of the goings on here...
      if (success === true) {
        document.getElementById("a").innerHTML = 
        "<div class='callout success'>" + 
        "<h1>SUCCESS!</h1>"+
        "<h5>Your Address Has Been Submitted!</h5>"+
        "<p>You will receive a payment soon...</p>"+
        "</div>";
        }
      else {
       document.getElementById("a").innerHTML = 
        "<div class='callout alert'>" + 
        "<h3>Sorry, No Dice For You</h3>" +
        "<p>You've been here recently... </p><p>" + resp.DATETIME + " UTC</p>"+
        "<p>Come back later ;-)</p>" +
        "</div>"; 
      }
      //$("#addressForm")[0].reset();
    }
  });
});
*/


