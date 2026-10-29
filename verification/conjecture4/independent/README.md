# Independent checks of the Conjecture 4 computations

These checks were added for release v1.2. They re-test the computations of Section 7 and Appendix A.7 with different software, starting only from the stored relations. Like the main survey, they check the implementation and normalizations; they are not a proof.

| Check | Script | Software | Result |
|---|---|---|---|
| Stored R<sub>2</sub>, R<sub>3</sub>, R<sub>5</sub>, R<sub>7</sub> equal the polynomials printed by Morton (arXiv:2105.14532v1, Section 1) | `check_relations.gp` | PARI/GP 2.15.4 | equal at all four levels |
| All fifteen stored relations are consistent with the classical modular polynomial Φ<sub>N</sub> (`polmodular`): the two roots of R<sub>N</sub>(X, Y<sub>0</sub>) satisfy Φ<sub>N</sub>(j, j′) = 0 on 20 random fibres over 𝔽<sub>1000003</sub> | `check_relations.gp` | PARI/GP 2.15.4 | 20/20 at every level |
| Re-implementation of Proposition 7.1 in FLINT: recompute U, A, B, E from a<sub>N</sub>, b<sub>N</sub>; compute the resultant and its factorization over 𝔽<sub>p</sub>; test the full identity, every exponent, the degree of the radical, and that every root lies in 𝔽<sub>p²</sub> | `flint_c4.py` | python-flint 0.9.0 | all 4,502 pairs with 5 ≤ p ≤ 2000, p ≠ N, at all fifteen levels agree; A, B, E agree with `verify_c4.gp` |

The Φ<sub>N</sub> check confirms the curve R<sub>N</sub> = 0, not the additive normalization of the Hauptmodul; the normalizations are fixed by the construction in `verify_c4.gp` and, at N = 2, 3, 5, 7, by the comparison with Morton.

Two deliberately broken versions of `flint_c4.py` (one omitting the correction factor C<sub>N,p</sub>, one with the wrong exponent of A<sub>N</sub>) fail on more than half of the pairs with p ≤ 100, so the check can detect errors.

The degree comparison uses Corollary 1.3 at odd N. At N = 2, which that corollary excludes, it uses (p − 1)/8 + 3(1 − (−1/p))/8 + (1 − (−2/p))/4, obtained by taking degrees in Proposition 7.1; there it is a consistency check only.

## Run

From `verification/conjecture4/`:

```sh
gp -q independent/export_relations.gp                 # writes independent/relations.json
gp -q -s 2000000000 independent/check_relations.gp > independent/check_relations.log
cd independent
pip install python-flint                              # tested with 0.9.0
python3 flint_c4.py relations.json 2000 > flint_c4_p2000.log
```

The FLINT run to p ≤ 2000 takes about 25 minutes on one core; `python3 flint_c4.py relations.json 400` (about 10 seconds) reproduces the 1,127 pairs of Appendix A.7.

A note on scope: the discriminant of every E<sub>N</sub> has no prime factor other than 2, 3 and N (see `../results/integer_factors_N.txt`), so the reduction of E<sub>N</sub> is squarefree for every prime p ≥ 5 with p ≠ N, as the proof of Proposition 7.1 requires. This holds for all such primes, not only the tested range.

Prepared by Anthropic Claude Opus 5.5 on 29 October 2026, Europe/Dublin date.
