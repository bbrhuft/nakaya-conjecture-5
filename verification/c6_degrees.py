"""
Check Nakaya's Conjecture 6 against degrees of the Fricke supersingular polynomials
built from the stored Hauptmodul relations of the main verification
(verification/relations/relation_N.gp, generated under PARI/GP 2.15.4).

  Part 1: the 'degree' column of verification/results/verification.csv (p <= 300).
  Part 2: fresh degrees deg ss_p^(N*) for MINP <= p <= MAXP, from nk_polynomial.

The right-hand side of (C6) is evaluated in exact rational arithmetic, with
d_N = number of supersingular j-invariants in characteristic N.

Usage: python c6_degrees.py [MAXP] [REPO_ROOT]     (defaults: 1500, the repository root)
Requires: cypari2.
"""
import csv, sys, time
from fractions import Fraction as F
from pathlib import Path
import cypari2

MAXP = int(sys.argv[1]) if len(sys.argv) > 1 else 1500
ROOT = Path(sys.argv[2]) if len(sys.argv) > 2 else Path(__file__).resolve().parents[1]
VER = ROOT / "verification"
LEVELS = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]
gp = cypari2.Pari(); gp.allocatemem(2 * 10**9)

def leg(a, n): return int(gp.kronecker(a, n))
def d_N(N): return 1 if N == 3 else N // 12 + {1: 0, 5: 1, 7: 1, 11: 2}[N % 12]
def rhs(N, p):
    return (F((N + 1) * (p - 1), 24) + F(1, 8) * (1 + leg(-1, N)) * (1 - leg(-1, p))
            + F(1, 6) * (1 + leg(-3, N)) * (1 - leg(-3, p)) + F(1, 2) * (1 - leg(-N, p)) * d_N(N))

bad, n = [], 0
for r in csv.DictReader(open(VER / "results" / "verification.csv")):
    N, p, deg = int(r["N"]), int(r["p"]), int(r["degree"]); n += 1
    if rhs(N, p) != deg: bad.append((N, p, deg, str(rhs(N, p))))
print(f"Part 1 (recorded degrees, p <= 300): {n} pairs, mismatches: {bad if bad else 'none'}")

gp("NK_NO_RUN=1"); gp(f'read("{(VER / "verify_nakaya.gp").as_posix()}")')
tot, bad = 0, []
for N in LEVELS:
    gp(f'REL=read("{(VER / "relations" / f"relation_{N}.gp").as_posix()}")'); t0, k = time.time(), 0
    for p in (int(x) for x in gp.primes([301, MAXP])):
        deg = int(gp(f"poldegree(nk_polynomial({N},{p},REL))"))
        if F(deg) != rhs(N, p): bad.append((N, p, deg, str(rhs(N, p))))
        k += 1
    tot += k; print(f"N={N}: {k} primes in {time.time() - t0:.0f} s", flush=True)
print(f"Part 2 (fresh degrees, 300 < p <= {MAXP}): {tot} pairs, mismatches: {bad if bad else 'none'}")
