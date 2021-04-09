/*global chrome,util,scroller*/
var yass = {

  m_pref: {},
  m_lasteventtime: 0, // for speed calculation
  m_lasteventtimeraw: 0, // for event filterring
  m_speed: 0.0001,
  m_lastcheckdesignmodearg: null,
  m_keyenable: true,
  m_keyscrolltarget: null,
  m_clickedtarget: null,
  m_mousescrolltarget: null,
  m_mousemoved: [-100000, -100000],
  m_sumpixelscroll: 0,
  m_mouseoverflowing: false,

  urgeRefreshTarget: function() {
    scroller.clearTarget();
    this.m_mousescrolltarget = null;
    this.m_keyscrolltarget = null;
    this.m_clickedtarget = null;
  },

  checkTickWheel: function(d) {
    if (this.m_ticksstack === undefined) this.m_ticksstack = [];
    if (scroller.hasTarget() == false) return; // on no scrollable area and on xul(about:blank), ev.detail is not normal value
    this.m_ticksstack.push(Math.abs(d));
    if (this.m_ticksstack.length < 10) return;
    let tickwheel = Math.max(28, Math.min.apply(null, this.m_ticksstack));
    if (tickwheel != this.m_pref.tickwheel) {
      chrome.storage.local.set({"tick-wheel": tickwheel});
      this.m_pref.tickwheel = tickwheel;
      util.dump("tickwheel set to " + tickwheel);
    }
    this.m_ticksstack = null;
    this.checkTickWheel = function() {};
  },

  handleEvent: function(ev) {
    if (ev.altKey || ev.ctrlKey || (ev.shiftKey && ev.keyCode != 32) || (ev.metaKey && (ev.keyCode != 38 && ev.keyCode != 40))) return;

    let fromkeyboard = false;

    let ev_detail = 0;

    let mozscrollstep = 0;

    let ctm = (new Date()).getTime();

    let passToParentFrame = function(ev) {
      let clonedevent = ["type", "detail", "deltaX", "deltaY", "deltaMode", "buttons", "wheelDeltaY",
        "screenX", "screenY", "axis", "keyCode", "shiftKey", "altKey", "ctrlKey", "metaKey"]
        .reduce(function(prev, elm) { prev[elm] = ev[elm]; return prev; }, {});
      chrome.runtime.sendMessage({type: "event-bubble", event: clonedevent, dest: scroller.frameElement.parent});
    };

    switch (ev.type) {
      case "mousewheel":
      case "wheel": {
        if (ev.buttons != 0) return;
        // Google Chrome specific special filter for embedded PDF: it throws wheel event of html even if pdf is scrollable
        if (ev.target !== null)
          if (ev.target.type == "application/pdf" && (ev.target.nodeName.toLowerCase() == "embed" || ev.target.nodeName.toLowerCase() == "object")) return;
        if (ev.type == "wheel") {
          ev_detail = ev.deltaY * [1.0, 28.0, 500.0][ev.deltaMode];
          let wheeldeltax = ev.deltaX * [1.0, 28.0, 500.0][ev.deltaMode];
          if (Math.abs(ev_detail) < Math.abs(wheeldeltax)) return;
        }
        else {
          ev_detail = -ev.wheelDeltaY;
        }
        if (ev_detail == 0) return;
        mozscrollstep = ev_detail * (this.m_pref.wheelstep / this.m_pref.tickwheel);
        this.m_keyscrolltarget = null;
        let mousex = ev.screenX - this.m_mousemoved[0];
        let mousey = ev.screenY - this.m_mousemoved[1];
        if ((mousex * mousex) + (mousey * mousey) >= 16 || this.m_mousescrolltarget == null) {
          this.m_mousescrolltarget = ev.target;
          this.m_mousemoved = [ev.screenX, ev.screenY];
          scroller.refreshTarget(ev.target, ev_detail, ev);
          if (scroller.hasTarget() == false) this.m_mousescrolltarget = null;
        }
        this.checkTickWheel(ev_detail);
        break;
      }

      case "keydown": {
        let spacekey = false;
        switch (ev.keyCode) {
          case 38:
            ev_detail = ev.metaKey ? -3 : -1;
            break;
          case 40:
            ev_detail = ev.metaKey ? 3 : 1;
            break;
          case 33:
            ev_detail = -2;
            break;
          case 34:
            ev_detail = 2;
            break;
          case 35:
            ev_detail = 3;
            break;
          case 36:
            ev_detail = -3;
            break;
          case 32:
            ev_detail = (ev.shiftKey) ? -2 : 2;
            spacekey = true;
            break;
          default:
            // mainly for google reader shortcut issue
            scroller.clearTarget();
            this.m_mousescrolltarget = null;
            return;
        }

        this.checkDesignMode(ev);
        if (this.m_keyenable == false) return;
        if (this.m_keyscrolltarget == null || scroller.hasTarget() == false || this.m_clickedtarget != null) {
          scroller.refreshTarget(this.m_clickedtarget || ev.target, 0, ev);
          this.m_keyscrolltarget = 1; // not null
        }

        let tagname = ev.target.tagName.toLowerCase();
        util.dump("key target tagname=" + tagname);
        if (tagname == "input") {
          if (spacekey) return;
          let typeattr = (ev.target.getAttribute("type") || "text").toLowerCase();
          if (/^(text|search|password|url|tel|email|datetime|date|month|week|time|datetime-local|number|color|range|radio)$/.test(typeattr)) return;
        }
        if (tagname == "button" && spacekey) return;
        if (/^(select|textarea|embed|object|audio|video)$/.test(tagname)) return;

        fromkeyboard = true;
        this.m_mousescrolltarget = null;
        this.m_clickedtarget = null;
        break;
      }

      case "mousedown":
        this.m_clickedtarget = ev.target;
        scroller.softStop();
        if (scroller.frameElement.parent >= 0) passToParentFrame(ev);
        return;

      case "resize":
        this.urgeRefreshTarget();
        return;

      default:
        return;
    }

    if (ev.defaultPrevented) return; // Added for problem on googl+ feed image view mode. Image zoom function eats event and prevents default

    if (scroller.hasTarget() == false) {
      if (scroller.frameElement.parent >= 0) {
        // send event to upper frame while nothing to scroll in this frame
        passToParentFrame(ev);
        ev.preventDefault(); // Chrome need it while Firefox does not / without this cause glitchy scrolling over unscrollable iframe
      }
      return;
    }

    let virtualPosition = scroller.virtualPosition(); // must be ensured scroller has a target before call this

    ev.preventDefault();
    if (ev_detail == 0) return; // maybe this fixes microsoft smooth wheel problem

    let eventInterval = ctm - this.m_lasteventtimeraw;
    this.m_lasteventtimeraw = ctm;

    // another path to upper frame
    // send scroll overflow to upper frame only by mouse
    if (scroller.frameElement.parent >= 0) {
      if (eventInterval > 200 || this.m_mouseoverflowing) {
        if ((virtualPosition <= 0 && mozscrollstep < 0) || (virtualPosition >= 1000 && mozscrollstep > 0)) {
          // with this flag, send a set of wheel events caused by man's actual single action which begins at an edge.
          this.m_mouseoverflowing = true;
          passToParentFrame(ev);
          return;
        }
        this.m_mouseoverflowing = false;
      }
    }

    if (this.m_pref.useBouncyEdge) {
      // ignore events in bounce animation and at near of the edges
      // for MacOS native flick
      if (eventInterval <= 200) {
        if ((virtualPosition < 5 && mozscrollstep < 0) || (virtualPosition > 995 && mozscrollstep > 0)) {
          return;
        }
      }
      // block only same direction event while bounce animation
      // seems here is somewhat less proper for this
      if ((virtualPosition < 0 && ev_detail < 0) || (virtualPosition > 1000 && ev_detail > 0)) {
        return;
      }
    }

    let detailsq = ev_detail * ev_detail;
    let pagescroll = (detailsq == 4);
    let wholepagescroll = (detailsq == 9);

    let evtime = util.range((ctm - this.m_lasteventtime), 1, 1500);
    this.m_sumpixelscroll += Math.abs(mozscrollstep);
    let speed = 0.3 * (this.m_sumpixelscroll / this.m_pref.wheelstep / evtime); // distance(ticks) / time
    this.m_speed *= 1.0 - util.range(((evtime - 100) / 800), 0, 0.9999); // speed loss 0.2sec offset 0.5sec to zero
    this.m_speed = Math.max(this.m_speed, speed);

    let delta = 0;
    if (mozscrollstep != 0) {
      // pointing devices
      delta = mozscrollstep;
      if (this.m_sumpixelscroll >= 300) {
        this.m_sumpixelscroll = Math.round(this.m_sumpixelscroll / 11);
        this.m_lasteventtime = ctm - Math.round(evtime / 11);
      }
    }
    else {
      // keyboard
      // branch of step
      let step =
        (fromkeyboard) ?
        ((pagescroll) ?
          Math.max(0, scroller.pageHeight() - this.m_pref.pagemargin) :
          ((wholepagescroll) ?
            (scroller.documentHeight() + 100) :
            this.m_pref.kbdstep)) :
        this.m_pref.wheelstep;

      delta = step * ((ev_detail < 0) ? -1 : 1);
      this.m_lasteventtime = ctm;
    }

    let bdump = fromkeyboard ? this.m_pref.kbdbdumping : this.m_pref.wheelbdumping;
    let dump = fromkeyboard ? this.m_pref.kbddumping : this.m_pref.wheeldumping;
    let accel = 1;
    let deaccel = 1;

    if (scroller.active) {
      // counter direction wheel event while wheel active
      if (!fromkeyboard && scroller.animationDirection() * delta < 0) {
        // don't change scroll direction immediately but...
        deaccel = 0.92; // scale down distance betweeen here and destination
      }
      else {
        if (fromkeyboard) {
          accel = (pagescroll || wholepagescroll) ? 1.0 : (this.m_pref.kbdaccel / 100);
        }
        else {
          accel = util.range(this.m_pref.wheelaccel * this.m_speed, 1.0, 30.0);
          if (this.m_pref.accelbytravel > 0) {
            // accel by travel
            let distance = scroller.travelDistance();
            let k = 1666 / this.m_pref.accelbytravel;
            accel += Math.max(0, ((distance - k) / k));
          }
        }
      }
    }

    scroller.smoothScrollBy(delta * accel, deaccel, bdump, dump);
  },

  checkDesignMode: function(ev) {
    if (ev.target == this.m_lastcheckdesignmodearg) return;
    this.m_lastcheckdesignmodearg = ev.target;

    let b = true;
    let mode = (ev.target.ownerDocument && ev.target.ownerDocument.designMode) ? ev.target.ownerDocument.designMode : "off";
    if (mode && mode.toLowerCase() == "on") b = false;
    if (ev.target.isContentEditable == true) b = false;
    if (ev.target.style["-webkit-user-modify"] != "") b = false;
    this.m_keyenable = b;
  },

  refreshPreferences: function(prefs) {
    this.urgeRefreshTarget();

    let preset = prefs["selected-preset"] || "green";

    this.m_pref.wheelstep = prefs[preset + "-w-step"];
    this.m_pref.wheeldumping = (900 - prefs[preset + "-w-post-smooth"]) / 1000;
    this.m_pref.wheelbdumping = prefs[preset + "-w-pre-smooth"] / 890;
    this.m_pref.wheelaccel = prefs[preset + "-w-accel"];
    this.m_pref.kbdstep = prefs[preset + "-k-step"];
    this.m_pref.kbddumping = (900 - prefs[preset + "-k-post-smooth"]) / 1000;
    this.m_pref.kbdbdumping = prefs[preset + "-k-pre-smooth"] / 890;
    this.m_pref.kbdaccel = prefs[preset + "-k-accel"];
    this.m_pref.accelbytravel = prefs[preset + "-accel-travel"];

    this.m_pref.usekbd = true;
    this.m_pref.usepagejump = true;
    this.m_pref.pagemargin = prefs["page-margin"];
    this.m_pref.usewholejump = true;
    util.dolog = prefs["output-log"];
    scroller.edgeSize = prefs["bouncy-edge"];
    this.m_pref.useBouncyEdge = scroller.edgeSize > 0;
    this.m_pref.tickwheel = prefs["tick-wheel"];
    scroller.setBouncyEdgeAppearance(prefs["bouncy-edge-shadow"]);
  }
};

