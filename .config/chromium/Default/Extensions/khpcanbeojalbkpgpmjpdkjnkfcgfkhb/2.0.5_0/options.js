/*global chrome*/

function chromiumWheelInit(prefs) {
  let byID = function(id) {
    return document.getElementById(id);
  };

  let setLocalStorage = function(key, value) {
    let v = {};
    v[key] = value;
    prefs[key] = value;
    chrome.storage.local.set(v);
  };

  let updateGraph = function(prefix, graph) {
    if ((new Date()).getTime() - window["_yass_lastupdategraph_" + graph.id] < 50) return;
    window["_yass_lastupdategraph_" + graph.id] = (new Date()).getTime();

    let step = prefs[prefix + "step"];
    let bdump = prefs[prefix + "pre-smooth"] / 890 + 0.01;
    let edump = (900 - prefs[prefix + "post-smooth"]) / 1000;
    let c = graph.getContext("2d");
    c.clearRect(0, 0, 300, 100);

    // draw guide line
    c.fillStyle = "#aaa";
    for (let t = 50; t < 300; t += 50) {
      c.fillRect(t, 0, 1, 100);
    }

    c.fillStyle = "#bbb";
    c.strokeStyle = "#000";
    c.beginPath();
    c.moveTo(500, 500);
    c.lineTo(0, 500);

    let dest = (60.0 / 300.0) * step + 40.0;
    let d = 0;
    let bdumpbase = bdump * 110.0;
    let tipw = 5;
    for (let t = 0; t <= 60; t++) {
      if (d + 0.3 > dest) {
        break;
      }
      let bd = Math.min(Math.max(((t + 1) / (bdumpbase)), 0.05), 1.0);
      d += (dest - d) * edump * bd;
      c.lineTo(t * tipw, 100 - (dest - d));
    }
    c.stroke();
    c.fill();
  };

  // sliders
  for (let input of document.getElementsByClassName("range")) {
    let num = input.previousElementSibling;
    let forgraph = num.getAttribute("forgraph");
    if (forgraph) forgraph = byID(forgraph);

    num.prefkey = num.id;

    num.prefValue = function(value) { return value; };
    num.inputValue = function(value) { return value; };

    input.oninput = function() {
      num.value = num.displayValue(input.value);
      prefs[num.prefkey] = num.prefValue(input.value);
      if (forgraph) updateGraph(num.prefgroupprefix, forgraph);
    };

    input.onchange = function() {
      setLocalStorage(num.prefkey, prefs[num.prefkey]);
      if (forgraph) updateGraph(num.prefgroupprefix, forgraph);
    };

    num.displayValue = function(value) { return value; };

    num.loadprefvalue = function(prefix = "") {
      num.prefkey = prefix + num.id;
      let prefgroupprefix = num.prefkey.match("[a-z]+\\-[a-z]+\\-");
      if (prefgroupprefix !== null) num.prefgroupprefix = prefgroupprefix[0];
      input.value = num.inputValue(prefs[num.prefkey]);
      input.oninput();
    };
  }

  byID("w-step").displayValue = function(v) {
    byID("pixelscrollscale").innerHTML = Math.floor(v / 120.0 * 100) / 100;
    return v;
  };
  let offcaption = "OFF";
  byID("bouncy-edge").displayValue = function(v) { return (v <= 0) ? offcaption : v; };
  byID("bouncy-edge").loadprefvalue();
  byID("accel-travel").displayValue = function(v) { return (v <= 0) ? offcaption : ((v < 1) ? v : (1 / (2 - v)).toFixed(2)); };
  byID("accel-travel").prefValue = function(v) { return (v < 1) ? v : (1 / (2 - v)); };
  byID("accel-travel").inputValue = function(v) { return (v < 1) ? v : (2 - (1 / v)); };
  let smoothPrefValue = function(v) { return v * 8.9; };
  let smoothInputValue = function(v) { return (v * (10.0 / 89.0)).toFixed(2); };
  byID("w-pre-smooth").prefValue = smoothPrefValue;
  byID("w-pre-smooth").inputValue = smoothInputValue;
  byID("k-pre-smooth").prefValue = smoothPrefValue;
  byID("k-pre-smooth").inputValue = smoothInputValue;
  byID("w-post-smooth").prefValue = smoothPrefValue;
  byID("w-post-smooth").inputValue = smoothInputValue;
  byID("k-post-smooth").prefValue = smoothPrefValue;
  byID("k-post-smooth").inputValue = smoothInputValue;
  byID("k-accel").prefValue = function(v) { return v * 100; };
  byID("k-accel").inputValue = function(v) { return v / 100; };

  // load initial value for sliders
  for (let num of document.querySelectorAll("#mousebox .faderlabel, #keyboardbox .faderlabel")) {
    num.loadprefvalue("green-");
  }

  // init checkboxes
  for (let checkbox of document.querySelectorAll("input[type=checkbox]")) {
    checkbox.onchange = function() {
      setLocalStorage(checkbox.id, checkbox.checked);
    };
    checkbox.checked = prefs[checkbox.id];
  }

  // init blacklist
  let blacklist = byID("blacklist");
  blacklist.value = prefs.blacklist.join("\n").replace(/\\/g, "").replace(/\.\*/g, "*").replace(/\$/g, "");
  blacklist.onchange = function() {
    let list = blacklist.value.split(/\n/).reduce(function(prev, elm) {
      if (typeof(elm) == "string") {
        let s = elm.replace(/^\s+|\s+$/g, "");
        if (s.length > 0) {
          prev.push(s.replace(/\./g, "\\.").replace(/\+/g, "\\+").replace(/\?/g, "\\?").replace(/\*/g, ".*") + "$");
        }
      }
      return prev;
    }, []);
    chrome.storage.local.set({"blacklist": list});
  };
}

document.addEventListener("DOMContentLoaded", function() {
  chrome.storage.local.get(null, chromiumWheelInit);
});

document.body.onbeforeunload = function() {
  document.getElementById("blacklist").onchange();
};
