"""
Joint test of Nakaya's Conjecture 5 (linear factors of ss_p^{(N*)}) and Morton's
E_7 conjectures (factor counts of the Hasse invariant H_{7,l}) over F_l.

Requires: pip install cypari2

Common core: ss_l(X) = X^r (X-1728)^s J_l(X), with Morton's truncated binomial sum
  J_l(t) = sum_{k<=n} C(2n+s,2k+s) C(2n-2k,n-k) (-432)^(n-k) (t-1728)^k,  n = floor(l/12).
Validated against PARI's ellap (a_l = 0) and the supersingular count.

Nakaya: Hauptmodul t_N = (eta(tau)/eta(N tau))^e + N^(e/2) (eta(N tau)/eta(tau))^e, e=24/(N-1),
for N in {2,3,5,7,13}. j(tau), j(N tau) are the roots of X^2 - a_N(t) X + b_N(t).
L^{(N*)}(p) = #{t in F_p : X^2 - a_N(t)X + b_N(t) has a supersingular root}.

Morton E_7: distinct irreducible factors of H_{7,l} over F_l = union over supersingular j
of the irreducible factors of num(x) - j*den(x)  (j in F_l), or of the norm form
num^2 + u num den + v den^2 for a conjugate pair with min. poly X^2+uX+v.
"""
import sys, cypari2
pari = cypari2.Pari(); pari.allocatemem(2 * 10**9, silent=True) if hasattr(pari, "allocatemem") else None
gp = pari

def leg(a, p): return int(gp.kronecker(a, p))
def hfield(d):            # class number of Q(sqrt(-d)), d > 0 squarefree
    D = -d if (-d) % 4 == 1 else -4 * d
    return int(gp.qfbclassno(D))

# ---------- supersingular polynomial ----------
def ss_poly(l):
    n, r, s = l // 12, (1 - leg(-3, l)) // 2, (1 - leg(-4, l)) // 2
    J = gp(f"sum(k=0,{n}, binomial(2*{n}+{s},2*k+{s})*binomial(2*{n}-2*k,{n}-k)*(-432)^({n}-k)*(X-1728)^k)")
    return gp(f"Mod(1,{l})") * gp("X") ** r * (gp("X") - 1728) ** s * J

def ss_factors(l):
    F = gp.factormod(ss_poly(l), l) if False else gp.factor(ss_poly(l))
    lin, quad = [], []
    for i in range(len(F[0])):
        f = F[0][i]; d = int(gp.poldegree(f))
        if d == 1: lin.append(int(gp.lift(-gp.polcoef(f, 0))))
        elif d == 2: quad.append((int(gp.lift(gp.polcoef(f, 1))), int(gp.lift(gp.polcoef(f, 0)))))
        else: raise ValueError("ss_l has a factor of degree > 2 (wrong polynomial?)")
    return lin, quad

def validate_ss(l):
    lin, quad = ss_factors(l)
    total = len(lin) + 2 * len(quad)
    expect = l // 12 + {1: 0, 5: 1, 7: 1, 11: 2}[l % 12]
    ok_ap = all(int(gp.ellap(gp.ellinit(gp.ellfromj(gp(f"Mod({j},{l})"))), l)) == 0
                for j in lin if j not in (0, 1728))
    return total == expect and ok_ap

