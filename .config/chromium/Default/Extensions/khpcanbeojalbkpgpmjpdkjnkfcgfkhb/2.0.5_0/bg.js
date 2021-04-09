/*global chrome,util*/
chrome.storage.local.get(["selected-preset", "output-log"], (val) => {
  if (val["selected-preset"] === undefined) {
    // initialize storage.local
    let settings = null;
    if (localStorage.selectedpreset !== undefined && localStorage.migrated === undefined) {
      // migration
      localStorage.migrated = "1";
      let preset = localStorage.preset_green.split(",");
      settings = {
        "selected-preset": "green",
        "enabled": (localStorage.enabled == 1),
        "blacklist": (localStorage.blacklist.length > 0) ? localStorage.blacklist.split("\n") : [],
        "bouncy-edge": localStorage.edgetype - 0,
        "bouncy-edge-shadow": true,
        "output-log": (localStorage.dolog == "true"),
        "tick-wheel": localStorage.tickwheel - 0,
        "page-margin": 40,
        "green-w-step": preset[0] - 0,
        "green-w-pre-smooth": preset[2] - 0,
        "green-w-post-smooth": preset[1] - 0,
        "green-w-accel": preset[3] - 0,
        "green-k-step": preset[4] - 0,
        "green-k-pre-smooth": preset[6] - 0,
        "green-k-post-smooth": preset[5] - 0,
        "green-k-accel": preset[7] - 0,
        "green-accel-travel": 1.0
      };
      console.log("localStorage migratiotn succeeded.");
    }
    else {
      // default
      settings = {
        "selected-preset": "green",
        "enabled": true,
        "blacklist": [],
        "bouncy-edge": 60,
        "bouncy-edge-shadow": false,
        "output-log": false,
        "tick-wheel": 84,
        "page-margin": 40,
        "green-w-step": 40,
        "green-w-pre-smooth": 224,
        "green-w-post-smooth": 589,
        "green-w-accel": 204,
        "green-k-step": 86,
        "green-k-pre-smooth": 227,
        "green-k-post-smooth": 491,
        "green-k-accel": 105,
        "green-accel-travel": 1.0
      };
    }
    chrome.storage.local.set(settings);
  }
  else {
    util.dolog = val["output-log"];
    chrome.storage.local.set({"enabled": true});
  }
});

chrome.storage.onChanged.addListener(function(changes, area) {
  if (area != "local") return;

  let changedKeys = Object.keys(changes);
  if (changedKeys.includes("enabled")) {
    if (changes.enabled.newValue) {
      chrome.browserAction.setIcon({
        "path": "wheel.png"
      });
    }
    else {
      chrome.browserAction.setIcon({
        "path": "wheel_disabled.png"
      });
    }
  }

  if (changedKeys.includes("output-log")) {
    util.dolog = changes["output-log"].newValue;
  }
});

chrome.runtime.onMessage.addListener(function(request, sender, response) {

  if (sender.tab === undefined) return;

  // event bubble relay
  if (request.type == "event-bubble") {
    chrome.tabs.sendMessage(sender.tab.id, request, {frameId: request.dest});
  }
  // frame attributes query relay
  else if (request.type == "frame-attributes") {
    chrome.tabs.sendMessage(sender.tab.id, request, {frameId: request.dest}, function(result) {
      // connection between content scripts is available only one at a time, so
      setTimeout(function() {
        chrome.tabs.sendMessage(sender.tab.id, {type: "frame-attributes-response", result: result}, {frameId: sender.frameId});
      }, 1);
    });
  }
});

chrome.browserAction.onClicked.addListener(function(t) {
  chrome.storage.local.get("enabled", function(prefs) {
    chrome.storage.local.set({"enabled": (prefs.enabled) ? false : true});
  });
});
