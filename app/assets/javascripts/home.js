var map;
var marker;
var geocoder;
var defaultLocation = {lat: 37.804829, lng: -122.272476};

function initMap(lat, lng, localStorageShouldOverride = false) {
  var zoom = 8;

  userLocation = new google.maps.LatLng(lat, lng)
  if (localStorageShouldOverride) {
    if (localStorage.latitude) {
      userLocation = new google.maps.LatLng(parseFloat(localStorage.latitude), parseFloat(localStorage.longitude));
      zoom = 8;
    } 
  }

  map = new google.maps.Map(
    document.getElementById('map'), {zoom: zoom, center: userLocation});
  
  marker = new google.maps.Marker({position: userLocation, map: map});
}

function updateMap(location) {
  marker.setPosition(location);
  map.setZoom(10);
  map.setCenter(location);
}

function codeLatLng(location) {
  if (!location.lat) {
    return;
  }
  var latlng = new google.maps.LatLng(location.lat, location.lng);
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      city = 'Oakland, CA';
      var cityFound = false;
      for (var i=0; i<results.length; i++) {
        if (cityFound) {
          break;
        }
        city= results[i].formatted_address;
        for (var b=0;b<results[i].types.length;b++) {
          if (results[i].types[b] == "postal_code") {
            cityFound = true;
            break;
          }
        }
      }
      $('#search-bar').val(city)      
    } else {
      console.log("Geocoder failed due to: " + status);
    }
  });
}

function askOnceForLocation() {
  if (!localStorage.latitude) {
    navigator.geolocation.getCurrentPosition(function(p){
      localStorage.setItem("latitude", p.coords.latitude);
      localStorage.setItem("longitude", p.coords.longitude);
      userLocation = {lat: parseFloat(localStorage.latitude), lng: parseFloat(localStorage.longitude)}
      updateMap(userLocation);
      codeLatLng(userLocation);
    }, function(e){
        console.log(e)
      }
    )
  }
}

$(document).ready(function() {
  geocoder = new google.maps.Geocoder();
  codeLatLng({lat: parseFloat(localStorage.latitude), lng: parseFloat(localStorage.longitude)});
}); //