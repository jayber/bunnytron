﻿function eG() {
    var scripts = document.getElementsByTagName("script");
    for (var Q = 0; Q < scripts.length; Q++)if (scripts[Q].src.match(/xopus.js/))return scripts[Q].src;
}
function fG(gG) {
    document.location.replace(gG.replace(/xopus\.js/, "xopus.html") + "#" + document.location.pathname + document.location.search + document.location.hash);
}
function hG() {
    try {
        var ɡB = window;
        while (!(ɡB.ND || ɡB.startXopus) && ɡB.parent != ɡB)ɡB = ɡB.parent;
        return!!(ɡB.ND || ɡB.startXopus);
    } catch (ǟA) {
    }
}
if (!hG())fG(eG());