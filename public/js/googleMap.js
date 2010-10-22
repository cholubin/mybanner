var geocoder;
var map;
function initialize(targetId,address,contentId) {
geocoder = new google.maps.Geocoder();
geocoder.geocode( { 'address': address}, function(results, status) {
	if (status == google.maps.GeocoderStatus.OK) {
    	var latlng = results[0].geometry.location;
    	var myOptions = {
    	  disableDefaultUI: true,
	      zoom: 16,
	      center: latlng,
	      mapTypeId: google.maps.MapTypeId.ROADMAP
	    }
	    map = new google.maps.Map(document.getElementById(targetId), myOptions);
	    var infowindow = new google.maps.InfoWindow({
		    content: document.getElementById(contentId),
		    position: results[0].geometry.location,
		    maxWidth : 400
		});
		infowindow.open(map);
    } else {
        alert("Geocode was not successful for the following reason: " + status);
    }
});
}