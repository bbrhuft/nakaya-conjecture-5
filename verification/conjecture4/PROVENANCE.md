# Provenance and scope

Prepared 28 October 2026, Europe/Dublin date, from the three supplied PDFs
and verification.zip. The supplied manuscript was not modified.

## Computation

- GP executable: PARI/GP 2.15.4, amd64, GMP 6.3.0; Ubuntu package
  `pari-gp_2.15.4-2.1build1_amd64.deb`, extracted in scratch for this run.
- Random seed: 20261028. All algebra is exact; real numbers are used only
  to format timing output.
- Main command: `gp -fq -s 1000000000 code/verify_c4.gp > results/run.log 2>&1`.
- Final clean run: 1,127 pairs, zero failures, 246 flagged pairs, 11.624 s.
- Source: `nk_*` routines adapt the supplied
  `verification/conjecture6_second_implementation/code/verify_conjecture6.gp`
  (itself adapted from the supplied `verify_nakaya.gp`). Precision was
  increased to 6*N+80 before pole-part elimination. The reconstruction
  contains no input relation tables. The multiplicity, correction-factor,
  collision and outside-domain audit was written for this request.
- No `verify_duality.gp` was present in the supplied ZIP.
- The GP version is pinned. The 2.17.2 Hauptmodul dimension issue is not
  diagnosed or fixed here.
- The ordinary ss formula was independently checked by elimination from
  the Legendre Hasse polynomial at each of the 76 survey primes.
- Supersingular Fricke polynomials are computed as radicals of the actual
  resultants, not from the predicted correction formula. This satisfies
  Nakaya's definition but is not a second moduli construction.
- `audit_outputs.py` is a saved-output consistency audit, not an independent
  mathematical implementation of the multiplicity theorem.

## Proof and source status

The theorem/proof in this report is a derivation made for this request. It
uses the standard tame modular curve description and Jordan's supplied
Proposition 5.1; the norm, specialization and singular-model arguments are
written explicitly. Computational agreement is not used as a proof.

Nakaya: uploaded arXiv v1, Proposition 4 p. 14 and Conjecture 4/Remark 2
p. 18, read and rendered for checking.
Morton: uploaded arXiv v1, Theorems 1/3/5 on pp. 3/12/21, read and rendered.
The final journal page locations/numbering were not verified.
Jordan: supplied manuscript, Sections 2/5/6 and Appendix A inspected.
Aricheta: original SIGMA PDF, Theorem 3.1 p. 8 and introduction inspected.
Hajouji: arXiv:2303.09096v3 pp. 6-9 inspected (the Fricke-loop distinction
and definitions of the quadratic relation/resultant radical are explicit).
Beneish-Wen: arXiv:2609.39725v1, Proposition 3.16 p. 15 and Theorem A
inspected; no resultant identity located.
Sakai 2011/2014 and Tsutsumi 2007: publisher abstracts/previews and metadata
only; full theorem-level exclusion of overlap is not verified.
Kaneko-Zagier: author-hosted 1998 paper introduction inspected.
Nakaya Atkin-like paper: arXiv:2309.15360 introduction inspected.
Morton E7 paper: arXiv:2206.09801v5 abstract inspected; full theorem audit
not repeated. Journal page range in the report follows Jordan's bibliography.

Searches included both search engines, visible citing-paper lists for Nakaya
2019 and Morton 2023, and queries for Conjecture 4, resultant multiplicities,
and the named related literature. No all-level identity of the exact form
in the report was located. This is not evidence establishing priority.
All bibliographic uncertainties are retained explicitly in the report.

## Input SHA-256 checksums

- `1809.02363v1(2).pdf`: `8ad9e1127cb88ee309fafe2b9530e64866b567a326de0f2aa2432ec4239b2332`
- `2105.14532v1(1).pdf`: `8bd4518a6ca74192e9e8c7f2fd2086a112f34c42ba1f36d9ebfc26868150d2cb`
- `Nakaya_Conjectures_5_6(3).pdf`: `0675f5058199d25954b31640f15a7850d48f1f859e99abb9961681fa4db494bf`
- `verification.zip`: `0e2fd43ea216350a5de83c0bc133a5beaa308da0f03590758a0d37d5225d32b6`
