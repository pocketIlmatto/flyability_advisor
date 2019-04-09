var map;
var userMarker;
var markers;
var geocoder;
var defaultLocation = {lat: 37.804829, lng: -122.272476};

function initMap(lat, lng, flying_sites = [], localStorageShouldOverride = false) {
  var zoom = 8;

  userLocation = new google.maps.LatLng(lat, lng)
  if (localStorageShouldOverride) {
    if (localStorage.latitude) {
      userLocation = new google.maps.LatLng(parseFloat(localStorage.latitude), parseFloat(localStorage.longitude));
      zoom = 8;
    } 
  }

  var map = new google.maps.Map(
    document.getElementById('map'), {zoom: zoom, center: userLocation});
  
  userMarker = new google.maps.Marker({position: userLocation, map: map});
  markers = [];
  
  setMarkers(map, flying_sites);
}

function setMarkers(map, flying_sites) {
  var image = {
    url: marker_icon,
    scaledSize: new google.maps.Size(15, 20), // scaled size
    origin: new google.maps.Point(0,0), // origin
    anchor: new google.maps.Point(0, 0) // anchor
  };

  for (var i = 0; i < flying_sites.length; i++) {
    var flying_site = flying_sites[i];
    
    var contentString = `<div id="content-${flying_site[2]}">`+
      `<h4>${flying_site[2]}</h4>`+
      '</div>';
    var locationInfowindow = new google.maps.InfoWindow({
      content: contentString,
    });

    var marker = new google.maps.Marker({
      position: {lat: parseFloat(flying_site[0]), lng: parseFloat(flying_site[1])},
      map: map,
      title: flying_site[2],
      infowindow: locationInfowindow,
      icon: image
    });

    markers.push(marker);

    google.maps.event.addListener(marker, 'click', function() {
      hideAllInfoWindows(map);
      this.infowindow.open(map, this);
    });
  }

  var bounds = new google.maps.LatLngBounds();
  for (var i = 0; i < markers.length; i++) {
   bounds.extend(markers[i].getPosition());
  }
  
  map.fitBounds(bounds);
}

function hideAllInfoWindows(map) {
   markers.forEach(function(marker) {
     marker.infowindow.close(map, marker);
  }); 
}

function updateMap(location) {
  marker.setPosition(location);
  map.setZoom(10);
  map.setCenter(location);
}

function updateSearchBar(location) {
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
      successUserLocationAsk(p)
    }, function(e){
        console.log(e)
      }
    )
  }
}

function successUserLocationAsk(position) {
  localStorage.setItem("latitude", p.coords.latitude);
  localStorage.setItem("longitude", p.coords.longitude);
  userLocation = {lat: parseFloat(localStorage.latitude), lng: parseFloat(localStorage.longitude)}
  updateMap(userLocation);
  updateSearchBar(userLocation); 
}

$(document).ready(function() {
  geocoder = new google.maps.Geocoder();
  updateSearchBar({lat: parseFloat(localStorage.latitude), lng: parseFloat(localStorage.longitude)});
  if(localStorage.getItem('newStuffModalState') != 'shown'){
   
    $('#newStuffModal').modal('show');
    localStorage.setItem('newStuffModalState','shown')
  }

  $('#searchBarRow').hide() // Don't show search bar for now
}); //