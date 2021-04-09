/*global util*/
var scrollerClasses = {};
// class scroller that have no edge element
// also the base class of edge scroller
scrollerClasses.ScrollerNoEdge = class {
  constructor(orig, b, log) {
    this.target = orig;
    this.body = b;
    this.log = log;
    this.offset = 0;
    this.animation = null;
    this.edgeSize = 60;
  }
  backupStyle(elm, styleName) {
    let backupName = "_yass_initial_" + styleName;
    if (!(backupName in elm)) elm[backupName] = elm.style[styleName];
  }
  restoreStyle(elm, styleName) {
    let backupName = "_yass_initial_" + styleName;
    if (backupName in elm) elm.style[styleName] = elm[backupName];
  }
  get scrollTop() {
    return this.body.scrollTop;
  }
  get vpos() {
    return this.body.scrollTop + this.offset;
  }
  get scrollTopMax() {
    // a rare case but transform animation cause horiz scroll bar to appear and it changes scrollHeight which we want to ignore
    if (this.animation !== null) return this._scrollTopMax;

    let clientHeight = this.body.clientHeight;
    if (this.body == document.body)
      if (this.body.clientHeight <= 20 || (document.documentElement.clientHeight < this.body.clientHeight))
        clientHeight = document.documentElement.clientHeight;

    let newValue = this.body.scrollHeight - clientHeight;
    if (this._scrollTopMax != newValue) {
      this.onMaxScrollChange();
      this._scrollTopMax = newValue;
    }
    return newValue;
  }
  activate() {
    this.body._yass_ownedby = this;
    this.speedLog = [];
    this.onBounceBack = () => {};
    this.transformTarget = (this.body == document.documentElement) ? document.body : this.body; // do not transform HTML
    this.scrollTopMax; // call getter
    if (getComputedStyle(this.body).getPropertyValue("scroll-behavior") == "smooth") {
      this.backupStyle(this.body, "scrollBehavior");
      this.body.style.scrollBehavior = "auto";
    }
  }
  adjust(delta) {
    if (this.scrollTopMax <= 0) return false;
    return this.adjustExt(delta);
  }
  adjustExt(delta) {
    // on the edge
    // (chrome issue) on zoomed out content scrollTop is rounded and might not be equal to maxscroll (stop at 1px less)
    if ((this.body.scrollTop == 0 && delta < 0)
      || ((this.scrollTopmax - this.body.scrollTop) <= 1 && delta > 0)) return false;
    return true;
  }
  onMaxScrollChange() {
  }
  scrollovercheck(hint) {
    if (this.offset == 0) {
      return (
        (hint > 0 && this.body.scrollTop < this.scrollTopMax) ||
        (hint < 0 && this.body.scrollTop > 0));
    }
    else {
      return !((this.offset > 0 && hint > 0) || (this.offset < 0 && hint < 0));
    }
  }
  stop() {
    if (this.animation) {
      this.animation.finish();
      this.animation = null;
    }
    this.offset = 0;
  }
  release() {
    this.stop();
    if (this.body._yass_ownedby == this) this.body._yass_ownedby = null;
    this.restoreStyle(this.body, "scrollBehavior");
    this.body = null;
  }
  renderBounce() {
    this.onBounceBack();
    this.stop();
  }
  render(pos, ftime, delta) {
    this.speedLog.push([ftime, delta]);
    if (this.speedLog.length > 30) this.speedLog = this.speedLog.slice(-7);

    let scrollTopMax = this.scrollTopMax;

    if (pos < 0) {
      this.offset = pos;
      this.body.scrollTop = 0;
      this.renderBounce();
      return false; // break funcWheel recursive loop
    }
    else if (pos > scrollTopMax) {
      this.offset = pos - scrollTopMax;
      this.body.scrollTop = scrollTopMax;
      this.renderBounce();
      return false; // break funcWheel recursive loop
    }
    else {
      // normal scroll - set scrollTop
      this.offset = 0;
      this.body.scrollTop = pos;
      return true;
    }
  }
};

