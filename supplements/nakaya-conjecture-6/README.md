# Supplement: Nakaya's Conjecture 6 (degree of Fricke supersingular polynomials)

A short self-contained note deducing **Nakaya's Conjecture 6** (Nakaya, *J. Number Theory* 204 (2019), §4.2): for every N ∈ {3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71} and every prime p ≥ 5, p ≠ N,

deg ss_p^(N*) = (N+1)(p−1)/24 + ⅛(1+(−1/N))(1−(−1/p)) + ⅙(1+(−3/N))(1−(−3/p)) + ½(1−(−N/p))·deg ss_N.

The degree is the total number D of supersingular points on X₀(N)⁺ in characteristic p. The proof uses the identity D = 1 + g(X₀(Np)/⟨w_N⟩), which is Lemma 3.1 of the main paper (`paper/`), then Riemann–Hurwitz, the genus formula for X₀(Np) and the classical fixed-point counts of w_N (Ogg; Im–Jeon–Kim for N = 3). No priority is claimed: N = 3 is Nakaya's, N = 5 and N = 7 are Morton's (2021, 2023), and the deduction uses only classical results.

The note also records:
- **Proposition 5.1:** at any prime level N ≥ 5, D = (the same expression) − (1 − (−N/p))·g(X₀(N)⁺);
- **§6:** ss_p^(N*) factors over 𝔽_p into λ_p linear factors (main paper, Conjecture 5) and g(X₀(Np)/⟨w_N, w_p⟩) irreducible quadratics.

This supplement is **separate from the main paper**, which is unchanged.

## Contents

| Path | Contents |
|---|---|
| `Nakaya_Conjecture6_Note.pdf`, `.tex` | The note (6 pages) and its LaTeX source |
| `verification/` | Original verification package (PARI/GP 2.15.4): direct degree computation and Atkin–Lehner trace computation, with results and logs. Its own `README.md` and `SHA256SUMS.json` also list a `Report.*` draft, which the note supersedes and which is not included; every other listed file matches its checksum |
| `checks/c6_degrees.py` | Compares (C6) with polynomial degrees from the main paper's stored relations: the recorded p ≤ 300 run and fresh degrees for 300 < p ≤ MAXP |
| `checks/c6_direct.gp` | Counts D directly from the modular polynomial Φ_N, with no Hauptmodul, relation, genus formula or class number; also checks Proposition 5.1 and the level-3 fixed-point count |
| `checks/*.log` | Output of the two checks under PARI/GP 2.17.2 |

## Results

| Check | PARI/GP | Coverage | Mismatches |
|---|---|---|---|
| `verification/code/verify_conjecture6.gp` (direct degrees) | 2.15.4 | all 14 levels, 5 ≤ p ≤ 300 and p = 307, 401, 503, 1009: 883 pairs | 0 |
| `verification/code/verify_traces.gp` (cusp-form traces) | 2.15.4 | all 14 levels at p = 5, 7, 13: 39 pairs | 0 |
| `checks/c6_degrees.py` | 2.17.2 | 827 recorded + 2,478 fresh pairs (all 14 levels, p ≤ 1500) | 0 |
| `checks/c6_direct.gp` (a): Nakaya levels 11–31 | 2.17.2 | 167 pairs, p ≡ 1 (mod 12), p ≤ 700 | 0 |
| `checks/c6_direct.gp` (b): levels 37–73, genus 1–2 | 2.17.2 | 87 pairs, p ≡ 1 (mod 12), p ≤ 600 | 0 |
| `checks/c6_direct.gp` (c): r₃(3p) = 2(1 + (−3/p)) | 2.17.2 | 12 primes, 5 ≤ p ≤ 43 | 0 |

In `c6_direct.gp`, pairs where a loop (j, j) of Φ_N = 0 has a repeated tangent slope are skipped and reported (21 and 48 pairs, all small p). Under PARI/GP 2.17 the original `verify_conjecture6.gp` may stop at N = 13 when rebuilding Hauptmoduli, as the main verifier does; `c6_degrees.py` avoids this by using the stored relations.

## Running the checks

```sh
cd checks
python c6_degrees.py 1500            # needs cypari2; uses ../../../verification/
gp -fq -s 1000000000 c6_direct.gp    # needs ../../../verification/verify_general.gp
```

Finite agreement is evidence for the implementation and normalizations, not a substitute for the proof.
