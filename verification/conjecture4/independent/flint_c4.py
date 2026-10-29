#!/usr/bin/env python3
"""Independent FLINT re-implementation of the Section 7 (Conjecture 4) checks.

Inputs: only a_N, b_N from the stored ../results/relation_N.gp files, exported
by export_relations.gp to relations.json. Everything else -- U, A, B, E, the
supersingular polynomial, the resultant, factorizations and the identity of
Proposition 7.1 -- is recomputed here with python-flint (FLINT), not PARI.
The A, B, E stored by verify_c4.gp are read only to compare with the
recomputed ones.

Usage (from this directory):  python3 flint_c4.py relations.json PMAX
Requires: pip install python-flint (tested with python-flint 0.9.0).
"""
import json, sys
from math import comb
from flint import fmpz_poly, nmod_poly

def primes(lo, hi):
    s = bytearray([1]) * (hi + 1); s[0:2] = b"\x00\x00"
    for i in range(2, int(hi ** 0.5) + 1):
        if s[i]: s[i*i::i] = bytearray(len(s[i*i::i]))
    return [i for i in range(lo, hi + 1) if s[i]]

def kron(a, n):
    """Kronecker symbol (a/n), n > 0."""
    if n == 2:
        return 0 if a % 2 == 0 else (1 if a % 8 in (1, 7) else -1)
    a %= n; t = 1
    while a:
        while a % 2 == 0:
            a //= 2
            if n % 8 in (3, 5): t = -t
        a, n = n, a
        if a % 4 == 3 and n % 4 == 3: t = -t
        a %= n
    return t if n == 1 else 0

def monic_fmpz(f):
    c = f.coeffs(); assert c[-1] in (1, -1); return f if c[-1] == 1 else -f

def correction_factors(a, b):
    """U0, U1728, A, B, E over Z from the definitions (eq. res-U, res-ABE)."""
    Y = fmpz_poly([0, 1])
    def powpart(Q, G):
        c, fac = Q.factor(); U = fmpz_poly([1]); rest = []
        for f, e in fac:
            f = monic_fmpz(f)
            if (G % f) == 0: U *= f ** e
            else: rest.append((f, e))
        return U, rest
    Q0 = b; Q1728 = fmpz_poly([1728**2]) - 1728 * a + b
    U0, r0 = powpart(Q0, a)
    U4, r4 = powpart(Q1728, a - 3456)
    A = fmpz_poly([1]); B = fmpz_poly([1])
    for f, e in r0: assert e % 3 == 0; A *= f ** (e // 3)
    for f, e in r4: assert e % 2 == 0; B *= f ** (e // 2)
    D = a * a - 4 * b; E = fmpz_poly([1])
    for f, e in D.factor()[1]:
        if e % 2: E *= monic_fmpz(f)
    assert Q0 == U0 * A**3 and Q1728 == U4 * B**2
    return U0, U4, A, B, E

def ss_poly(p):
    """Classical supersingular polynomial mod p (explicit binomial formula)."""
    n = p // 12; e = (1 - kron(-1, p)) // 2; d = (1 - kron(-3, p)) // 2
    X = nmod_poly([0, 1], p); X1728 = nmod_poly([-1728 % p, 1], p)
    J = nmod_poly([0], p)
    for k in range(n + 1):
        c = comb(2*n + e, 2*k + e) * comb(2*n - 2*k, n - k) * (-432) ** (n - k)
        J += nmod_poly([c % p], p) * X1728 ** k
    f = X ** d * X1728 ** e * J
    return f * pow(int(f.coeffs()[-1]), -1, p)

def res_quadratic(s, a, b, p):
    """Res_X(s(X), X^2 - a X + b) in F_p[Y], s monic in X with constant coeffs.
    Reduce s mod G as u X + v, then Res = s(b1)s(b2) = u^2 b + u v a + v^2."""
    u = nmod_poly([0], p); v = nmod_poly([0], p)
    for c in reversed(s.coeffs()):            # Horner: r <- r*X + c
        u, v = u * a + v, -(u * b) + nmod_poly([int(c)], p)
    return u * u * b + u * v * a + v * v

def vmult(f, g):
    k = 0
    while g.degree() >= f.degree() and (g % f) == 0:
        g = g // f; k += 1
    return k

def degree_formula(N, p, dN):
    if N == 2:   # N = 2: degree obtained from (7.4); Corollary 1.3 excludes N = 2
        return ((p - 1) + 3 * (1 - kron(-1, p)) + 2 * (1 - kron(-2, p))) / 8
    return ((N + 1) * (p - 1) / 24 + (1 + kron(-1, N)) * (1 - kron(-1, p)) / 8
            + (1 + kron(-3, N)) * (1 - kron(-3, p)) / 6 + (1 - kron(-N, p)) * dN / 2)

def main():
    rel = [json.loads(l) for l in open(sys.argv[1])]
    pmax = int(sys.argv[2])
    dN = {N: (1 if N in (2, 3) else None) for N in [r["N"] for r in rel]}
    tot = fails = 0
    for r in rel:
        N = r["N"]
        a = fmpz_poly(r["a"]); b = fmpz_poly(r["b"])
        U0, U4, A, B, E = correction_factors(a, b)
        same = (A.coeffs() == r["A"] and B.coeffs() == r["B"] and E.coeffs() == r["E"])
        if dN[N] is None: dN[N] = ss_poly(N).degree()
        nfail = 0; n = 0
        for p in primes(5, pmax):
            if p == N: continue
            delta = (1 - kron(-3, p)) // 2; eps = (1 - kron(-1, p)) // 2
            Ap = nmod_poly([int(c) % p for c in A.coeffs()], p); Bp = nmod_poly([int(c) % p for c in B.coeffs()], p)
            if N == 2:
                Cp = nmod_poly([0, 1], p) ** eps * nmod_poly([-256 % p, 1], p) ** ((1 - kron(-2, p)) // 2)
            else:
                Cp = nmod_poly([int(c) % p for c in E.coeffs()], p) ** ((1 - kron(-N, p)) // 2)
            s = ss_poly(p)
            V = res_quadratic(s, nmod_poly([c % p for c in r["a"]], p), nmod_poly([c % p for c in r["b"]], p), p)
            lc, fac = V.factor()
            S = nmod_poly([1], p)
            for f, _ in fac: S *= f
            ok = (int(lc) == 1 and V.degree() == (N + 1) * s.degree())
            ok &= (Cp * V == Ap ** (2 * delta) * Bp ** eps * S * S)
            for f, e in fac:
                ok &= (e == 2 + 2 * delta * vmult(f, Ap) + eps * vmult(f, Bp) - vmult(f, Cp))
            ok &= (S.degree() == degree_formula(N, p, dN[N]))
            # every root in F_{p^2}: X^{p^2} = X mod S
            Xs = nmod_poly([0, 1], p)
            ok &= (pow(Xs, p * p, S) == Xs % S) if S.degree() > 1 else True
            n += 1
            if not ok: nfail += 1; print("FAIL", N, p)
        tot += n; fails += nfail
        print(f"N={N:2d}  A,B,E rederived match stored: {same}  pairs={n}  failures={nfail}", flush=True)
    print(f"TOTAL pairs={tot} failures={fails} (p <= {pmax})")

main()