// class scroller
scrollerClasses.Scroller = class extends scrollerClasses.ScrollerNoEdge {
  constructor(orig, b, log) {
    super(orig, b, log);
  }
  adjustExt(delta) {
    return true;
  }
  onMaxScrollChange() {
    // some pages have absolute positioned element longer than body (ex. side menu not by float)
    // which leads scroll height without fitting body height. causes glitchy bounce animation on bottom side.
    if (this.transformTarget == document.body) {
      this.designatedBodyHeightStyle = null;
      let bodyStyle = getComputedStyle(document.body);
      // Dont want to care about margin collapsing and other CSS layout issue, so use boundingClientRect.bottom and scrollTop
      // to know bottom edge of body element.
      let diff = this.body.scrollHeight - this.body.scrollTop
        - Math.round(document.body.getBoundingClientRect().bottom + util.CSSToFloat(bodyStyle, "margin-bottom"));
      if (diff > 0) this.designatedBodyHeightStyle = (util.CSSToFloat(bodyStyle, "height") + diff) + "px";
    }
  }
  bouncingAnimationCurve(speed, edgeSize, edgeTime) {
    speed = (isNaN(speed) || speed <= 0) ? 0.0001 : speed;
    let offsetBackward = util.range(0.2 / speed + 0.05, 0.08, 0.25); // heuristic adjustment (keep backward bounce speed consistency)
    let f = (Math.max(0.1, speed) / ((edgeSize * 2) / (edgeTime * offsetBackward)));
    let fedge = Math.min(1.0, f);
    let ftime = fedge / f;
    // curve is for 0.9143 speed ( (edgesize * 2) / (duration * offsetBackward) )
    return {edgeSize: edgeSize * fedge, duration: edgeTime * ftime, offsetBackward: offsetBackward,
      easingForward: "cubic-bezier(.3, .7, .65, 1.0)",
      easingBackward: "cubic-bezier(.35, .0, .45, 1.0)"};
  }
  // commit bouncing animation
  renderBounce() {
    if (this.animation) this.animation.finish();

    let speedLog = this.speedLog.slice(-7);
    this.speedLog = [];
    let sum, direction;
    let restoreHtmlHeightStyle = () => {};
    let restoreBodyHeightStyle = () => {};
    if (this.offset < 0) {
      sum = speedLog.reduce((i, e) => (e[1] < 0) ? [i[0] + e[0], i[1] - e[1]] : i, [0, 0]);
      direction = 1;
    }
    else { // if (offsetScroll > 0)
      sum = speedLog.reduce((i, e) => (e[1] > 0) ? [i[0] + e[0], i[1] + e[1]] : i, [0, 0]);
      direction = -1;
      // some pages use height:100% on html to make a too short content fit to viewport.
      // but this causes layout collision with negative y translation of body.
      if (this.transformTarget === document.body) {
        restoreHtmlHeightStyle = () => { this.restoreStyle(document.documentElement, "height"); };
        this.backupStyle(document.documentElement, "height");
        document.documentElement.style.height = "auto";
      }
      // and longer absolute position element problem
      if (this.designatedBodyHeightStyle) {
        restoreBodyHeightStyle = () => { this.restoreStyle(document.body, "height"); };
        this.backupStyle(document.body, "height");
        document.body.style.height = this.designatedBodyHeightStyle;
      }
    }

    // commit animation
    let speed = sum[1] / sum[0]; // distance / time
    let animInfo = this.bouncingAnimationCurve(speed, this.edgeSize, 700);
    let anim = this.transformTarget.animate([
      {transform: "translateY(0px)", easing: animInfo.easingForward },
      {transform: "translateY(" + (direction * animInfo.edgeSize) + "px)", easing: animInfo.easingBackward, offset: animInfo.offsetBackward },
      {transform: "translateY(0px)"}], {duration: animInfo.duration, fill: "none"});
    anim.onfinish = () => {
      this.offset = 0;
      this.animation = null;
      restoreHtmlHeightStyle();
      restoreBodyHeightStyle();
    };
    // calculate aproximate time offset from current position over the edge (assume curve of anim as 0.45 tilt linear)
    anim.currentTime = animInfo.duration * animInfo.offsetBackward * Math.min(0.5, (Math.abs(this.offset) / animInfo.edgeSize)) * 0.45;
    this.animation = anim;
    setTimeout(this.onBounceBack, animInfo.duration * animInfo.offsetBackward);
  }
};

