$(document).ready(function(){
  $('.hour-range-slider').jRange({
    from: 0,
    to: 24,
    step: 1,
    scale: [0,4,8,12,16,20,24],
    format: '%s:00',
    width: 150,
    showLabels: false,
    isRange : true,
    disable: true
  });

  $('.ideal-speed-range-slider').jRange({
    from: 0,
    to: 25,
    step: 1,
    scale: [0,5,10,15,20,25],
    format: '%s',
    width: 150,
    showLabels: false,
    isRange : true,
    disable: true
  });

  $('.edge-speed-range-slider').jRange({
    from: 0,
    to: 25,
    step: 1,
    scale: [0,5,10,15,20,25],
    format: '%s',
    width: 150,
    showLabels: false,
    isRange : true,
    disable: true
  });
});
    