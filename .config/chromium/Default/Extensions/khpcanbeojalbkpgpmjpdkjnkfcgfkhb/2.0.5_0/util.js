var util = { //eslint-disable-line no-unused-vars
  range: function(t, min, max) {
    return (t < min) ? min : ((t > max) ? max : t);
  },

  dump: function(s) {
    if (this.dolog) console.log(s);
  },

  dolog: false,

  CSSToFloat: function(style, names) {
    function strToFloat(sval) {
      let val = parseFloat(sval);
      if (!isNaN(val)) return val;
      if (sval == "thin") return 1.0;
      if (sval == "medium") return 3.0;
      if (sval == "thick") return 5.0;
      return 0.0;
    }
    return Array.from(arguments).slice(1).reduce((i, e) => i + strToFloat(style.getPropertyValue(e)), 0);
  }
};
