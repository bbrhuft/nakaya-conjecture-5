# Nakaya's Conjecture 5: linear factors of Fricke supersingular polynomials

Manuscript and exact PARI/GP verification for a deduction of **Nakaya's Conjecture 5**: a class-number formula for the number of linear factors over 𝔽_p of the supersingular polynomial ss_p^(N*) attached to the Fricke group Γ₀(N)⁺, for every prime level N ∈ {3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71} (Nakaya, *J. Number Theory* 204 (2019)).

> **Status: draft, not yet reviewed by a specialist.** The proof assembles known results (Deligne–Rapoport, Aricheta's Theorem 3.1, Ogg's fixed-point formula) and makes no priority claim for the underlying geometric identity. Author details in the manuscript are placeholders. See `notes/AUTHOR_NOTES.md`.

## Idea of the proof

1. Nakaya's count equals the number of 𝔽_p-rational supersingular points on X₀(N)⁺, using his Hauptmodul as an integral coordinate (Proposition 5.1).
2. The Deligne–Rapoport model of X₀(Np) mod p, together with Aricheta's genus identity and Riemann–Hurwitz, turns that number into a count of fixed points of Atkin–Lehner involutions on X₀(Np) over ℂ:  λ_p(X₀(N)⁺) = (r_p(Np) + r_Np(Np))/4  (Theorem 1.1).
3. Ogg's classical formula expresses the fixed-point counts as class numbers; converting to field class numbers gives Nakaya's formula (Corollary 1.2).

For N = 7 this settles the case that Morton (arXiv:2206.09801v5, §3) had reduced to his open Conjectures 2–3. It does not prove those finer conjectures.

Only step 1 needs N ∈ 𝔖. The same class-number formula therefore counts the rational supersingular points on X₀(N)⁺ at **every odd prime level N** (Corollary 5.2), including levels where X₀(N)⁺ has positive genus.

## Repository layout

| Path | Contents |
|---|---|
| `paper/` | LaTeX source of the article (compile with `pdflatex` twice; no external files needed) |
| `verification/verify_nakaya.gp` | Self-contained PARI/GP verification: builds the Hauptmoduli from modular-form spaces, computes ss_p^(N*), and compares the direct root count with Nakaya's formula and with independently enumerated fixed-point counts |
| `verification/run_extended.py` | cypari2 runner that reuses the stored relations (works on PARI 2.17) and extends the range |
| `verification/verify_general.gp` | Independent direct count at prime levels inside and outside 𝔖, from the modular polynomial Φ_N only (no Hauptmodul, genus or fixed-point formula) |
| `verification/trace_example.gp` | Characteristic-zero Atkin–Lehner trace check of the worked example N = 11, p = 13 |
| `verification/relations/`, `polynomials/` | Exact modular relations and supersingular polynomials for each level |
| `verification/n2/` | Supplementary level-2 run |
| `verification/results/` | CSV, logs, summary JSON, and the original package's SHA-256 manifest |
| `notes/` | Source audit and author notes |
| `exploratory/` | Pre-proof numerical experiments (history only) |

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
python run_extended.py 2000
# recorded result: 4201 pairs, 0 mismatches   (all 14 levels, 5 ≤ p ≤ 2000)
```

| Run | PARI version | Range | Pairs | Mismatches |
|---|---|---|---|---|
| `verify_nakaya.gp` | 2.15.4 | p ≤ 300 | 827 | 0 |
| level-2 supplement | 2.15.4 | p ≤ 300 | 60 | 0 |
| `run_extended.py` | 2.17.2 | p ≤ 2000 | 4201 | 0 |
| `verify_general.gp`, levels 11–23 (control) | 2.17.2 | p ≤ 1300, p ≡ 1 (mod 12) | 230 | 0 |
| `verify_general.gp`, levels 37–73 (outside 𝔖) | 2.17.2 | p ≤ 1300, p ≡ 1 (mod 12) | 238 | 0 |
| `verify_general.gp`, levels 79–127 (outside 𝔖) | 2.17.2 | p ≤ 600, p ≡ 1 (mod 12) | 58 | 0 |

**General-level check** (Appendix A.5 of the paper). Run in PARI/GP with `gp -fq -s 512000000 verify_general.gp`, or set `VG_LEVELS` and `VG_MAXP` before `read`. Points over a Frobenius-stable pair (j, j′) with several isogenies are separated by the branch tangents of Φ_N(x, y) = 0; 10,881 such points were resolved. 237 small pairs (all with p < 4N) had a repeated tangent slope and were skipped and reported, not guessed. Primes p ≢ 1 (mod 12) are not covered by this check. Full log: `results/general_levels_run.log`.

Finite agreement checks the implementation and normalisations; it is not a substitute for the proof.

## AI assistance

OpenAI ChatGPT/Codex and Anthropic Claude assisted with the exposition, literature and source checking, verification code, and editing, as disclosed in the manuscript. Responsibility for the mathematics rests with the human author.

## Licence

Code (`verification/`, `exploratory/`): MIT. Manuscript (`paper/`): all rights reserved.
