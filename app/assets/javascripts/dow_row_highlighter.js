var DOWRowHighlighter = {
  highlight: function(i) {
    $(`.${i}-date-header`).on('click', function(e) {
      if ($(this).hasClass("dow-highlight-border") == false) {
        // Remove the left border from the column to the right
        $(`.${i+1}-date-header`).removeClass("dow-regular-header-border");
        
        // Reset borders everywhere else
        for (var j = 0; j < 7; j++) {
          // Remove the highlight from anything else
          if (j != i) {
            $(`.${j}-date-header`).removeClass("dow-highlight-border");
          }
          // Add the regular header border, and regular border to anything other than i+1
          if (j != i + 1) {
            $(`.${j}-date-header`).addClass("dow-regular-header-border");
          }
        }

        // Show the selected column
        $(this).fadeTo("fast", 1);
        $(`.${i}-date`).each(function() {
          $(this).fadeTo("fast", 1);
        });

        // Hide everything else
        for (var j = 0; j < 7; j++) {
          // Remove the highlight from anything else
          if (j != i) {
            $(`.${j}-date-header`).fadeTo("fast", 0.1);
            $(`.${j}-date`).each(function() {
              $(this).fadeTo("fast", 0.1);
            });
          }
        }
      } else {
        // Add the left border from the column to the right
        $(`.${i+1}-date-header`).addClass("dow-regular-header-border");

        // Show everything else
        for (var j = 0; j < 7; j++) {
          // Remove the highlight from anything else
          if (j != i) {
            $(`.${j}-date-header`).fadeTo("fast", 1);
            $(`.${j}-date`).each(function() {
              $(this).fadeTo("fast", 1);
            });
          }
        }
      }

      // Toggle highlight for this one
      $(this).toggleClass("dow-highlight-border");
      
      e.preventDefault();
    });
  }
}