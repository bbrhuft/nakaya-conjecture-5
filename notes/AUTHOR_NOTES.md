# Notes for the human author

## Status and contribution

The manuscript is a twelve-page journal-style draft before any venue-specific reformatting. It keeps author, affiliation, and email placeholders. The mathematical contribution is framed as an explicit uniform deduction of Nakaya's formula from classical modular-curve geometry, Aricheta's theorem, and the fixed-point class-number formula. The arbitrary-level statement is made precise, but is itself a formal consequence of older general results. Beneish–Wen's Theorem 6.5 already implies the same geometric identity for squarefree total levels Np after Riemann–Hurwitz, although their preprint does not mention Nakaya. Morton's E7 preprint (arXiv v5, Section 3) had reduced the N = 7 case to his unproved Conjectures 2–3; the article settles N = 7 unconditionally. A novelty assessment by a specialist is essential before presenting the article as original research. No priority claim is made.

The proof uses the single-involution simplification supplied in the revision instructions. The cyclic-stabilizer explanation remains in the lifting lemma, where it is required. The flat proper quotient and structure-sheaf argument replaces the earlier resolution discussion. The article explicitly handles rational quotient points whose lifts are swapped by Frobenius.

The main 827-case verification passed, as did the supplementary 60-case level-two run. An extended run under PARI 2.17.2 using the stored relations (verification/run_extended.py) passed all 4,201 pairs with p ≤ 2000. The worked example N=11, p=13 was also checked by Atkin–Lehner traces on the characteristic-zero cusp-form space. These computations verify the requested finite range and the implementation; they are not a replacement for the geometric proof.

## Citation sign-off

Read SOURCE_AUDIT.md before submission. Katz–Mazur Theorem 13.1.3 has now been checked on the original page (p. 390). The proof itself cites the inspected original Deligne–Rapoport theorem directly. Morton's E7 paper is cited as Ramanujan Journal 63 (2024), 339–385, online 1 August 2023, without internal numbers; theorem and conjecture numbers are cited to arXiv:2206.09801v5, which was checked directly. Aricheta, Ogg and Beneish–Wen were re-checked against the primary texts in a second pass (26 October 2026).

Aricheta's complete hypotheses and conclusion have been restated faithfully, with a short verbatim definition, rather than reproducing the entire theorem as a long quotation. All uses are of quotient-curve geometric points, not of rational lifts. This is explicit in the source audit.

The statement about Morton's finer E7 formulas is limited to what this article does not prove and what the published abstract calls conjectural. It does not assert that a comprehensive later-literature search has established their current open status.

## Human review, authorship, and AI disclosure

The disclosure in the manuscript records substantive OpenAI ChatGPT/Codex assistance with mathematical exposition, literature retrieval, code preparation and execution, and editing, and Anthropic Claude assistance with source checking, the extended verification run, and copy-editing. It does not pretend that the assistance was confined to grammar. AI is not an author. A human author must review the sources, take responsibility for every argument and calculation, confirm the final text, and supply their actual details. Those approvals have not been performed by this workflow.

A number theorist with experience in modular curves should read the draft. In particular, have the reader independently check the arbitrary-level coarse-model argument, the Hauptmodul descent, the normalization conventions, and the prior-art assessment. Coauthorship should reflect an actual scholarly contribution, rather than being offered solely as a substitute for review.

Elsevier's current official journal policy requires disclosure of substantive AI use and human responsibility. Its policy was checked on 26 October 2026: https://www.elsevier.com/about/policies-and-standards/generative-ai-policies-for-journals . It permits AI support for literature synthesis and organization under human oversight, so the disclosure should accurately describe the assistance actually used.

The Ramanujan Journal's current official instructions say that LLMs do not satisfy authorship criteria, substantive use should be documented, and final text requires human accountability: https://link.springer.com/journal/11139/submission-guidelines . Its copy-editing exemption does not describe the assistance used here. Its instructions also ask for 150–250 abstract words, 4–6 keywords, numeric citations, and DOI links where available; adapt the final file to the selected journal's exact template. Confirm competing-interest, funding, contribution, and data-availability statements with the actual authors instead of inventing them.

After the human review is genuinely complete, the author may adapt the publisher's standard declaration to say that they reviewed and edited the AI-assisted material and accept full responsibility. Do not assert completed human review before it has occurred.

## Possible venues

Journal of Number Theory has the closest direct publication history for Nakaya and Morton's E5 work. The Ramanujan Journal has the published E7 paper and a related readership. Research in Number Theory and International Journal of Number Theory are also plausible subjects for a presubmission assessment. Proceedings of the American Mathematical Society would generally require a crisp original contribution, so it should not be selected on the basis of length alone. These are subject-fit suggestions, not predictions of acceptance. The prior-art overlap may mean that the appropriate form is an expository note or a short clarification rather than a new-research article.

Before choosing a venue, settle whether the explicit all-level deduction is already recorded elsewhere and how much originality the editor requires. A presubmission enquiry can describe the exact contribution without claiming a new Frobenius mechanism. No external submission, publication, or message has been sent.
