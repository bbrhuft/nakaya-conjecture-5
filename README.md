# Nakaya's Conjectures 5 and 6: linear factors and degree of Fricke supersingular polynomials

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23698277.svg)](https://doi.org/10.5281/zenodo.23698277)

Manuscript and exact PARI/GP verification for a deduction of two conjectures of Nakaya (*J. Number Theory* 204 (2019)) on the supersingular polynomial ss<sub>p</sub><sup>(N\*)</sup> attached to the Fricke group Γ<sub>0</sub>(N)<sup>+</sup>, at every prime level N ∈ {3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71} and every prime p ≥ 5, p ≠ N:

- **Conjecture 5:** a class-number formula for the number of linear factors of ss<sub>p</sub><sup>(N\*)</sup> over 𝔽<sub>p</sub> (Corollary 1.2);
- **Conjecture 6:** a formula for the degree of ss<sub>p</sub><sup>(N\*)</sup>, the total number of supersingular points on X<sub>0</sub>(N)<sup>+</sup> (Corollary 1.3).

Together with Aricheta's theorem, they determine the factorization over 𝔽<sub>p</sub>: ss<sub>p</sub><sup>(N\*)</sup> has that many linear factors and exactly g(X<sub>0</sub>(Np)/⟨w<sub>N</sub>, w<sub>p</sub>⟩) irreducible quadratic factors (Corollary 6.3).

> **Status: draft, not yet reviewed by a specialist.** The proofs assemble known results (Deligne–Rapoport, Aricheta's Theorem 3.1, Ogg's and Im–Jeon–Kim's fixed-point formulas, the genus formula) and make no priority claim for the underlying geometric identities. Nakaya proved N = 3 of Conjecture 6, and Morton proved N = 5 and N = 7. See `notes/AUTHOR_NOTES.md`.

## Idea of the proofs

1. Nakaya's Hauptmodul is an integral coordinate on X<sub>0</sub>(N)<sup>+</sup>, so the roots of ss<sub>p</sub><sup>(N\*)</sup> are the supersingular points of X<sub>0</sub>(N)<sup>+</sup> in characteristic p, and the linear factors are the 𝔽<sub>p</sub>-rational ones (Proposition 5.1).
2. The Deligne–Rapoport model of X<sub>0</sub>(Np) mod p is two copies of X<sub>0</sub>(N) glued at the supersingular points. Quotienting by Atkin–Lehner involutions and comparing genera gives the three identities displayed below: the rational count (Theorem 1.1), the total count in genus zero (Lemma 3.1), and Aricheta's identity, rederived from the same quotient model (Lemma 3.2).
3. Ogg's fixed-point formula and the genus formula for X<sub>0</sub>(Np) turn these into Nakaya's two formulas (Sections 4–6).

Here X = X<sub>0</sub>(N)<sup>+</sup>, B = X<sub>0</sub>(Np)/⟨w<sub>N</sub>, w<sub>p</sub>⟩, D is the total number of supersingular points on X in characteristic p, and λ = λ<sub>p</sub>(X) is the number of 𝔽<sub>p</sub>-rational ones. The terms r<sub>p</sub>(Np) and r<sub>Np</sub>(Np) count fixed points of the Atkin–Lehner involutions w<sub>p</sub> and w<sub>Np</sub> on X<sub>0</sub>(Np) over ℂ.

For N = 7 this settles the case of Conjecture 5 that Morton (*Ramanujan J.* 63 (2024), §3) had reduced to his Conjectures 1–3, of which he proved Conjecture 1 (Theorem A). It does not prove his finer Conjectures 2–3.

Only step 1 needs N ∈ 𝔖. The same arguments count the rational supersingular points (Corollary 5.2) and, with a genus correction, all supersingular points (Proposition 6.2) on X<sub>0</sub>(N)<sup>+</sup> at **every odd prime level N**, including levels where X<sub>0</sub>(N)<sup>+</sup> has positive genus.

## Repository layout

| Path | Contents |
|---|---|
| `paper/` | The article: LaTeX source `Nakaya_Conjectures_5_6.tex` (compile with `pdflatex` twice; no external files needed) and the compiled PDF |
| `verification/verify_nakaya.gp` | Self-contained PARI/GP verification: builds the Hauptmoduli from modular-form spaces, computes ss<sub>p</sub><sup>(N\*)</sup>, and compares the direct root count with Nakaya's formula and with independently enumerated fixed-point counts |
| `verification/run_extended.py` | cypari2 runner that reuses the stored relations (works on PARI 2.17) and extends the range |
| `verification/verify_general.gp` | Independent direct count of rational supersingular points at prime levels inside and outside 𝔖, from the modular polynomial Φ<sub>N</sub> only (no Hauptmodul, genus or fixed-point formula) |
| `verification/c6_degrees.py` | Checks Nakaya's degree formula (Conjecture 6) against the polynomial degrees from the stored relations |
| `verification/c6_direct.gp` | Direct count of all supersingular points from Φ<sub>N</sub>; checks Conjecture 6, Proposition 6.2 and the level-3 fixed-point count |
| `verification/conjecture6_second_implementation/` | Separate PARI/GP implementation of the degree check, with an Atkin–Lehner trace computation (PARI 2.15.4), its results and its own README |
| `verification/trace_example.gp` | Characteristic-zero Atkin–Lehner trace check of the worked example N = 11, p = 13 |
| `verification/relations/`, `polynomials/` | Exact modular relations and supersingular polynomials for each level |
| `verification/n2/` | Supplementary level-2 run |
| `verification/results/` | CSV, logs, summary JSON, and the original package's SHA-256 manifest |
| `notes/` | Source audit and author notes |
| `exploratory/` | Pre-proof numerical experiments (history only) |
| `supplements/prime-square-levels/` | Separate note proving λ<sub>p</sub>(X<sub>0</sub>(ℓ<sup>2</sup>)<sup>+</sup>) = ((ℓ+1)/2) · L(p), with its own direct-enumeration verification package (not part of the main paper) |

## Reproducing the verification

The version matching the manuscript is release v1.0, archived on Zenodo as doi:10.5281/zenodo.23698277. All commands are run from `verification/`. "Reconstructed" means the run rebuilds the Hauptmoduli and modular relations from spaces of modular forms; "stored" means it reads `relations/relation_N.gp`, produced by the reconstructing run under PARI/GP 2.15.4; "none" means it uses only the classical supersingular polynomial and the modular polynomial Φ<sub>N</sub>.

| Survey | Command | Hauptmoduli | PARI | Expected final output |
|---|---|---|---|---|
| Conjecture 5, p ≤ 300 | `gp -fq -s 256000000 verify_nakaya.gp` | reconstructed | 2.15.4 | `ALL PASSED: 827 cases` |
| Level 2, p ≤ 300 | `NK_MAXP=300; NK_LEVELS=[2]; read("verify_nakaya.gp")` | reconstructed | 2.15.4 | `ALL PASSED: 60 cases` |
| Conjecture 5, p ≤ 2000 | `python run_extended.py 2000` | stored | 2.17.2 | `TOTAL 4201 pairs, mismatches: none` |
| Other prime levels (paper, Corollary 5.2) | `verify_general.gp` with `VG_LEVELS`, `VG_MAXP` (paper, Appendix A.5) | none | 2.17.2 | `ALL AGREE: 468 cases`; `ALL AGREE: 58 cases` |
| Conjecture 6, p ≤ 1500 | `python c6_degrees.py 1500` | stored | 2.17.2 | Part 1: 827 pairs, Part 2: 2478 pairs, `mismatches: none` |
| Conjecture 6, second implementation | in `conjecture6_second_implementation/`: `gp -fq -s 768000000 code/verify_conjecture6.gp`, then `code/verify_traces.gp` | reconstructed | 2.15.4 | `ALL PASSED: 883`; `TRACE PASSED: 39` |
| Conjecture 6 and Proposition 6.2, direct | `gp -fq -s 1000000000 c6_direct.gp` | none | 2.17.2 | (a) 167 pairs, (b) 87 pairs, (c) 12 primes, each with `mismatches []` |
| Worked example N = 11, p = 13 | `gp -fq trace_example.gp` | none | 2.15.4 | fixed-point counts 4 and 20 |

`verify_nakaya.gp` writes `verification.csv`, `relation_N.gp` and `polynomials_N.gp`. To load its functions without running a survey, set `NK_NO_RUN=1` before `read`.

**PARI/GP 2.15.x** (as used for the recorded run):
```sh
cd verification
gp -fq -s 256000000 verify_nakaya.gp
# expected final line: ALL PASSED: 827 cases   (all 14 levels, 5 ≤ p ≤ 300)
```

**PARI/GP 2.17.x**: `verify_nakaya.gp` stops at N = 13 with `unexpected Hauptmodul dimension`. Levels 3, 5, 7 and 11 run unchanged. At N = 13 the construction uses `mf=mfinit([13,12],4)`, the full space M<sub>12</sub>(Γ<sub>0</sub>(13)) of dimension 15, and `at=mfatkininit(mf,13)`, whose normalizing constant `at[3]` is 1. In that environment the matrix `at[2]` does not satisfy `at[2]^2 = 1`, and its +1 eigenspace (the eigenvalue (−1)<sup>k/2</sup> required for k = 12) has dimension 7 instead of the expected m + 1 = 8, so the dimension check fails. The same construction passed all checks under 2.15.4. The cause has not been isolated, and no PARI defect is claimed. Use the stored relations instead (or load `relation_N.gp`, set `NK_NO_RUN=1`, and call `nk_polynomial`, `nk_rhs` and `nk_fixed` directly):
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

**General-level check** (Appendix A.5 of the paper). Run in PARI/GP with `gp -fq -s 512000000 verify_general.gp`, or set `VG_LEVELS` and `VG_MAXP` before `read`. Points over a Frobenius-stable pair (j, j′) with several isogenies are separated by the branch tangents of Φ<sub>N</sub>(x, y) = 0; 10,881 such points were resolved. 237 small pairs (all with p < 4N) had a repeated tangent slope and were skipped and reported, not guessed. Primes p ≢ 1 (mod 12) are not covered by this check. Full log: `results/general_levels_run.log`.

### Conjecture 6 (degree)

| Run | PARI version | Range | Pairs | Mismatches |
|---|---|---|---|---|
| `c6_degrees.py`: degrees recorded by `verify_nakaya.gp` | 2.17.2 | p ≤ 300 | 827 | 0 |
| `c6_degrees.py`: fresh degrees from stored relations | 2.17.2 | 300 < p ≤ 1500 | 2478 | 0 |
| `conjecture6_second_implementation/` (direct degrees) | 2.15.4 | p ≤ 300 and p = 307, 401, 503, 1009 | 883 | 0 |
| `conjecture6_second_implementation/` (cusp-form traces) | 2.15.4 | p = 5, 7, 13 | 39 | 0 |
| `c6_direct.gp`: Nakaya levels 11–31 | 2.17.2 | p ≤ 700, p ≡ 1 (mod 12) | 167 | 0 |
| `c6_direct.gp`: levels 37–73, Proposition 6.2 (genus 1–2) | 2.17.2 | p ≤ 600, p ≡ 1 (mod 12) | 87 | 0 |
| `c6_direct.gp`: level-3 fixed points r<sub>3</sub>(3p) | 2.17.2 | 5 ≤ p ≤ 43 | 12 | 0 |

Logs: `results/c6_degrees.log`, `results/c6_direct.log`. The second implementation's own `SHA256SUMS.json` also lists a draft report (`Report.*`) that the merged paper supersedes and that is not included; every other listed file matches its checksum.

Finite agreement checks the implementation and normalisations; it is not a substitute for the proofs.

## How to cite

Jordan, D. (2026). *Nakaya's conjectures on the linear factors and degree of Fricke supersingular polynomials: manuscript and PARI/GP verification* (Version v1.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.23698277

The v1.0 release is the version matching the manuscript.

## AI assistance

OpenAI ChatGPT/Codex and Anthropic Claude assisted with the exposition, literature and source checking, verification code, and editing, as disclosed in the manuscript. Responsibility for the mathematics rests with the author.

## Licence

- Code (`verification/`, `exploratory/`, and the verification code in `supplements/prime-square-levels/`): MIT; see [`LICENSE`](LICENSE).
- Manuscripts (`paper/` and the note in `supplements/prime-square-levels/`): all rights reserved.
