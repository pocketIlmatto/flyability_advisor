var ScoreGradient = {
  draw : function(elementId, collapseSectionId, scores, winds) {
    var c = document.getElementById(elementId);
    
    if (c) {
      var ctx = c.getContext("2d");

      var grd = ctx.createLinearGradient(0, 0, c.width, 0);
      
      var periods = this.countPeriods(scores);
      
      var currentPeriod = 1;
      var disableCollapse = true;

      for (var i = 0; i < scores.length; i++) {
        score = scores[i];
        if (score != "not_in_flying_window") {
          disableCollapse = false;
          grd.addColorStop(currentPeriod/periods, this.determineColor(score, winds[i]));
        }
        currentPeriod += 1
      }
      if (disableCollapse) {
        grd.addColorStop(1, "#ffffff");
        $(`#${elementId}`).parent().removeAttr('data-toggle');
      }
      ctx.fillStyle = grd;
      ctx.fillRect(0, 0, c.width, c.height);

      $(`#${collapseSectionId}`).on("show.bs.collapse", function(){
        $(`#${elementId}`).parent().addClass("border border-dark");
      });

      $(`#${collapseSectionId}`).on("hide.bs.collapse", function(){
        $(`#${elementId}`).parent().removeClass("border border-dark");
      });
    }
  },

  determineColor: function(score, windSpeed) {
    var color;
    if (windSpeed >= 20) {
      color = "#ff0000";
    } else if (windSpeed >= 17) {
      color = "#ff6600";
    } else if (windSpeed >= 15) {
      color = "#ff9900";
    } else if (windSpeed >= 13) {
      color = "#ccff66";
    } else if (windSpeed >= 10) {
      color = "#3bd43f";
    } else if (windSpeed >= 8) {
      color = "#50c1a8";
    } else if (windSpeed >= 5) {
      color = "#4883aa";
    } else {
      color = "#284b5e";
    }

    switch(score) {
      case "edge":
        color = `${color}56`;
        break;
      case "no":
        color = `${color}4D`;
        break;
      case "not_in_flying_window":
        color = `${color}1A`;
        break;
      default:
        color = color;
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
