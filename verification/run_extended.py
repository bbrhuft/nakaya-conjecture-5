"""
Extended verification of Nakaya's Conjecture 5 using the stored Hauptmodul relations.

Why this exists: under PARI/GP 2.17.x, verify_nakaya.gp stops at N = 13 with
"unexpected Hauptmodul dimension" (mfatkininit returns a non-involutive matrix for
the full weight-12 space). This runner loads the relations produced under
PARI/GP 2.15.4 (relations/relation_N.gp) and calls the script's own functions,
so it works on later PARI versions.

For each level N and prime 5 <= p <= MAXP, p != N, it checks
    direct rational-root count of ss_p^(N*)  ==  Nakaya's formula (1.3)
    4 * (root count)                          ==  r_p(Np) + r_Np(Np)   (enumerated forms)

Requirements: Python 3.9+, cypari2 (pip install cypari2).
Usage:        python run_extended.py [MAXP]          (default 2000)
Result on 2026-10-26, PARI 2.17.2, MAXP = 2000: 4201 pairs, 0 mismatches.
"""
import sys, time
from pathlib import Path
import cypari2

HERE = Path(__file__).resolve().parent
LEVELS = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]


def main(maxp: int) -> int:
    gp = cypari2.Pari()
    gp.allocatemem(2 * 10**9)
    gp("NK_NO_RUN=1")
    gp(f'read("{(HERE / "verify_nakaya.gp").as_posix()}")')
    total, bad = 0, []
    for N in LEVELS:
        gp(f'REL=read("{(HERE / "relations" / f"relation_{N}.gp").as_posix()}")')
        assert int(gp("poldegree(REL[1])")) == N and int(gp("poldegree(REL[2])")) == N + 1
        t0, n = time.time(), 0
        for p in (int(x) for x in gp.primes([5, maxp])):
            if p == N:
                continue
            gp(f"S=nk_polynomial({N},{p},REL)")
            L = int(gp(f"poldegree(gcd(S,Mod(1,{p})*(T^{p}-T)))"))
            rhs = gp(f"nk_rhs({N},{p})")
            rp, rnp = int(gp(f"nk_fixed({p},{N*p})")), int(gp(f"nk_fixed({N*p},{N*p})"))
            if not (L == rhs and 4 * L == rp + rnp):
                bad.append((N, p, L, str(rhs), rp, rnp))
            n += 1
        total += n
        print(f"N={N}: {n} primes checked in {time.time() - t0:.0f} s", flush=True)
    print(f"TOTAL {total} pairs, mismatches: {bad if bad else 'none'}")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(int(sys.argv[1]) if len(sys.argv) > 1 else 2000))
