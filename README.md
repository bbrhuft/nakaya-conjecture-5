# Nakaya's Conjectures 5 and 6: linear factors and degree of Fricke supersingular polynomials

Manuscript and exact PARI/GP verification for a deduction of two conjectures of Nakaya (*J. Number Theory* 204 (2019)) on the supersingular polynomial ss_p^(N*) attached to the Fricke group Γ₀(N)⁺, at every prime level N ∈ {3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71} and every prime p ≥ 5, p ≠ N:

- **Conjecture 5:** a class-number formula for the number of linear factors of ss_p^(N*) over 𝔽_p (Corollary 1.2);
- **Conjecture 6:** a formula for the degree of ss_p^(N*), the total number of supersingular points on X₀(N)⁺ (Corollary 1.3).

Together with Aricheta's theorem, they determine the factorization over 𝔽_p: ss_p^(N*) has that many linear factors and exactly g(X₀(Np)/⟨w_N, w_p⟩) irreducible quadratic factors (Corollary 6.3).

> **Status: draft, not yet reviewed by a specialist.** The proofs assemble known results (Deligne–Rapoport, Aricheta's Theorem 3.1, Ogg's and Im–Jeon–Kim's fixed-point formulas, the genus formula) and make no priority claim for the underlying geometric identities. Nakaya proved N = 3 of Conjecture 6, and Morton proved N = 5 and N = 7. See `notes/AUTHOR_NOTES.md`.

## Idea of the proofs

1. Nakaya's Hauptmodul is an integral coordinate on X₀(N)⁺, so the roots of ss_p^(N*) are the supersingular points of X₀(N)⁺ in characteristic p, and the linear factors are the 𝔽_p-rational ones (Proposition 5.1).
2. The Deligne–Rapoport model of X₀(Np) mod p is two copies of X₀(N) glued at the supersingular points. Quotienting by Atkin–Lehner involutions and comparing genera gives:
   - the rational count, λ_p(X₀(N)⁺) = (r_p(Np) + r_Np(Np))/4, a count of fixed points of Atkin–Lehner involutions over ℂ (Theorem 1.1);
   - the total count, D = 1 + g(X₀(Np)/⟨w_N⟩) in genus zero (Lemma 3.1).
3. Ogg's fixed-point formula and the genus formula for X₀(Np) turn these into Nakaya's two formulas (Sections 4–6).

For N = 7 this settles the case of Conjecture 5 that Morton (arXiv:2206.09801v5, §3) had reduced to his open Conjectures 2–3. It does not prove those finer conjectures.

Only step 1 needs N ∈ 𝔖. The same arguments count the rational supersingular points (Corollary 5.2) and, with a genus correction, all supersingular points (Proposition 6.2) on X₀(N)⁺ at **every odd prime level N**, including levels where X₀(N)⁺ has positive genus.

## Repository layout

| Path | Contents |
|---|---|
| `paper/` | LaTeX source of the article, `Nakaya_Conjectures_5_6.tex` (compile with `pdflatex` twice; no external files needed) |
| `verification/verify_nakaya.gp` | Self-contained PARI/GP verification: builds the Hauptmoduli from modular-form spaces, computes ss_p^(N*), and compares the direct root count with Nakaya's formula and with independently enumerated fixed-point counts |
| `verification/run_extended.py` | cypari2 runner that reuses the stored relations (works on PARI 2.17) and extends the range |
| `verification/verify_general.gp` | Independent direct count of rational supersingular points at prime levels inside and outside 𝔖, from the modular polynomial Φ_N only (no Hauptmodul, genus or fixed-point formula) |
| `verification/c6_degrees.py` | Checks Nakaya's degree formula (Conjecture 6) against the polynomial degrees from the stored relations |
| `verification/c6_direct.gp` | Direct count of all supersingular points from Φ_N; checks Conjecture 6, Proposition 6.2 and the level-3 fixed-point count |
| `verification/conjecture6_second_implementation/` | Separate PARI/GP implementation of the degree check, with an Atkin–Lehner trace computation (PARI 2.15.4), its results and its own README |
| `verification/trace_example.gp` | Characteristic-zero Atkin–Lehner trace check of the worked example N = 11, p = 13 |
| `verification/relations/`, `polynomials/` | Exact modular relations and supersingular polynomials for each level |
| `verification/n2/` | Supplementary level-2 run |
| `verification/results/` | CSV, logs, summary JSON, and the original package's SHA-256 manifest |
| `notes/` | Source audit and author notes |
| `exploratory/` | Pre-proof numerical experiments (history only) |
| `supplements/prime-square-levels/` | Separate note proving λ_p(X₀(ℓ²)⁺) = (ℓ+1)/2 · L(p), with its own direct-enumeration verification package (not part of the main paper) |

## Reproducing the verification

**PARI/GP 2.15.x** (as used for the recorded run):
```sh
cd verification
gp -fq -s 256000000 verify_nakaya.gp
# expected final line: ALL PASSED: 827 cases   (all 14 levels, 5 ≤ p ≤ 300)
```

**PARI/GP 2.17.x**: `verify_nakaya.gp` stops at N = 13 with `unexpected Hauptmodul dimension`, because `mfatkininit` behaves differently for the weight-12 space in that version. Use the stored relations instead:
```sh
pip install cypari2
cd verification
python run_extended.py 2000          # Conjecture 5
python c6_degrees.py 1500            # Conjecture 6
gp -fq -s 1000000000 c6_direct.gp    # Conjecture 6, direct count from Phi_N
```

### Conjecture 5 (linear factors)

| Run | PARI version | Range | Pairs | Mismatches |
|---|---|---|---|---|
| `verify_nakaya.gp` | 2.15.4 | p ≤ 300 | 827 | 0 |
| level-2 supplement | 2.15.4 | p ≤ 300 | 60 | 0 |
| `run_extended.py` | 2.17.2 | p ≤ 2000 | 4201 | 0 |
| `verify_general.gp`, levels 11–23 (control) | 2.17.2 | p ≤ 1300, p ≡ 1 (mod 12) | 230 | 0 |
| `verify_general.gp`, levels 37–73 (outside 𝔖) | 2.17.2 | p ≤ 1300, p ≡ 1 (mod 12) | 238 | 0 |
| `verify_general.gp`, levels 79–127 (outside 𝔖) | 2.17.2 | p ≤ 600, p ≡ 1 (mod 12) | 58 | 0 |

**General-level check** (Appendix A.5 of the paper). Run in PARI/GP with `gp -fq -s 512000000 verify_general.gp`, or set `VG_LEVELS` and `VG_MAXP` before `read`. Points over a Frobenius-stable pair (j, j′) with several isogenies are separated by the branch tangents of Φ_N(x, y) = 0; 10,881 such points were resolved. 237 small pairs (all with p < 4N) had a repeated tangent slope and were skipped and reported, not guessed. Primes p ≢ 1 (mod 12) are not covered by this check. Full log: `results/general_levels_run.log`.

### Conjecture 6 (degree)

| Run | PARI version | Range | Pairs | Mismatches |
|---|---|---|---|---|
| `c6_degrees.py`: degrees recorded by `verify_nakaya.gp` | 2.17.2 | p ≤ 300 | 827 | 0 |
| `c6_degrees.py`: fresh degrees from stored relations | 2.17.2 | 300 < p ≤ 1500 | 2478 | 0 |
| `conjecture6_second_implementation/` (direct degrees) | 2.15.4 | p ≤ 300 and p = 307, 401, 503, 1009 | 883 | 0 |
| `conjecture6_second_implementation/` (cusp-form traces) | 2.15.4 | p = 5, 7, 13 | 39 | 0 |
| `c6_direct.gp`: Nakaya levels 11–31 | 2.17.2 | p ≤ 700, p ≡ 1 (mod 12) | 167 | 0 |
| `c6_direct.gp`: levels 37–73, Proposition 6.2 (genus 1–2) | 2.17.2 | p ≤ 600, p ≡ 1 (mod 12) | 87 | 0 |
| `c6_direct.gp`: level-3 fixed points r₃(3p) | 2.17.2 | 5 ≤ p ≤ 43 | 12 | 0 |

Logs: `results/c6_degrees.log`, `results/c6_direct.log`. The second implementation's own `SHA256SUMS.json` also lists a draft report (`Report.*`) that the merged paper supersedes and that is not included; every other listed file matches its checksum.

Finite agreement checks the implementation and normalisations; it is not a substitute for the proofs.

## AI assistance

OpenAI ChatGPT/Codex and Anthropic Claude assisted with the exposition, literature and source checking, verification code, and editing, as disclosed in the manuscript. Responsibility for the mathematics rests with the human author.

## Licence

Code (`verification/`, `exploratory/`): MIT. Manuscript (`paper/`): all rights reserved.
