"use strict";
if (typeof console == 'undefined')console = {log: function () {
    console.A.push(arguments)
}, A: [], warn: function (B) {
    alert(B.C ? B.message + '\n' + B.C : (B.message || B.B || B))
}, error: function () {
    console.warn.apply(null, arguments)
}, assert: function (D, B) {
    if (!D)throw new Error("Assertion failed: " + B)
}};
Function.prototype.F = function (G, prefix) {
    for (var H in G.prototype) {
        if (this.prototype[H]) {
            if (/Phase$/.test(H)) {
                console.warn("Overriding " + prefix + "." + H + " () in ", this);
            }
            this.prototype[prefix + "$" + H] = G.prototype[H];
        } else {
            this.prototype[H] = G.prototype[H];
        }
    }
    if (G.prototype.hasOwnProperty("toString")) {
        if (this.prototype.hasOwnProperty("toString")) {
            this.prototype[prefix + "$toString"] = G.prototype.toString;
        } else {
            this.prototype.toString = G.prototype.toString;
        }
    }
};
function I(J) {
    for (var K in J)return K
};
Function.prototype.L = function () {
    for (var method in this.prototype)if (!this.prototype[method].M)this.prototype[method].M = this;
};
(function () {
    return function N(O, P) {
        for (var Q in P)if (!O[Q])O[Q] = P[Q]; else N(O[Q], P[Q]);
    }
})()(this, {R: {S: {T: {lang: {À: {}}}, Ĵ: {Ø: {}}}}});
if (typeof R.S.T.lang.À.Ŭ == 'undefined')R.S.T.lang.À.Ŭ = (function () {
    var Ŭ = function Ŭ() {
        if (!(false)) {
            throw new Error('assertion error');
        }
    };
    Ŭ.prototype.Ŭ = Ŭ;
    Ŭ.ŭ = function ŭ(Ů) {
        var ů = {};
        for (var Q = 0; Q < Ů.length; Q += 2) {
            ů[Ů[Q]] = Ů[Q + 1];
        }
        return ů;
    };
    Ŭ.get = function get(ů, key) {
        return ů[key];
    };
    Ŭ.Ű = function Ű(ů, ű, Ų) {
        return ů[ű][Ų];
    };
    Ŭ.ų = function ų(ů, key, value) {
        ů[key] = value;
    };
    Ŭ.Ŵ = function Ŵ() {
        for (var ŵ in{Ŷ: true}) {
            return ŵ != "cryptTest";
        }
    };
    Ŭ.ŷ = function ŷ(Ÿ, method, Ź) {
        function À(Ÿ) {
            var name = Ÿ.split(".");
            if (!(name.length > 0)) {
                throw new Error('assertion error');
            }
            var ź = null;
            switch (name.shift()) {
                case "SDL":
                    ź = Ż;
                    break;
                case "Xopus":
                    ź = ż;
                    break;
                default:
                    ;
            }
            for (var Q = 0; Q < name.length; ++Q) {
                ź = ź[name[Q]];
            }
            return ź;
        }

        var ź = null;
        if (typeof Ÿ === "string") {
            ź = À(Ÿ);
        } else {
            ź = Ÿ;
        }
        if (method) {
            if (!(typeof method === "string")) {
                throw new Error('assertion error');
            }
            if (!(Ź.constructor === Array)) {
                throw new Error('assertion error');
            }
            return ź[method].apply(ź, Ź);
        } else {
            if (!(!Ź)) {
                throw new Error('assertion error');
            }
            return ź;
        }
    };
    if (!Ŭ.name)Ŭ.name = I({Ŭ: 1});
    Ŭ.L();
    return Ŭ;
})();
if (typeof R.S.Ĵ.Ø.iG == 'undefined')R.S.Ĵ.Ø.iG = (function () {
    var Ŭ = R.S.T.lang.À.Ŭ;
    var iG = function iG() {
        this.Ø = null;
        this.map = {};
        this.ء = {};
    };
    iG.prototype.iG = iG;
    iG.prototype["registerAPI"] = function () {
        return this.jG.apply(this, arguments)
    };
    iG.prototype.jG = function jG(Ø, name) {
        this.map[name] = Ø;
        this.kG(Ø, name);
    };
    iG.prototype["getAPI"] = function () {
        return this.ÕB.apply(this, arguments)
    };
    iG.prototype.ÕB = function ÕB(name) {
        return this.map[name] || null;
    };
    iG.prototype.kG = function kG(Ø, name) {
        var ء = [];
        if (this.ء[undefined]) {
            ء = ء.concat(this.ء[undefined]);
        }
        if (this.ء[name]) {
            ء = ء.concat(this.ء[name]);
        }
        for (var ǬA, Q = 0, ǁ = ء.length; Q < ǁ; Q++) {
            ǬA = ء[Q];
            if (typeof ǬA == "function") {
                ǬA(Ø, name);
            } else if (ǬA !== null && typeof ǬA == "object" && typeof ǬA.lG == "function") {
                ǬA.lG(Ø, name);
            }
        }
    };
    iG.prototype["addListener"] = function () {
        return this.ϩ.apply(this, arguments)
    };
    iG.prototype.ϩ = function ϩ(ǬA, name) {
        if (!this.ء[name]) {
            this.ء[name] = [];
        }
        this.ء[name].push(ǬA);
    };
    iG.prototype["removeListener"] = function () {
        return this.ǨA.apply(this, arguments)
    };
    iG.prototype.ǨA = function ǨA(ǬA, name) {
        if (!this.ء[name]) {
            return;
        }
        for (var Q = this.ء[name].length; Q--;) {
            if (this.ء[name][Q] === ǬA) {
                this.ء[name].splice(Q, 1);
            }
        }
    };
    if (!iG.name)iG.name = I({iG: 1});
    iG.L();
    (function () {
        var Ø = Ŭ.ŭ(["EmbeddedXopus", new iG]);
        for (var Q in Ø) {
            window[Q] = Ø[Q];
        }
    })();
    return iG;
})();