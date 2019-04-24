var ScoreGradient = {
  draw : function(elementId, scores) {
    var c = document.getElementById(elementId);
    
    if (c) {
      var ctx = c.getContext("2d");

      var grd = ctx.createLinearGradient(0, 0, c.width, c.height);

      periods = this.countPeriods(scores);
      currentPeriod = 0;
      for (var i in scores) {
        var key = i;
        var score = scores[i].score;
        if (score != "not_in_flying_window") {
          grd.addColorStop(currentPeriod/periods, this.determineColor(score));
        }
        currentPeriod += 1
      }

      ctx.fillStyle = grd;
      ctx.fillRect(0, 0, c.width, c.height);

      $(`#${elementId}`).click(function(){
        $(`#${elementId}`).toggleClass("border-left border-right");
      });
    }
  },

  determineColor: function(score) {
    var color;
    switch(score) {
      case "ideal":
        color = "green"
        break;
      case "edge":
        color = "darkcyan"
        break;
      case "no":
        color = "blue"
        break;
      case "not_in_flying_window":
        color = "white"
        break;
      default:
        color = "white"
    }
    return color;
  },

  countPeriods: function(object) {
    var periods = 0;
    for (var i in object) {
      periods += 1
    }
    return periods;
  }
};
