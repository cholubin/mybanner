$(document).ready(function(){

  $("#search").keyup(function() {
    $("#spinner").show(); // show the spinner
    var form = $(this).parents("form"); // grab the form wrapping the search bar.
    var url = form.attr("action"); // grab the URL from the form's action value.
    var formData = form.serialize(); // grab the data in the form
    $.get(url, formData, function(html) { // perform an AJAX get, the trailing function is what happens on successful get.
      $("#spinner").hide(); // hide the spinner
      $("#jobs").html(html); // replace the "results" div with the result of action taken
    });
  });

});