var scroller = { // eslint-disable-line no-unused-vars

  frameElement: { scrolling: "", parent: -1 },
  edgeSize: 0,
  get active() { return this.m_activeRequest != 0; },

  m_activeRequest: 0,
  m_sobj: null,
  m_jumpto: 0,
  m_jumptoremain: 0,
  m_resetsmooth: false,
  m_travelStartPos: 0,

  // private
  assignScrollObject: function(newobj) {
    this.m_sobj = newobj;
    newobj.activate();
    // reset variables
    this.m_travelStartPos = newobj.scrollTop;
    this.m_jumpto = newobj.scrollTop;
    this.m_jumptoremain = 0;
  },

  hasTarget: function() { return this.m_sobj !== null; },

  // for whom interested only in offset from edges but height of a target,
  // returns -edgeSize 0 <- 500 -> 1000 +edgeSize
  virtualPosition: function() {
    let vpos = this.m_sobj.vpos;
    if (vpos < this.m_sobj.scrollTopMax / 2) return Math.min(500, vpos);
    return Math.max(500, vpos - this.m_sobj.scrollTopMax + 1000);
  },

  documentHeight: function() { return this.m_sobj.scrollTopMax; },

  pageHeight: function() { return this.m_sobj.body.clientHeight; },

  animationDirection: function() { return this.m_jumpto - this.m_sobj.scrollTop; },

  bouncing: function() { return this.m_sobj !== null && this.m_sobj.animation !== null; },

  bouncyEdgeSize: function() { return Math.min(this.pageHeight() * 0.25, this.edgeSize); },

  setBouncyEdgeAppearance: function(opaque) {},

  travelDistance: function() { return Math.abs(this.m_sobj.vpos - this.m_travelStartPos); },

  // initiate to stop animation
  softStop: function() {
    if (!this.hasTarget() || this.bouncing()) return;
    this.m_jumpto = this.m_sobj.scrollTop;
  },

  // stop animation immediately and release target
  clearTarget: function() {
    cancelAnimationFrame(this.m_activeRequest);
    this.m_activeRequest = 0;
    if (this.m_sobj) this.m_sobj.release();
    this.m_sobj = null;
  },

  smoothScrollBy: function(delta, deaccel, bdump, dump) {

    let edgelimit = this.bouncyEdgeSize() + 25;

    if (this.m_activeRequest == 0) {
      let ctm = performance.now();
      // changing scroll target's (most case it is body) "overflow" to hidden,fixed implesitly makes scrollHeight to 0
      // few pages (facebook) make scrolling target's "overflow" to fixed for preventing scrolling when showing modal dialog
      this.m_resetsmooth = false;
      // something special power prevents scrollTop to be just 1pixel up so
      this.m_sobj.body.scrollTop = (this.m_sobj.body.scrollTop - ((delta < 0) ? 1.0000001 : -1));
      let scrollTop = this.m_sobj.scrollTop;
      this.m_jumpto = scrollTop - 0 + delta + ((delta * this.m_jumptoremain > 0) ? this.m_jumptoremain : 0);
      this.m_jumpto = util.range(this.m_jumpto, -edgelimit, this.m_sobj.scrollTopMax + edgelimit);
      this.m_jumptoremain = 0;
      this.m_travelStartPos = scrollTop;
      this.m_sobj.edgeSize = this.bouncyEdgeSize(); // update with latest edge size
      this.m_sobj.onBounceBack = () => { this.m_activeRequest = 0; }; // allow restart scroll when bounce back starts

      this.m_activeRequest = requestAnimationFrame((HRTime) => this.funcWheel(HRTime, bdump, dump, scrollTop, scrollTop, ctm - 17, ctm, 0));
    }
    else {
      this.m_resetsmooth = true;
      if (deaccel < 1.0) this.m_jumpto += (this.m_sobj.scrollTop - this.m_jumpto) * deaccel;
      else               this.m_jumpto += delta;
      this.m_jumpto = util.range(this.m_jumpto, -edgelimit, this.m_sobj.scrollTopMax + edgelimit);
    }
  },

  funcWheel: function(ctm, baseForeDumping, baseDumping, vpos, lastScrollTop, lastFuncTime, beginSmoothTime, lastDelta) {
    let stop = () => {
      this.m_activeRequest = 0;
      if (this.m_sobj) this.m_sobj.stop();
    };

    if (this.m_sobj == null) {
      stop();
      return;
    }

    let frameTime = (ctm - lastFuncTime);
    // not a common case but initial lastFuncTime can be larger than ctm
    // minimum frameTime is chosen concerning 144hz refresh rate
    frameTime = util.range(frameTime, 6.0, 34.0);

    let fordest = (this.m_jumpto - vpos);

    let bdump = baseForeDumping;
    let dump = baseDumping;

    bdump *= 2000;

    let d = 0;
    let totalTime = 0;
    let lastd = 0;

    let bdumpfunc = (time_, dump_) => util.range(time_ / dump_, 0.05, 1.0);

    do {
      let sliceTime = Math.min(frameTime - totalTime, 17.0);
      totalTime += sliceTime;
      let sliceDump = dump * (sliceTime / 17.0); // dump scaled by fragment time length
      let fordestSlice = fordest - d; // distance for dest on this time slice (signed)

      // dumping of begining
      let bDumpScale = 1.0;
      if (bdump > 0.0) {
        // reset forepart smoothing, if shoud do
        if (this.m_resetsmooth) {
          this.m_resetsmooth = false;

          for (let smoothtime = ctm; beginSmoothTime <= smoothtime; smoothtime -= 34.0) {
            let timeFromEvent = (ctm + 17.0 + totalTime) - smoothtime;
            let nextd = fordestSlice * sliceDump * bdumpfunc(timeFromEvent, bdump);
            if (lastDelta / nextd < 1.0) { // abs(lastd) < abs(nextd)
              // found new beginsmoothtime
              beginSmoothTime = smoothtime;
              break;
            }
          }
        }

        let timeFromEvent = (ctm + 17.0 + totalTime) - beginSmoothTime;
        bDumpScale = bdumpfunc(timeFromEvent, bdump);
      }

      d += fordestSlice * sliceDump * bDumpScale;
      if (lastd == 0) lastd = d;

    } while (frameTime - totalTime > 4);

    vpos += d;

    // adjust maxscroll (autopagerize or somthing dynamically add elements on m_sobj.body)
    if (this.m_sobj.adjust(d) == false) {
      stop();
      return;
    }

    let lenfordest = fordest * fordest;
    if ((!this.bouncing() && (lenfordest <= 1.0 || (lenfordest < 100.0 && d * d < 0.2))) || this.m_sobj.scrollTop != lastScrollTop) {
      // animation finished. normal exit.
      stop();
      this.m_jumptoremain = fordest;
      return;
    }

    if (this.m_sobj.render(vpos, frameTime, d) == false) {
      // scroller object intent to break loop for some reason
      return;
    }

    lastScrollTop = this.m_sobj.scrollTop;

    this.m_activeRequest = requestAnimationFrame((HRTime) => this.funcWheel(HRTime, baseForeDumping, baseDumping, vpos, lastScrollTop, ctm, beginSmoothTime, lastd));
  },

  // based on the code in All-in-One Gestures
  findNodeToScroll: function(orig, hint, ev) {

    // 0 neither scrollable 1 horizontal only  2 vertical only 3 both
    function getscrolltype(wscroll, wclient, hscroll, hclient) {
      if (hclient < 50) return 0;
      if (hscroll - hclient < 10) hclient = hscroll; // too small to scroll
      let flag = 0;
      if (wscroll > wclient) flag += 1;
      if (hscroll > hclient) flag += 2;
      return flag;
    }

    let newobject = (p) => {
      let editable = false;
      if (p.nodeName.toLowerCase() == "textarea") editable = true;
      let mode = (p.ownerDocument && p.ownerDocument.designMode) ? p.ownerDocument.designMode : "off";
      if (mode && mode.toLowerCase() == "on") editable = true;
      if (p.isContentEditable) editable = true;
      if (p.style["-webkit-user-modify"] != "") editable = true;
      if (editable) return scrollerClasses.ScrollerNoEdge;
      if (this.edgeSize == 0) return scrollerClasses.ScrollerNoEdge;
      return scrollerClasses.Scroller;
    };

    if (!orig.ownerDocument) {
      util.dump("ownerDocument unreachable");
      return null;
    }

    let doc = orig.ownerDocument.documentElement;
    if (doc && doc.nodeName.toLowerCase() != "html") {
      util.dump("doc is " + doc.nodeName + " not html\n");
      return null;
    }

    let bodies = doc.getElementsByTagName("body");
    if (!bodies || bodies.length == 0) {
      util.dump("no body\n");
      return null;
    }
    let body = bodies[0];

    let screlm = orig.ownerDocument.scrollingElement;
    if (!screlm) {
      util.dump("no scrollingElement");
      return null;
    }

    // true: scrollable / false: bottom most or top most
    let scrollovercheck =
      (hint == 0) ? (() => true)
        : ((hint < 0) ? ((n, a, b) => (("_yass_ownedby" in n) && n._yass_ownedby) ? n._yass_ownedby.scrollovercheck(hint) : (a > 0))
                      : ((n, a, b) => (("_yass_ownedby" in n) && n._yass_ownedby) ? n._yass_ownedby.scrollovercheck(hint) : (a < b) && (b > 1)));
    //                there are some region unmovable really but looks 1px scrollable ------------------------------------------------------^

    // shadowDOM support
    let path = (ev.composed) ? ev.composedPath() : [];
    if (path.length == 0) {
      // mimic composedPath() result by an usual parentNode tracking
      for (let n = orig; n; n = n.parentNode) path.push(n);
    }
    path = path.filter(e => e instanceof Element);
    let node = path.shift();

    let bodyOverflowValue = null;
    let log = "";

    while (node) {
      if (node == doc || node == body) node = screlm;

      let nodename = node.nodeName.toLowerCase();

      /*log*/ log += nodename;

      if (/^(option|optgroup)$/.test(nodename)) {
        util.dump("option found :" + log);
        return null;
      }

      let overflowprop = getComputedStyle(node).getPropertyValue("overflow-y");
      if (node == body) bodyOverflowValue = overflowprop;

      if (node.clientWidth && node.clientHeight &&
        (overflowprop != "hidden") &&
        (node == doc || node == body || overflowprop != "visible")
      ) {
        let scrolltype = getscrolltype(0, 0, node.scrollHeight, node.clientHeight);

        /*log*/ log += "(" + node.scrollTop + " " + node.clientHeight + " " + node.scrollHeight + ")";

        // scroll focus overflow
        if ((scrolltype >= 2) && scrollovercheck(node, node.scrollTop, node.scrollHeight - node.clientHeight)) {
          // if this is in a unscrollable frame element
          if ((node == doc || node == body) && this.frameElement.scrolling.toLowerCase() == "no") {
            util.dump("unscrollable frame");
            return 2;
          }

          return new(newobject(node))(orig, node, log);
        }
      }

      if (node == screlm) break;

      /*log*/ log += ">";

      node = path.shift();

    }

    if (this.frameElement.parent >= 0) {
      util.dump(log + " passing upper frame");
      return 2;
    }

    // no scrollable area found in content ( mainly for image only page to handle )

    if (screlm.scrollHeight - screlm.clientHeight > 1) {
      if (screlm == body && bodyOverflowValue && bodyOverflowValue == "hidden") {
        log += " *DEFAULT hidden body*";
        return null;
      }
      log += " *DEFAULT " + screlm.nodeName + "*";
      return new(newobject(screlm))(orig, screlm, log);
    }

    util.dump(log + " *continue*\n");
    return 1;
  },

  refreshTarget: function(target, detail, ev) {
    // the reason this is here is just frequency of execution.
    // externally ordered for releasing of m_sobj
    if (target === null) { this.clearTarget(); return; }

    let newobj = this.findNodeToScroll(target, detail, ev);
    // null : stop immediately
    // object not activated : change to it
    // 1 : do not change the target
    // 2 : event should be passed to parent frame

    if (newobj === 1) return;

    if (newobj === 2) {
      this.clearTarget();
      return;
    }

    if (newobj === null) {
      this.clearTarget();
      util.dump("N: target null\n");
    }
    else if (this.m_sobj && newobj.body != this.m_sobj.body) {
      this.clearTarget();
      this.assignScrollObject(newobj);
      util.dump("A:");
    }
    else if (this.m_sobj === null) {
      this.assignScrollObject(newobj);
      util.dump("B:");
    }

    if (newobj) {
      util.dump(newobj.log + "\n");
    }
  }
};
