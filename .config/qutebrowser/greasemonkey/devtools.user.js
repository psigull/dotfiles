// ==UserScript==
// @name         Kill Disable-Devtool
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Stop websites from disabling devtools
// @match        *://*/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Define a dummy object so when the script loads, it attaches to nothing or does nothing
    Object.defineProperty(window, 'DisableDevtool', {
        value: function() { console.log("disable-devtool intercepted and killed. 🖖"); },
        writable: false,
        configurable: false
    });

	// 1. Overwrite console.clear with an empty function
    console.clear = function() {
        console.log("[Blocked an attempt to clear the console]");
    };

    // 2. Lock it down so the website's scripts cannot overwrite it back
    Object.defineProperty(console, 'clear', {
        writable: false,
        configurable: false
    });
})();