(function() {

  let regularElement = (document.documentElement || document.createElementNS("http://www.w3.org/1999/xhtml", "div"));
  let wheelevent = ("onwheel" in regularElement) ? "wheel" : "mousewheel";

  let listenerLoaded = false; // also used for top frame response to children

  let parentInfoNeeded = true; // for child frames

  let loadListeners = function(doLoad) {
    if (doLoad == listenerLoaded) return;
    if (doLoad) {
      addEventListener(wheelevent, yass, {capture: false, passive: false});
      addEventListener("mousedown", yass, false);
      addEventListener("keydown", yass, false);
      addEventListener("resize", yass, false);
    }
    else {
      removeEventListener(wheelevent, yass, {capture: false, passive: false});
      removeEventListener("mousedown", yass, false);
      removeEventListener("keydown", yass, false);
      removeEventListener("resize", yass, false);
    }
    listenerLoaded = doLoad;
  };

  document.addEventListener("DOMContentLoaded", function() {

    let topframe = false;
    try { topframe = (document.defaultView.top.document === document); }
    catch (e) {}

    if (topframe) {
      // Chrome browser has no window.mozInnerScreenX/Y: a variable of a viewport position.
      // Problems expected on some layout which places content viewport on inordinary place (ex. developer tool inserted left or top)
      // v2.0.5 we no longer support browser zooming (detecting with devicePixelRatio which causes problem on retina display),
      // We have been left for a decade without a way to access zoom level. Nobody care of this means nobody use this.
      let elementFromScreenXY = function(screenX, screenY) {
        let w = document.defaultView;
        let borderSize = (w.outerWidth - w.innerWidth) / 2;
        let headerSize = (w.outerHeight - w.innerHeight) - borderSize;
        let pointx = screenX - (w.screenLeft + borderSize);
        let pointy = screenY - (w.screenTop + headerSize);
        return document.elementFromPoint(pointx, pointy);
      };

      // event listener only for top frame
      chrome.runtime.onMessage.addListener(function(message, sender, response) {
        if (message.type == "frame-attributes") {
          var frame = elementFromScreenXY(message.screenX, message.screenY);
          if (frame.nodeName != "FRAME" && frame.nodeName != "IFRAME") frame = null;
          util.dump("frame-attributes: (" + message.screenX + "," + message.screenY + ")" + (frame ? frame.nodeName : "failed!"));
          response((frame != null) ? {
            scrolling: "" + frame.getAttribute("scrolling"),
            parent: (frame.nodeName.toLowerCase() == "frame") ? -1 : 0,
            unloadListeners: !listenerLoaded
          } : {
            scrolling: "no", parent: 0, unloadListeners: true // failed to find out iframe element under mouse cursor
          });
        }
        else if (message.type == "event-bubble") {
          let ev = message.event;
          ev.preventDefault = function() {};
          ev.target = elementFromScreenXY(ev.screenX, ev.screenY);
          util.dump("event-bubble: (" + ev.screenX + "," + ev.screenY + ") " + (ev.target ? (ev.target.nodeName + "#" + ev.target.id) : "NULL"));
          yass.handleEvent(ev);
        }
      });
    }
    else {
      scroller.frameElement = { scrolling: "no", parent: 0 };

      // frame attributes query and response listener
      addEventListener("mouseover", function(ev) {
        util.dump("mouseover on iframe");
        if (parentInfoNeeded == false) return;
        chrome.runtime.sendMessage({
          type: "frame-attributes",
          dest: 0,
          screenX: ev.screenX,
          screenY: ev.screenY
        });
      });

      chrome.runtime.onMessage.addListener(function(message) {
        if (message.type == "frame-attributes-response") {
          util.dump("frame-attributes-response: " + JSON.stringify(message.result));
          scroller.frameElement = message.result;
          parentInfoNeeded = false;
          if (message.result.unloadListeners) loadListeners(false);
        }
      });
    }
  });

  // message listener
  chrome.runtime.onMessage.addListener(function(message, sender) {
    if (message.type == "iframe-push") {
      let urlmatch = function(a, b) { return a.replace(/\/$/, "~").indexOf(b.replace(/\/$/, "~")) == 0; };
      if (document == null) return;
      let found = message.value.find(function(elm) { return urlmatch(document.URL, elm.src); });
      if (found !== undefined) {
        scroller.frameElement = found;
        util.dump("frame element set " + found.src + " by push");
      }
    }
  });

  let checkBlacklist = function(uri, blacklist) {
    if (blacklist === undefined) return true;
    return (blacklist.filter(function(pattern) {
      if (RegExp(pattern).test(uri)) {
        util.dump("blacklist pattern [" + pattern + "] matched to [" + uri + "]\n");
        return true;
      }
      return false;
    }).length == 0);
  };

  let updatePreferences = function(updateEnabledPrefs, updateScrollPrefs, getKeys) {
    chrome.storage.local.get(getKeys, (prefs) => {
      if (updateEnabledPrefs) loadListeners(checkBlacklist(document.URL, prefs.blacklist) && prefs.enabled);
      if (updateScrollPrefs) yass.refreshPreferences(prefs);
    });
  };

  // storage change event listener
  chrome.storage.onChanged.addListener(function(changes, area) {
    if (area != "local") return;
    if ("tick-wheel" in changes) return;
    if ("blacklist" in changes) parentInfoNeeded = true; // need refresh for parent blacklist status

    // optimize, choose a fragment to load and update
    let changedEnabled = (("blacklist" in changes) || ("enabled" in changes));
    updatePreferences(changedEnabled, !changedEnabled, changedEnabled ? ["blacklist", "enabled"] : null);
  });

  setTimeout(function() {
    updatePreferences(true, true, null);
  }, 10);

})();
