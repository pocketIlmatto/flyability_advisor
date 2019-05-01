var DOWRowHighlighter = {
  highlight: function(i) {
    $(`#${i}-date-header`).on('click', function(e) {
      var className = `.${i}-date`;
      $(className).each(function() {
        $(this).toggleClass("dow-highlight-border");
      });
      for (var j = 0; j < 7; j++) {
        if (j != i) {
          var className = `.${j}-date`;
          $(className).each(function() {
            $(this).removeClass("dow-highlight-border");
          });
        }
      }
      e.preventDefault();
    });
  }
}