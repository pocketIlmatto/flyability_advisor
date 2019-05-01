var DOWRowHighlighter = {
  highlight: function(i) {
    $(`.${i}-date-header`).on('click', function(e) {
      // Remove the left border from the column to the right
      $(`.${i+1}-date-header`).removeClass("dow-regular-header-border");
      $(`.${i+1}-date`).each(function() {
        $(this).removeClass("dow-regular-border");
      });

      // Toggle highlight for this one
      $(this).toggleClass("dow-highlight-border");
      $(`.${i}-date`).each(function() {
        $(this).toggleClass("dow-highlight-border");
      });

      // Reset everything else
      for (var j = 0; j < 7; j++) {
        // Remove the highlight from anything else
        if (j != i) {
          $(`.${j}-date-header`).removeClass("dow-highlight-border");
          $(`.${j}-date`).each(function() {
            $(this).removeClass("dow-highlight-border");
          });
        }
        // Add the regular header border, and regular border to anything other than i+1
        if (j != i + 1) {
          $(`.${j}-date-header`).addClass("dow-regular-header-border");
          $(`.${j}-date`).each(function() {
            $(this).addClass("dow-regular-border");
          });
        }
      }
      e.preventDefault();
    });
  }
}