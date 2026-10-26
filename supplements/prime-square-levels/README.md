# Supplement: rational supersingular points on X₀(ℓ²)⁺

A short self-contained note proving

> λ_p(X₀(ℓ²)⁺) = (ℓ+1)/2 · L(p)  for distinct primes ℓ, p with ℓ odd and p ≥ 5,

where λ_p counts the 𝔽_p-rational supersingular points on the Fricke quotient X₀(ℓ²)⁺ and L(p) is the number of supersingular j-invariants in 𝔽_p. For ℓ = 3, 5, 7 the count is 2L(p), 3L(p), 4L(p).

This supplement is **separate from the main paper** (`paper/`), which is unchanged. It is independent of the paper's method: the proof uses the middle-curve (split Cartan) description of cyclic ℓ²-isogenies and the action of Frobenius on ℓ-torsion, with no class-number, genus or fixed-point formula. The result agrees with the class-number evaluation that follows from the paper's Theorem 1.1. No priority is claimed; X₀(ℓ²)⁺ is the classical split Cartan normalizer curve.

## Contents

| Path | Contents |
|---|---|
| `Prime_Square_Note.pdf` | The note (4 pages), as reviewed and corrected by the author |
| `Prime_Square_Note.tex` | LaTeX source of the note |
| `verification/` | Direct-enumeration verification package (PARI/GP 2.15.4), with its own README, reports, logs, CSVs and SHA-256 manifest |
| `independent_rerun.log` | Independent rerun of the package under PARI/GP 2.17.2 |

## Verification

The package builds every cyclic ℓ²-kernel as an explicit polynomial from Vélu isogenies, computes the Fricke involution from the actual dual isogenies and Frobenius from the kernel coefficients, and counts Frobenius-fixed orbits on X₀(ℓ²)⁺, including at j = 0 and 1728. It uses no class numbers, genus formulas or modular-form traces.

| Run | PARI/GP | Pairs (ℓ = 3, 5, 7) | Mismatches |
|---|---|---|---|
| `verify_square_direct.gp`: all p ≤ 1000, plus p = 1009, 2003, 5003 | 2.15.4 | 505 | 0 |
| `verify_middle_pairs.gp` (second implementation) | 2.15.4 | 505 | 0 |
| Independent rerun, including new primes 17, 23, 409, 1201 | 2.17.2 | 18 (+ 505 middle-pair) | 0 |

See `verification/README.md` for reproduction commands. The `SHA256SUMS.json` manifest in `verification/` matches every file as committed.

Finite agreement is evidence, not proof; the proof is the note.