# ---------- Hauptmodul relations X^2 - a_N(t) X + b_N(t) ----------
def relation(N, prec=None):
    e = 24 // (N - 1); prec = prec or N + 12
    gp(f"default(seriesprecision,{prec+5})")
    q = gp("q")
    A = gp(f"(eta(q+O(q^{prec+3}))/eta(q^{N}+O(q^{prec+3})))^{e}")
    t = A / q + gp(N) ** (e // 2) * q / A
    jq = gp(f"ellj(q+O(q^{prec+3}))")
    jN = gp.subst(jq, "q", q ** N)
    def as_poly(S):
        P = gp(0); S = S
        while int(gp.valuation(S, q)) <= 0:
            v = int(gp.valuation(S, q)); c = gp.polcoef(S, v, q)
            P += c * gp("T") ** (-v); S -= c * t ** (-v)
            if v == 0: break
        assert gp.valuation(S, q) >= 1  # remainder must vanish at q^0
        return P
    a = as_poly(jq + jN); b = as_poly(jq * jN)
    return gp("X^2") - a * gp("X") + b

def nakaya_count(N, l, R, lin, quad):
    """# of distinct t in F_l with R(j,t)=0 for some supersingular j."""
    ts = set()
    for j in lin:
        f = gp.subst(R, "X", j) * gp(f"Mod(1,{l})")
        if f == 0: continue
        for rt in gp.polrootsmod(gp.lift(f), l): ts.add(int(gp.lift(rt)))
    for (u, v) in quad:
        m = gp(f"Mod(1,{l})") * (gp("X^2") + u * gp("X") + v)
        f = gp.polresultant(R * gp(f"Mod(1,{l})"), m, "X")
        for rt in gp.polrootsmod(gp.lift(f), l): ts.add(int(gp.lift(rt)))
    return len(ts)

def nakaya_formula(N, p, Lp):
    k = lambda a: leg(a, N) * leg(a, p)            # Kronecker symbol (a / Np)
    val = gp("1/2") * (1 + leg(-p, N)) * Lp + gp("1/8") * (2 + (1 - k(-1)) * (2 + k(-2))) * hfield(N * p)
    return val

# ---------- Morton E_7 ----------
NUM = gp("(x^2-x+1)^3*(x^6-11*x^5+30*x^4-15*x^3-10*x^2+5*x+1)^3")
DEN = gp("x^7*(x-1)^7*(x^3-8*x^2+5*x+1)")
F7 = lambda t: gp(f"(x^2-x+1)^3-({t})*x*(x-1)*(x^3-8*x^2+5*x+1)")
B = lambda a, b: (a**3 + (-5*b + 8)*a**2 + (-8*b*b + 6*b + 5)*a - b**3 - 5*b*b + 8*b - 1)

def morton_factors(l, lin, quad):
    one = gp(f"Mod(1,{l})"); facs = set()
    polys = [NUM - j * DEN for j in lin] + [NUM**2 + u*NUM*DEN + v*DEN**2 for (u, v) in quad]
    for P in polys:
        F = gp.factor(P * one)
        for i in range(len(F[0])):
            f = F[0][i]
            facs.add(tuple(int(gp.lift(c)) for c in gp.Vec(f)))
    by_deg = {}
    for f in facs: by_deg.setdefault(len(f) - 1, []).append(f)
    return by_deg

def sextic_form_count(l, sextics):
    n = 0
    for f in sextics:
        g = gp.Pol([gp(f"Mod({c},{l})") for c in f], "x") - gp("(x^2-x+1)^3") * gp(f"Mod(1,{l})")
        h = gp("x*(x-1)*(x^3-8*x^2+5*x+1)") * gp(f"Mod(1,{l})")
        if g == 0: continue
        Q = gp.divrem(g, h)
        if Q[1] == 0 and gp.poldegree(Q[0]) == 0: n += 1
    return n

def quad_form_count(l, quads):
    return sum(1 for (_, a, b) in quads if B(a, b) % l == 0)

def morton_predictions(l):
    h, h7 = hfield(l), hfield(7 * l); r7 = l % 7
    c3 = 3 - leg(2, l)
    out = {}
    if r7 == 6: out["N1"] = 3 * h if l % 4 == 1 else 3 * c3 * h
    if r7 in (3, 5): out["N3"] = h if l % 4 == 1 else c3 * h
    eps = leg(-3, l)
    scale = gp("1/2") * h7 if l % 8 == 1 else (h7 if l % 8 == 5 else gp("1/4") * h7)
    if r7 in (2, 4): out["N6"] = scale - gp("1/2") * (1 - eps)
    if r7 in (3, 5): out["N6"] = scale - gp("1/2") * (3 - eps)
    if r7 in (1, 6):
        sc2 = 3 * scale
        out["N2"] = sc2 - (1 - eps) if r7 == 1 else sc2 - (4 - eps)
    return out

if __name__ == "__main__":
    LMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 400
    rel = {N: relation(N) for N in (2, 3, 5, 7, 13)}
    print("Hauptmodul relations computed for N = 2,3,5,7,13")
    bad = {k: [] for k in ("ss", "N3", "N5", "N7", "N13", "M_N1", "M_N3", "M_N6", "M_N2")}
    tested = {k: 0 for k in bad}
    for l in [int(x) for x in gp.primes([11, LMAX])]:
        lin, quad = ss_factors(l)
        tested["ss"] += 1
        if not validate_ss(l): bad["ss"].append(l)
        for N in (3, 5, 7, 13):
            if l == N: continue
            got = nakaya_count(N, l, rel[N], lin, quad)
            exp = nakaya_formula(N, l, len(lin))
            tested[f"N{N}"] += 1
            if got != exp: bad[f"N{N}"].append((l, got, str(exp)))
        if l == 7: continue
        by = morton_factors(l, lin, quad); pred = morton_predictions(l)
        obs = {"N1": len(by.get(1, [])), "N3": len(by.get(3, [])),
               "N6": sextic_form_count(l, by.get(6, [])), "N2": quad_form_count(l, by.get(2, []))}
        for key, val in pred.items():
            tested["M_" + key] += 1
            if obs[key] != val: bad["M_" + key].append((l, obs[key], str(val)))
    print(f"\nPrimes 11 <= l <= {LMAX}")
    for k in bad:
        print(f"{k:6s} tested {tested[k]:4d}  mismatches: {bad[k][:8]}{' ...' if len(bad[k])>8 else ''}")
