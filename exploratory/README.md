# Exploratory scripts (pre-proof)

These Python/cypari2 scripts predate the proof and are kept as history. They are not part of the paper's verification.

- `morton_nakaya.py` — joint numerical test of Nakaya's Conjecture 5 for N = 3, 5, 7, 13 (eta-quotient Hauptmoduln) and of Morton's E7 factor-count conjectures; agreed at every prime 11 ≤ p ≤ 5000.
- `nakaya_split.py` — splits Nakaya's count by fibre type (two rational roots / repeated root / conjugate pair) to test a Frobenius-type decomposition; imports `morton_nakaya.py`.

Requirements: `pip install cypari2`.
