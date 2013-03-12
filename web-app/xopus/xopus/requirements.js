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
})()(this, {R: {S: {T: {lang: {w: {}, À: {}, debug: {}, error: {}, a: {}, k: {}, log: {}, object: {}}, platform: {}}}}});
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
if (typeof R.S.T.lang.w.ƽ == 'undefined')R.S.T.lang.w.ƽ = (function () {
    var ƽ = function ƽ() {
    };
    ƽ.prototype.ƽ = ƽ;
    ƽ.ƾ = function ƾ(ƿ) {
        for (var ƿ = ƿ.concat().sort(), Q = ƿ.length - 1; Q >= 0; Q--) {
            if (ƿ[Q] == ƿ[Q - 1]) {
                ƿ.splice(Q, 1);
            }
        }
        return ƿ;
    };
    ƽ.ǀ = function ǀ(ů) {
        return typeof ů == "object" && ů.constructor === Array;
    };
    ƽ.toArray = function toArray(Ů) {
        if (typeof Ů.item != "undefined") {
            for (var ƿ = [], Q = 0, ǁ = Ů.ǂ ? Ů.ǂ() : Ů.length; Q < ǁ; ++Q) {
                ƿ.push(Ů.item(Q));
            }
        } else {
            for (var ƿ = [], Q = 0, ǁ = Ů.length; Q < ǁ; ++Q) {
                ƿ.push(Ů[Q]);
            }
        }
        return ƿ;
    };
    ƽ.ǃ = function ǃ(ƿ, value) {
        for (var Q = 0; (Q = ƿ.indexOf(value)) != -1;) {
            return ƿ;
        }
    };
    ƽ.Ǆ = function Ǆ(ƿ, value) {
        for (var Q = ƿ.length; Q--;) {
            if (ƿ[Q] === value) {
                return void ƿ.splice(Q, 1);
            }
        }
    };
    ƽ.ǅ = function ǅ(ǆ) {
        var Ǉ = this.length;
        var ǈ = Number(arguments[1]) || 0;
        ǈ = (ǈ < 0) ? Math.ceil(ǈ) : Math.floor(ǈ);
        if (ǈ < 0) {
            ǈ += Ǉ;
        }
        for (; ǈ < Ǉ; ǈ++) {
            if (ǈ in this && this[ǈ] === ǆ) {
                return ǈ;
            }
        }
        return-1;
    };
    ƽ.ǉ = function ǉ(ǆ) {
        var Ǉ = this.length;
        var ǈ = Number(arguments[1]);
        if (isNaN(ǈ)) {
            ǈ = Ǉ - 1;
        } else {
            ǈ = (ǈ < 0) ? Math.ceil(ǈ) : Math.floor(ǈ);
            if (ǈ < 0) {
                ǈ += Ǉ;
            } else if (ǈ >= Ǉ) {
                ǈ = Ǉ - 1;
            }
        }
        for (; ǈ > -1; ǈ--) {
            if (ǈ in this && this[ǈ] === ǆ) {
                return ǈ;
            }
        }
        return-1;
    };
    ƽ.Ǌ = function Ǌ(Ɖ) {
        var Ǉ = this.length;
        if (typeof Ɖ != "function") {
            throw new TypeError;
        }
        var ǋ = new Array(Ǉ);
        var ǌ = arguments[1];
        for (var Q = 0; Q < Ǉ; Q++) {
            if (Q in this) {
                ǋ[Q] = Ɖ.call(ǌ, this[Q], Q, this);
            }
        }
        return ǋ;
    };
    ƽ.Ǎ = function Ǎ(Ɖ) {
        var Ǉ = this.length;
        if (typeof Ɖ != "function") {
            throw new TypeError;
        }
        var ǌ = arguments[1];
        for (var Q = 0; Q < Ǉ; Q++) {
            if (Q in this) {
                Ɖ.call(ǌ, this[Q], Q, this);
            }
        }
    };
    ƽ.ǎ = function ǎ(Ɖ) {
        var Ǉ = this.length;
        if (typeof Ɖ != "function") {
            throw new TypeError;
        }
        var ǋ = new Array;
        var ǌ = arguments[1];
        for (var Q = 0; Q < Ǉ; Q++) {
            if (Q in this) {
                var Ǐ = this[Q];
                if (Ɖ.call(ǌ, Ǐ, Q, this)) {
                    ǋ.push(Ǐ);
                }
            }
        }
        return ǋ;
    };
    ƽ.ǐ = function ǐ(Ɖ) {
        var Ǉ = this.length;
        if (typeof Ɖ != "function") {
            throw new TypeError;
        }
        var ǌ = arguments[1];
        for (var Q = 0; Q < Ǉ; Q++) {
            if (Q in this && !Ɖ.call(ǌ, this[Q], Q, this)) {
                return false;
            }
        }
        return true;
    };
    ƽ.Ǒ = function Ǒ(ǒ) {
        return this[this.length - 1 + (ǒ || 0)];
    };
    ƽ.Ǔ = function Ǔ(Ɖ) {
        var Ǉ = this.length;
        if (typeof Ɖ != "function") {
            throw new TypeError;
        }
        if (Ǉ == 0 && arguments.length == 1) {
            throw new TypeError;
        }
        var Q = 0;
        if (arguments.length >= 2) {
            var ǔ = arguments[1];
        } else {
            do {
                if (Q in this) {
                    ǔ = this[Q++];
                    break;
                }
                if (++Q >= Ǉ) {
                    throw new TypeError;
                }
            } while (true);
        }
        for (; Q < Ǉ; Q++) {
            if (Q in this) {
                ǔ = Ɖ.call(null, ǔ, this[Q], Q, this);
            }
        }
        return ǔ;
    };
    ƽ.Ǖ = function Ǖ(Ɖ) {
        var Ǉ = this.length;
        if (typeof Ɖ != "function") {
            throw new TypeError;
        }
        if (Ǉ == 0 && arguments.length == 1) {
            throw new TypeError;
        }
        var Q = Ǉ - 1;
        if (arguments.length >= 2) {
            var ǔ = arguments[1];
        } else {
            do {
                if (Q in this) {
                    ǔ = this[Q--];
                    break;
                }
                if (--Q < 0) {
                    throw new TypeError;
                }
            } while (true);
        }
        for (; Q >= 0; Q--) {
            if (Q in this) {
                ǔ = Ɖ.call(null, ǔ, this[Q], Q, this);
            }
        }
        return ǔ;
    };
    ƽ.ǖ = function ǖ(Ǘ, ǘ) {
        var O;
        if (this.constructor == Array) {
            O = this;
        } else {
            O = [];
            for (var Q = 0; Q < this.length; Q++) {
                O[Q] = this[Q];
            }
        }
        return O.slice(Ǘ === undefined ? 0 : Ǘ, ǘ === undefined ? O.length + 1 : ǘ);
    };
    ƽ.Ǚ = function Ǚ(ƿ, Ɖ, ǌ) {
        if (typeof Ɖ != "function") {
            throw new TypeError;
        }
        var ǋ = [];
        var ǌ = arguments[2];
        for (var Q = 0; Q < ƿ.length; Q++) {
            if (Q in ƿ) {
                var Ǐ = ƿ[Q];
                if (Ɖ.call(ǌ, Ǐ, Q, ƿ)) {
                    ǋ.push.apply(ǋ, ƿ.splice(Q--, 1));
                }
            }
        }
        return ǋ;
    };
    ƽ.ǚ = function ǚ() {
        for (var Ǜ, x, Q = this.length; Q; Ǜ = parseInt(Math.random() * Q), x = this[--Q], this[Q] = this[Ǜ], this[Ǜ] = x) {
        }
        return this;
    };
    ƽ.ǜ = function ǜ(ƿ, ƃ) {
        for (var Ǐ, map = [], ǁ = ƿ.length, Q = ǁ; Q--;) {
            Ǐ = ƿ[Q];
            map.push([Ǐ, ƃ(Ǐ)]);
        }
        map.sort(function (O, P) {
            return O[1] < P[1] ? -1 : O[1] > P[1] ? 1 : 0;
        });
        for (Q = ǁ; Q--;) {
            ƿ[Q] = map[Q][0];
        }
        return ƿ;
    };
    ƽ.ǝ = function ǝ(Ǟ, ǟ) {
        var ƿ = this;
        if (typeof Ǟ != "function") {
            return false;
        }
        for (var Q = 0, ǁ = ƿ.length; Q < ǁ; ++Q) {
            if (Ǟ.call(ǟ, ƿ[Q], Q, ƿ)) {
                return true;
            }
        }
        return false;
    };
    ƽ.Ǡ = function Ǡ(ƿ, ǡ) {
        ǡ = ǡ || 1;
        do {
            var Ǣ = false;
            var ǣ;
            var Ǥ;
            var ǥ;
            for (var Q = 0, ǁ = ƿ.length; Q < ǁ; Q = Q + ǥ + 1) {
                var item = ƿ[Q];
                ǣ = 0;
                Ǥ = 0;
                ǥ = 0;
                if (typeof item == "object" && item.constructor === Array) {
                    Ǥ = 1;
                    ǣ = item.length;
                    var Ǧ = ƿ.splice(Q, 1)[0];
                    var Ů = [Q, 0].concat(Ǧ);
                    ƿ.splice.apply(ƿ, Ů);
                    Ǣ = true;
                }
                ǥ = ǣ - Ǥ;
            }
            if (!Ǣ) {
                break;
            }
        } while (ǡ--);
        return ƿ;
    };
    ƽ.clear = function clear(ƿ) {
        var length = ƿ.length;
        if (length) {
            ƿ.splice(0, length);
        }
    };
    ƽ.Ɣ = function Ɣ(ƕ) {
        if (ƕ.Array === undefined) {
            throw{name: "Initialization Error", message: "Javascript engine not yet enabled on this window"};
        }
        var ǧ = {map: ƽ.Ǌ, forEach: ƽ.Ǎ, indexOf: ƽ.ǅ, every: ƽ.ǐ, lastIndexOf: ƽ.ǉ, filter: ƽ.ǎ, Ǩ: ƽ.Ǒ, some: ƽ.ǝ, reduce: ƽ.Ǔ, reduceRight: ƽ.Ǖ};
        for (var K in ǧ) {
            if (ƕ.Array.prototype[K] === undefined) {
                ƕ.Array.prototype[K] = ǧ[K];
            }
        }
    };
    if (!ƽ.name)ƽ.name = I({ƽ: 1});
    ƽ.L();
    (function () {
        ƽ.Ɣ(window);
    })();
    return ƽ;
})();
if (typeof R.S.T.lang.error.ʇ == 'undefined')R.S.T.lang.error.ʇ = (function () {
    var ʇ = function ʇ(message, location) {
        this.message = message;
        this.location = location;
    };
    ʇ.prototype.ʇ = ʇ;
    ʇ.prototype.toString = function toString() {
        return this.message;
    };
    if (!ʇ.name)ʇ.name = I({ʇ: 1});
    ʇ.L();
    return ʇ;
})();
if (typeof R.S.T.lang.k.ʗ == 'undefined')R.S.T.lang.k.ʗ = (function () {
    var ʗ = function ʗ() {
    };
    ʗ.prototype.ʗ = ʗ;
    ʗ.ʘ = function ʘ(ů) {
        return typeof ů === "object" && ů !== null && typeof ů.constructor == "unknown";
    };
    ʗ.ʙ = function ʙ(ů) {
        return typeof ů == "function" && /\[native code\]\s*\}$/m.test(ů);
    };
    ʗ.ʚ = function ʚ(ů) {
        return ů === undefined;
    };
    ʗ.ʛ = function ʛ(ů) {
        return ů === null;
    };
    ʗ.ʜ = function ʜ(ů) {
        return typeof ů == "boolean";
    };
    ʗ.ʝ = function ʝ(ů) {
        return typeof ů == "string" || ů instanceof String;
    };
    ʗ.ʞ = function ʞ(ů) {
        return(typeof ů == "number" || ů !== null && ů instanceof Number) && !window.isNaN(ů);
    };
    ʗ.ʟ = function ʟ(ů) {
        return typeof ů == "function";
    };
    ʗ.ʠ = function ʠ(ů) {
        return typeof ů == "object" && ů !== null;
    };
    ʗ.ʡ = function ʡ(ů) {
        return typeof ů == "xml";
    };
    ʗ.ǀ = function ǀ(ů) {
        return Object.prototype.toString.call(ů) == "[object Array]";
    };
    ʗ.ʢ = function ʢ(ů) {
        return typeof ů == "object" && ů !== null && ů instanceof Date;
    };
    ʗ.ʣ = function ʣ(ů) {
        return typeof ů == "object" && ů !== null && ů instanceof RegExp;
    };
    ʗ.isNaN = function isNaN(ů) {
        return typeof ů == "number" && window.isNaN(ů);
    };
    if (!ʗ.name)ʗ.name = I({ʗ: 1});
    ʗ.L();
    return ʗ;
})();
if (typeof R.S.T.lang.log.Π == 'undefined')R.S.T.lang.log.Π = (function () {
    var Π = function Π(name) {
        if (typeof Π.Ρ[name] === "undefined") {
            this.name = name;
            this.Ρ = [];
            Π.Ρ[name] = this;
            for (var Q in Π.Σ) {
                var method = "getLogger";
                this.Ρ.push(Π.Σ[Q][method](name));
            }
        } else {
            throw new Error("logger with name '" + name + "' already exists");
        }
    };
    Π.prototype.Π = Π;
    Π.Τ = function Τ(name, Σ) {
        Π.Σ[name] = Σ;
    };
    Π.prototype.trace = function trace(B) {
        for (var Q = 0; Q < this.Ρ.length; ++Q) {
            this.Ρ[Q].trace(B);
        }
    };
    Π.prototype.debug = function debug(B) {
        for (var Q = 0; Q < this.Ρ.length; ++Q) {
            this.Ρ[Q].debug(B);
        }
    };
    Π.prototype.info = function info(B) {
        for (var Q = 0; Q < this.Ρ.length; ++Q) {
            this.Ρ[Q].info(B);
        }
    };
    Π.prototype.warn = function warn(B) {
        for (var Q = 0; Q < this.Ρ.length; ++Q) {
            this.Ρ[Q].warn(B);
        }
    };
    Π.prototype.error = function error(B) {
        for (var Q = 0; Q < this.Ρ.length; ++Q) {
            this.Ρ[Q].error(B);
        }
    };
    Π.prototype.Υ = function Υ(B) {
        for (var Q = 0; Q < this.Ρ.length; ++Q) {
            this.Ρ[Q].Υ(B);
        }
    };
    if (!Π.name)Π.name = I({Π: 1});
    Π.L();
    (function () {
        Π.Σ = {};
        Π.Ρ = {};
    })();
    return Π;
})();
if (typeof R.S.T.lang.error.ל == 'undefined')R.S.T.lang.error.ל = (function () {
    var ʇ = R.S.T.lang.error.ʇ;
    var ל = function ל(message, location, ם) {
        if (ם.message && ם.message.indexOf(message) == -1) {
            message = message + "\n" + ם.message;
        }
        if (ם.location) {
            if (typeof ם.location != "string") {
                ם.location = ם.location + "";
            }
            if (ם.location.indexOf(location) == -1) {
                location = ם.location + (location ? "\n" + location : "");
            }
        }
        this.ʇ(message, location);
    };
    ל.prototype.ל = ל;
    ל.F(R.S.T.lang.error.ʇ, I({ʇ: 1}));
    if (!ל.name)ל.name = I({ל: 1});
    ל.L();
    return ל;
})();
if (typeof R.S.T.lang.object.ٴ == 'undefined')R.S.T.lang.object.ٴ = (function () {
    var ʗ = R.S.T.lang.k.ʗ;
    var ٴ = function ٴ() {
    };
    ٴ.prototype.ٴ = ٴ;
    ٴ.ŭ = function ŭ(Ů) {
        var ů = {};
        for (var Q = 0; Q < Ů.length; Q += 2) {
            ů[Ů[Q]] = Ů[Q + 1];
        }
        return ů;
    };
    ٴ.size = function size(ů) {
        var size = 0;
        for (var Q in ů) {
            size++;
        }
        return size;
    };
    ٴ.Ҁ = function Ҁ(O, P) {
        var ٵ = {};
        ٴ.N(ٵ, O);
        ٴ.N(ٵ, P);
        return ٵ;
    };
    ٴ.clone = function clone(value, ٶ) {
        var ٷ;
        if (ʗ.ǀ(value)) {
            ٷ = [];
            for (var Q = 0, ǁ = value.length - 1; Q <= ǁ; Q++) {
                ٷ.push(ٴ.clone(value[Q]));
            }
        } else if (ʗ.ʣ(value)) {
            ٷ = new RegExp(value);
        } else if (ʗ.ʢ(value)) {
            ٷ = new Date(value);
        } else if (ʗ.ʟ(value)) {
            throw new Error("Cloning functions is not implemented yet");
        } else if (ʗ.ʠ(value)) {
            if (ʗ.ʟ(value.clone)) {
                ٷ = object.clone();
            } else {
                ٷ = {};
                for (var key in value) {
                    ٷ[key] = ٶ === false ? value[key] : ٴ.clone(value[key]);
                }
            }
        } else {
            ٷ = value;
        }
        return ٷ;
    };
    ٴ.forEach = function forEach(ů, Ɖ, ǌ) {
        if (typeof Ɖ != "function") {
            throw new TypeError;
        }
        for (var Q in ů) {
            Ɖ.call(ǌ, ů[Q], Q, ů);
        }
    };
    ٴ.map = function map(ů, Ɖ, Ƃ) {
        if (typeof Ɖ != "function") {
            throw new TypeError;
        }
        var ǋ = {};
        for (var Q in ů) {
            ǋ[Q] = Ɖ.call(Ƃ, ů[Q], Q, ů);
        }
        return ǋ;
    };
    ٴ.N = function N(ů, ٸ) {
        for (var key in ٸ) {
            ů[key] = ٸ[key];
        }
        return ů;
    };
    ٴ.ٹ = function ٹ(ů) {
        var Ω = [];
        for (var key in ů) {
            Ω.push(key);
        }
        return Ω;
    };
    ٴ.ٺ = function ٺ(ů) {
        var ٻ = [];
        for (var key in ů) {
            ٻ.push(ů[key]);
        }
        return ٻ;
    };
    ٴ.Ȑ = function Ȑ(ů) {
        for (var Q in ů) {
            return false;
        }
        return true;
    };
    ٴ.ټ = function ټ(ů) {
        var ٽ = {};
        for (var Q in ů) {
            ٽ[ů[Q]] = Q;
        }
        return ٽ;
    };
    ٴ.پ = function پ(ů) {
        return Object.prototype.toString.call(ů).match(/^\[object ([^\]]+)\]$/)[1];
    };
    if (!ٴ.name)ٴ.name = I({ٴ: 1});
    ٴ.L();
    return ٴ;
})();
if (typeof R.S.T.lang.log.ע == 'undefined')R.S.T.lang.log.ע = (function () {
    var ƽ = R.S.T.lang.w.ƽ;
    var Π = R.S.T.lang.log.Π;
    var ע = function ע(target, name) {
        if (target === "GLOBAL") {
            if (typeof ע.a[name] === "object" && typeof ע.a[name].ף === "function") {
                this.event = ע.a[name];
                this.Ρ = new Π("GLOBAL." + name);
            } else {
                throw new Error("global event with name '" + name + "' not found");
            }
        } else if (target === "PUBLIC") {
            var פ = ע.ץ.צ;
            if (פ[name] && פ[name].length === 1) {
                this.event = פ[name][0];
                this.Ρ = new Π("PUBLIC." + name);
            } else {
            }
        } else {
            var ק = null;
            var id = ע.ר;
            if (typeof target === "string") {
                ק = target;
            } else {
                if (typeof target.name !== "string") {
                    throw new Error("new EventLogger(target, name): 'target' must either be a string or have a name property");
                }
                ק = target.name;
                if (typeof target.id === "string") {
                    id = target.id;
                }
            }
            this.event = ע.ש[ק][id].a[name];
            if (typeof this.event === "object" && typeof this.event.ף === "function") {
                if (id === ע.ר) {
                    this.Ρ = new Π(ק + "." + name);
                } else {
                    this.Ρ = new Π(ק + "[" + id + "]." + name);
                }
            } else {
                throw new Error("event with name '" + name + "' not found on target: " + ק + "[" + id + "]");
            }
        }
        if (typeof this.event !== "object" || typeof this.event.ף !== "function") {
            throw new Error("assertion error");
        }
        var ת = this.event.ף;
        var װ = this.Ρ;
        this.event.ף = function () {
            װ.info.call(װ, this.type);
            return ת.apply(this, arguments);
        };
    };
    ע.prototype.ע = ע;
    ע.ױ = function ױ(target, name, event) {
        function ײ(scope, event) {
            if (typeof event.ء !== "undefined") {
                throw new Error(scope + ": multiple events registered with the same name:" + name);
            }
        }

        if (typeof target === "undefined") {
            if (typeof ע.a[name] === "undefined") {
                ע.a[name] = event;
            } else {
                if (ע.a[name] === event) {
                    throw new Error("global event registered multiple times: " + name);
                } else {
                    ײ("GLOBAL", event);
                }
            }
        } else {
            var ק = target.constructor.name;
            var id = ע.ר;
            if (typeof target.id === "string") {
                if (target.id === "_ID") {
                    throw new Error("Don't use '" + id + "' as a target id please");
                } else {
                    id = target.id;
                }
            }
            var آ = ע.ש[ק];
            if (typeof آ === "undefined") {
                آ = {};
                ע.ש[ק] = آ;
            }
            var أ = آ[id];
            if (typeof أ === "undefined") {
                أ = {target: target, a: {}};
                آ[id] = أ;
            }
            if (أ.target === target) {
                if (typeof أ.a[name] === "undefined") {
                    أ.a[name] = event;
                } else {
                    if (أ.a[name] === event) {
                        throw new Error(ק + "[" + id + "]: event registered multiple times");
                    } else {
                        ײ(ק + "[" + id + "]", event);
                    }
                }
            } else {
                if (typeof أ.ؤ === "undefined") {
                    أ.ؤ = [];
                }
                أ.ؤ.push(target);
            }
        }
    };
    ע.إ = function إ(פ) {
        ע.ץ = פ;
    };
    if (!ע.name)ע.name = I({ע: 1});
    ע.L();
    (function () {
        ע.Ρ = new Π("com.sdl.core.lang.log.EventLogger");
        ע.ר = "_ID";
        ע.ש = {};
        ע.a = {};
    })();
    return ע;
})();
if (typeof R.S.T.lang.debug.ǙA == 'undefined')R.S.T.lang.debug.ǙA = (function () {
    var ל = R.S.T.lang.error.ל;
    var Ŭ = R.S.T.lang.À.Ŭ;
    var ǙA = function ǙA() {
    };
    ǙA.prototype.ǙA = ǙA;
    ǙA.ǚA = function ǚA(ů) {
        if (ů) {
        } else {
            return ǙA.Ư;
        }
    };
    ǙA.ǛA = function ǛA(Ǐ, ů) {
        if (ů) {
        } else {
            ǙA.Ư = !!Ǐ;
        }
    };
    ǙA.ǜA = function ǜA() {
        if (ǙA.Ư) {
        }
        return ǙA.Ư;
    };
    ǙA.ǝA = function ǝA(ǞA, message, location) {
        if (ǙA.Ư) {
            ǞA();
        } else {
            try {
                ǞA();
            } catch (ǟA) {
                throw new ל(message, location, ǟA);
            }
        }
    };
    if (!ǙA.name)ǙA.name = I({ǙA: 1});
    ǙA.L();
    (function () {
        var match = typeof location != "undefined" && /debug=(true|false)/.exec(location.search);
        switch (match && match[1]) {
            case "true":
            case "false":
                ǙA.Ư = match[1] == "true";
                break;
            default:
                ǙA.Ư = !Ŭ.Ŵ();
                break;
        }
    })();
    return ǙA;
})();
if (typeof R.S.T.platform.ǳA == 'undefined')R.S.T.platform.ǳA = (function () {
    var ٴ = R.S.T.lang.object.ٴ;
    var ǳA = function ǳA() {
    };
    ǳA.prototype.ǳA = ǳA;
    ǳA.prototype.toString = function toString() {
        return ǳA.U + " " + ǳA.ǴA + " on " + ǳA.ǵA;
    };
    ǳA.ǺA = function ǺA(scope) {
        var platform = {ǵA: "", ǻA: "", ǼA: "", ǽA: "", U: "", ǴA: ""};
        var س = /(Linux|Mac OS X|Windows) (?:NT )?([\d\._]+)?/.exec(scope.navigator.userAgent) || /(Macintosh)/.exec(scope.navigator.userAgent);
        if (س) {
            platform.ǵA = س[1];
            if (س[2]) {
                platform.ǻA = س[2].replace(/_/g, ".");
            }
        }
        var ʖ = /\b([A-Za-z]+)\/([a-z\d\+\.]+)/g;
        var map = {};
        while (س = ʖ.exec(scope.navigator.userAgent)) {
            map[س[1]] = س[2];
        }
        for (var Q = ǳA.ǾA.length; Q--;) {
            if (ǳA.ǾA[Q]in map) {
                platform.U = ǳA.ǾA[Q];
                platform.ǴA = map[ǳA.ǾA[Q]];
                break;
            }
        }
        for (var Q = ǳA.ǿA.length; Q--;) {
            if (ǳA.ǿA[Q]in map) {
                platform.ǼA = ǳA.ǿA[Q];
                platform.ǽA = map[ǳA.ǿA[Q]];
                break;
            }
        }
        for (var Q = ǳA.ȀA.length; Q--;) {
            if (ǳA.ȀA[Q]in map) {
                platform.ǵA = ǳA.ȀA[Q];
                platform.ǻA = map[ǳA.ȀA[Q]];
                break;
            }
        }
        var س = /MSIE ([\d\.]+)/.exec(scope.navigator.userAgent);
        if (س) {
            platform.U = "Internet Explorer";
            platform.ǴA = س[1];
            if (platform.ǴA == "7.0") {
                var ȁA = scope.navigator.userAgent;
                var ȂA = /Trident/.test(ȁA);
                if (ȂA) {
                    platform.ǴA = "8.0";
                }
            }
            if (platform.ǼA == "Mozilla") {
                platform.ǼA = "Trident";
                platform.ǽA = "";
            }
        }
        var س = /Version\/([\d\.]+)/.exec(scope.navigator.userAgent);
        if (س) {
            platform.ǴA = س[1];
        }
        if (platform.ǵA == "Mac OS X") {
            platform.ǵA = "Macintosh";
        }
        if (platform.ǼA == "AppleWebKit") {
            platform.ǼA = "WebKit";
        }
        return platform;
    };
    ǳA.ώ = function ώ(O, P, ȃA) {
        if (typeof O !== "string" || typeof P !== "string") {
            return null;
        }
        var ʖ;
        O = O.replace(/_/g, ".").replace(/([a-z]+)/gi, ".$1.");
        P = P.replace(/_/g, ".").replace(/([a-z]+)/gi, ".$1.");
        if (O == P) {
            ʖ = 0;
        } else {
            O = O.split(".").map(ȄA);
            P = P.split(".").map(ȄA);
            for (var ȅA, ȆA, Q = 0, ǁ = Math.max(O.length, P.length) - 1; Q <= ǁ; Q++) {
                ȅA = O[Q] || 0;
                ȆA = P[Q] || 0;
                if (ȅA != ȆA) {
                    ʖ = ȅA > ȆA ? 1 : -1;
                    break;
                }
            }
            if (!ʖ) {
                ʖ = -1;
            }
        }
        switch (ȃA) {
            case "<":
                return ʖ === -1;
            case "<=":
                return ʖ === -1 || ʖ === 0;
            case ">":
                return ʖ === 1;
            case ">=":
                return ʖ === 1 || ʖ === 0;
            case "==":
                return ʖ === 0;
            case "!=":
                return ʖ !== 0;
            default:
                return ʖ;
        }
    };
    var ȄA = function ȄA(к) {
        if (!к) {
            return 0;
        }
        switch (к) {
            case "dev":
                return-4;
            case "a":
                return-3;
            case "b":
                return-2;
            case "RC":
                return-1;
            default:
                return parseInt(к);
        }
    };
    ǳA.ȇA = "Trident";
    ǳA.ȈA = "WebKit";
    ǳA.ȉA = "Presto";
    ǳA.ȊA = "Gecko";
    ǳA.ȋA = "Macintosh";
    ǳA.ȌA = "Windows";
    ǳA.ȍA = "Linux";
    ǳA.ȎA = "Chrome";
    ǳA.ǾA = ["Mozilla", "Firefox", "Iceweasel", "Camino", "Minefield", "Opera", "Safari", "OmniWeb", "iCab", "Chrome"];
    ǳA.ǿA = ["Mozilla", "Trident", "Gecko", "Presto", "AppleWebKit"];
    ǳA.ȀA = ["Ubuntu"];
    if (!ǳA.name)ǳA.name = I({ǳA: 1});
    ǳA.L();
    (function () {
        ٴ.N(ǳA, ǳA.ǺA(window));
    })();
    return ǳA;
})();
if (typeof R.S.T.lang.a.ǡA == 'undefined')R.S.T.lang.a.ǡA = (function () {
    var ע = R.S.T.lang.log.ע;
    var ǡA = function ǡA() {
    };
    ǡA.prototype.ǡA = ǡA;
    ǡA.prototype.ǢA = function ǢA(a) {
        if (!this.ɑ) {
            this.ɑ = {};
        }
        ǡA.ǢA.call(this.ɑ, a, this);
    };
    ǡA.ǢA = function ǢA(a, target) {
        for (var ǣA in a) {
            var event = {type: ǣA, ף: ǡA.ǤA, ϩ: ǡA.ǥA, ǦA: ǡA.ǧA, ǨA: ǡA.ǩA, ǪA: a[ǣA].ǪA};
            this[ǣA] = this[ǣA] || event;
            ע.ױ(target, ǣA, event);
        }
    };
    ǡA.ǤA = function ǤA(target) {
        if (this.ء) {
            var Ů = [target];
            for (var Q = 1, ǁ = arguments.length; Q < ǁ; Q++) {
                Ů.push(arguments[Q]);
            }
            for (this.ǫA = this.ء.length - 1; this.ǫA >= 0; --this.ǫA) {
                var ǬA = this.ء[this.ǫA];
                if (ǬA[this.type].apply(ǬA, Ů) === false) {
                    return false;
                }
            }
        }
        return true;
    };
    ǡA.ǥA = function ǥA(ǬA) {
        if (!this.ء) {
            this.ء = [ǬA];
        } else if (this.ǪA) {
            this.ء.push(ǬA);
        } else {
            this.ء.unshift(ǬA);
        }
    };
    ǡA.ǧA = function ǧA(ǬA) {
        if (this.ء) {
            for (var Q = 0; Q < this.ء.length; Q++) {
                if (this.ء[Q] == ǬA) {
                    return true;
                }
            }
        }
        return false;
    };
    ǡA.ǩA = function ǩA(ǬA) {
        if (this.ء) {
            for (var Q = 0; Q < this.ء.length; Q++) {
                if (this.ء[Q] == ǬA) {
                    if (this.ǫA > Q) {
                        this.ǫA--;
                    }
                    this.ء.splice(Q, 1);
                }
            }
        }
    };
    if (!ǡA.name)ǡA.name = I({ǡA: 1});
    ǡA.L();
    return ǡA;
})();
if (typeof R.S.T.lang.error.ЃA == 'undefined')R.S.T.lang.error.ЃA = (function () {
    var ǙA = R.S.T.lang.debug.ǙA;
    var ǡA = R.S.T.lang.a.ǡA;
    var ЃA = function ЃA() {
        this.ǡA();
        this.ǢA({Error: {message: String}, ЄA: {message: String}, ЅA: {message: String}, ІA: {message: String}});
    };
    ЃA.prototype.ЃA = ЃA;
    ЃA.prototype.ЇA = function ЇA(ů) {
        for (var Q = 1, ǁ = arguments.length; Q < ǁ; Q++) {
            this.wrap(ů, arguments[Q]);
        }
    };
    ЃA.prototype.wrap = function wrap(ů, ƃ) {
        if (ů.ЈA === ƃ || ƃ === ЃA.ЉA) {
            return;
        }
        if (ů.ЈA) {
            throw new Error("There already is another monitored function on this object. Currently, only one method per object is supported.");
        }
        for (var Q in ů) {
            if (ů[Q] === ƃ) {
                ů[Q] = ЃA.ЉA;
                break;
            }
        }
        ů.ЈA = ƃ;
    };
    ЃA.ЉA = function ЉA() {
        var ƃ = this.ЈA;
        if (ǙA.ǚA()) {
            return ƃ.apply(this, arguments);
        } else {
            try {
                return ƃ.apply(this, arguments);
            } catch (ǟA) {
                if (this.Error) {
                    return this.Error(ǟA, ƃ, arguments);
                } else {
                    throw ǟA;
                }
            }
        }
    };
    ЃA.prototype.error = function error(ǟA) {
        if (typeof ǟA == "string") {
            ǟA = new Error(ǟA);
        }
        this.ɑ.Error.ף(ǟA);
    };
    ЃA.prototype.ЊA = function ЊA(ǟA) {
        if (typeof ǟA == "string") {
            ǟA = new Error(ǟA);
        }
        this.error(ǟA);
        throw ǟA;
    };
    ЃA.prototype.ЋA = function ЋA(ǟA) {
        if (typeof ǟA == "string") {
            ǟA = new Error(ǟA);
        }
        this.ɑ.ЄA.ף(ǟA);
    };
    ЃA.prototype.info = function info(ǟA) {
        if (typeof ǟA == "string") {
            ǟA = new Error(ǟA);
        }
        this.ɑ.ІA.ף(ǟA);
    };
    ЃA.prototype.log = function log(ǟA) {
    };
    ЃA.prototype.ЌA = function ЌA(ǟA) {
    };
    ЃA.prototype.ЎA = function ЎA(ǟA) {
    };
    ЃA.prototype.ЏA = function ЏA(ǟA, АA) {
        if (typeof ǟA == "string") {
            ǟA = new Error(ǟA);
        }
        ǟA.ЏA = true;
        if (АA) {
            ǟA.hash = АA;
        }
        this.ɑ.ЅA.ף(ǟA);
    };
    ЃA.prototype.БA = function БA(ǟA) {
        if (ǙA.ǚA()) {
            if (ǟA) {
                this.ЊA(ǟA);
            } else {
            }
        }
    };
    ЃA.F(R.S.T.lang.a.ǡA, I({ǡA: 1}));
    if (!ЃA.name)ЃA.name = I({ЃA: 1});
    ЃA.L();
    return new ЃA;
})();
if (typeof R.S.T.platform.لA == 'undefined')R.S.T.platform.لA = (function () {
    var ƽ = R.S.T.lang.w.ƽ;
    var ǙA = R.S.T.lang.debug.ǙA;
    var ЃA = R.S.T.lang.error.ЃA;
    var ǳA = R.S.T.platform.ǳA;
    var لA = function لA() {
    };
    لA.prototype.لA = لA;
    لA.version = null;
    لA.مA = [];
    if (!لA.name)لA.name = I({لA: 1});
    لA.L();
    (function () {
        if (ǳA.ǼA === ǳA.ȇA && ǳA.ǴA !== "6.0") {
            لA.مA = ["6.0", "4.0"];
        } else if (ǳA.ǼA === ǳA.ȇA) {
            لA.مA = ǙA.ǚA() ? ["4.0", "6.0", "5.0"] : ["6.0", "4.0", "5.0"];
        }
        لA.مA.some(function نA(version) {
            try {
                new ActiveXObject("MSXML2.DOMDocument." + version);
                return لA.version = version;
            } catch (ǟA) {
                ЃA.ЎA(ǟA);
            }
        });
    })();
    return لA;
})();
if (typeof R.S.T.platform.ZG == 'undefined')R.S.T.platform.ZG = (function () {
    var ǙA = R.S.T.lang.debug.ǙA;
    var لA = R.S.T.platform.لA;
    var ǳA = R.S.T.platform.ǳA;
    var ZG = function ZG() {
        if ((location + "").toLowerCase().indexOf("/source/com/sdl/xopus/") != -1) {
            return;
        }
        if (!ZG._G()) {
            this.aG("platform");
        }
        if (!ZG.bG()) {
            this.aG("protocol");
        }
        if (ǳA.ǼA === ǳA.ȇA && !لA.version) {
            this.aG("msxml");
        }
    };
    ZG.prototype.ZG = ZG;
    ZG.prototype.aG = function aG(id) {
        var cG = (ZG.հC() === true) ? "xopus/media/standalone-requirements.html?id=" + id : "media/requirements.html";
        if (location.href.indexOf(cG) == -1) {
            location.replace(cG + location.hash);
        }
        var ʃ = document.getElementById(id);
        if (ʃ) {
            ʃ.style.display = "block";
        }
    };
    ZG.հC = function հC() {
        return typeof Ż !== "undefined";
    };
    ZG.bG = function bG() {
        return /^https?:$/.test(location.protocol);
    };
    ZG._G = function _G() {
        var dG = (ZG.հC() === true) ? "7" : "6";
        switch (true) {
            case ǳA.ǼA === ǳA.ȇA && ǳA.ώ(dG, ǳA.ǴA) == 1:
            case ǳA.U === "Firefox" && parseInt(ǳA.ǴA, 10) <= 3:
            case!(ǳA.ǼA === ǳA.ȇA || ǳA.ǼA === ǳA.ȊA || ǳA.U === ǳA.ȎA):
                return location.search.indexOf("platformtest=skip") != -1;
            default:
                return true;
        }
    };
    if (!ZG.name)ZG.name = I({ZG: 1});
    ZG.L();
    return new ZG;
})();