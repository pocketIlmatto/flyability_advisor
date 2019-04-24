var ScoreGradient = {
  draw : function(elementId, collapseSectionId, scores) {
    var c = document.getElementById(elementId);
    
    if (c) {
      var ctx = c.getContext("2d");

      var grd = ctx.createLinearGradient(0, 0, c.width, 0);
      
      var periods = this.countPeriods(scores);
      
      var currentPeriod = 0;
      var disableCollapse = true;
      for (var i in scores) {
        var key = i;
        var score = scores[i].score;
        if (score != "not_in_flying_window") {
          disableCollapse = false;
          grd.addColorStop(currentPeriod/periods, this.determineColor(score, scores[i].speed_max_act));
        }
        currentPeriod += 1
      }
      if (disableCollapse) {
        grd.addColorStop(1, "#F5F5F5");
        $(`#${elementId}`).parent().removeAttr('data-toggle');
      }
      ctx.fillStyle = grd;
      ctx.fillRect(0, 0, c.width, c.height);

      $(`#${collapseSectionId}`).on("show.bs.collapse", function(){
        $(`#${elementId}`).addClass("border border-primary");
      });

      $(`#${collapseSectionId}`).on("hide.bs.collapse", function(){
        $(`#${elementId}`).removeClass("border border-primary");
      });
    }
  },

  determineColor: function(score, windSpeed) {
    var color;
    var colorModifier = (10 - windSpeed)/100;
    switch(score) {
      case "ideal":
        color = this.changeColorByX("#008000", colorModifier, 0, colorModifier);
        break;
      case "edge":
        color = this.changeColorByX("#FFA500", 0, 0, colorModifier);
        break;
      case "no":
        color = this.changeColorByX("#A9A9A9", colorModifier, colorModifier, colorModifier);
        break;
      case "not_in_flying_window":
        color = this.changeColorByX("#F5F5F5", colorModifier, colorModifier, colorModifier);
        break;
      default:
        color = "#F5F5F5"
    }
    return color;
  },

  componentToHex: function(c) {
    var hex = c.toString(16);
    
    hex = hex.length == 1 ? "0" + hex : hex;
    return hex;
  },

  hexToRgb: function(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
  },

  rgbToHex: function(r, g, b) {
    return "#" + this.componentToHex(r) + this.componentToHex(g) + this.componentToHex(b);
  },

  changeColorCache: {},

  changeColorByX(baseColor, r, g, b) {
    if (`${baseColor}${r}${g}${b}` in this.changeColorCache) {
      return this.changeColorCache[`${baseColor}${r}${g}${b}`];
    }
    rgb = this.hexToRgb(baseColor);
    rgb.r = parseInt((rgb.r * r) + rgb.r);
    rgb.g = parseInt((rgb.g * g) + rgb.g);
    rgb.b = parseInt((rgb.b * b) + rgb.b);
    hex = this.rgbToHex((rgb.r >= 255 ? 255 : rgb.r), (rgb.g >= 255 ? 255 : rgb.g), (rgb.b >= 255 ? 255 : rgb.b));
    this.changeColorCache[`${baseColor}${r}${g}${b}`] = hex;
    return hex;
  },

  countPeriods: function(object) {
    var periods = 0;
    for (var i in object) {
      periods += 1
    }
    return periods;
  }
};
