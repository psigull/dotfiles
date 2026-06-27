// ==UserScript==
// @name         Third-Party Popunder Defuser
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Intercepts and blocks third-party popups and popunders while leaving first-party windows alone.
// @author       You
// @match        *://*/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Helper to extract the core domain (e.g., "example.com" from "sub.example.com")
    function getCoreDomain(urlStr) {
        try {
            const url = new URL(urlStr, window.location.href);
            const parts = url.hostname.split('.');
            if (parts.length > 2) {
                return parts.slice(-2).join('.');
            }
            return url.hostname;
        } catch (e) {
            return null; // Invalid URL structure
        }
    }

    const currentCoreDomain = getCoreDomain(window.location.href);

    // Save the native window.open function
    const nativeOpen = window.open;

    // Overwrite window.open with our gatekeeper
    window.open = function(url, name, specs) {
        if (!url || url === 'about:blank') {
            // Some ads open a blank window first and write to it later.
            // We can monitor these or block them if they lack explicit user intent.
            console.warn('[Popunder Shield] Blocked an ambiguous blank popup attempt.');
            return null;
        }

        const targetCoreDomain = getCoreDomain(url);

        // Third-Party Check: If domains do not match, destroy the popunder
        if (targetCoreDomain && targetCoreDomain !== currentCoreDomain) {
            console.log(`[Popunder Shield] BLOCKED third-party popunder to: ${url}`);
            return null;
        }

        // First-party pass: Let the browser process it normally
        console.log(`[Popunder Shield] Allowed first-party popup to: ${url}`);
        return nativeOpen.apply(this, arguments);
    };
})();
