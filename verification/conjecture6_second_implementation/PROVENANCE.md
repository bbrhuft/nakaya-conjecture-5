# Provenance and verification limits

This package was created on 27 October 2026 from the supplied Nakaya_Conjecture6_Research_Handover(1).zip. All nine payload checksums in its SHA256SUMS.json were recomputed and matched. START_HERE.md, RESEARCH_PROMPT.md, PROVENANCE_AND_LIMITS.md, the published Nakaya PDF, and the latest Conjecture-5 draft were read before the proof was developed. Each nested README and the relevant source verifier and source audit were inspected. The latest user draft was kept distinct from the older nested article.

The functions nk_forms, nk_haupt, nk_faber, nk_relation, nk_ss, nk_rad and nk_polynomial in code/verify_conjecture6.gp are adapted from the supplied verify_nakaya.gp. Unused Conjecture-5 RHS and fixed-count functions were removed. The Conjecture-6 comparison, explicit level-3 fixed-count rule, independent Legendre-Hasse check, characteristic-zero trace survey, coverage auditing, safe output truncation and error reporting were added for this task. No inherited recorded success count is reported as a new measurement.

An initial new squarefreeness assertion compared a GP gcd to exactly 1; GP may return a nonunit-normalized constant gcd. That assertion was corrected to test degree zero. No conjectural formula or observed polynomial was changed to obtain agreement. A later output-truncation parser typo was corrected before the final rerun. The final logs and summary are from the corrected delivered programs.

The proof uses the corrected Riemann--Hurwitz identity D=(gC+3)/2-r/4, not the incorrect plus-sign version in the handover research prompt. The arithmetic-genus lemma was audited independently from the classical coarse model. The entire Conjecture-5 rational-point argument was not rerun as a separate theorem audit. Square-level and composite-level recorded computations are excluded from the new totals.

PARI/GP 2.15.4 was extracted from the Ubuntu package pari-gp_2.15.4-2.1build1_amd64.deb for local execution; Python was 3.12.14. No binary is redistributed. The code has no network or external coefficient-table requirement.

The report gives a complete deduction of the specified conjecture from existing modular-curve theorems. It does not claim a new geometric theorem, a novelty certificate, external peer review, or a formal proof-assistant verification. The literature search was completed on 27 October 2026. The general Beneish--Wen source is a September 2026 preprint and is accurately identified as such; the proof also follows directly from classical Deligne--Rapoport geometry.

## Input payload SHA-256 values

```json
{
  "PROVENANCE_AND_LIMITS.md": "4844ee6932da27e93a755e0479e4796170c0a59831f592842a4cccd337f1b058",
  "RESEARCH_PROMPT.md": "efe5fd709c0bcd14002dd10fad93aca24576bdc62c853641a5f05012556627d4",
  "START_HERE.md": "5573141b3471be77327cdc330310e4caa404e9802bdf3f83e97ae885043eddb1",
  "inherited/Composite_Level_Research_and_Code.zip": "98201deaf7c609830b832fef9c3167462d7563456eeff2d29373257ff68ba8cf",
  "inherited/Conjecture5_Source_and_Verification.zip": "23ef28cecb4791a3c57fdfb2a0f16f704d6de594f64b399c6f2b8fbeb13b5252",
  "inherited/Square_Level_Direct_Verification.zip": "e67b134040a2a35e2f688a03303c8a14fa7a56d355f2b81c8c4aa1058a44c54f",
  "papers/Conjecture5_latest_user_draft.pdf": "de81ba971f8f85bc76accbf691e7e2d2eb6baa47ff0151ec3d83990617aadb27",
  "papers/Nakaya_2019_published.pdf": "b7767b2649e4732eee63a762e716128b3cdfcbdaac7cf33e39cdb6e76fdf56a0",
  "papers/Square_levels_latest_user_note.pdf": "d8ea0c473901cf7d2ec4fab1445c6812a8559fdd4173231116cb705f4b06ed2c"
}
```
