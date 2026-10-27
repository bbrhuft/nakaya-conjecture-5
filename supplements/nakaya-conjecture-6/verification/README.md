# Nakaya Conjecture 6 research package

The report proves the stated fourteen-level conjecture by a uniform deduction from classical modular-curve geometry. The handover's proposed Riemann--Hurwitz simplification has a sign and constant error; the corrected formula is in Report.md, Report.tex and Report.pdf. Level 3 is treated with its exceptional fixed-point summand. No priority claim or reliance on numerical agreement is made.

## Reading

Report.pdf is the rendered mathematical report. Report.md is the readable source and Report.tex is standalone, compilable LaTeX. The references distinguish inspected preprints from published versions and exact earlier level-specific proofs from the all-level deduction of existing theorems.

## Reproduction

Use PARI/GP 2.15 or newer and Python 3, with no additional Python modules. Run these commands from the directory containing this README. The results directory must exist; it is supplied. Each program replaces its own generated output files. The trace program takes substantially longer than the direct polynomial program. Redirecting logs exactly as below is necessary for the strict Python log audit.

```sh
gp -fq -s 768000000 code/verify_conjecture6.gp > results/direct.log 2>&1
gp -fq -s 768000000 code/verify_traces.gp > results/traces.log 2>&1
python3 code/audit_results.py > results/audit.log
```

The expected success markers are `ALL PASSED: 883` and `TRACE PASSED: 39`. The Python audit verifies complete coverage and rejects GP error markers, missing rows and duplicate rows. It produces results/summary.json. The supplied audit log records the completed run. GP exit status alone is insufficient because GP can continue after some parser errors.

The standalone degree verifier reconstructs the Hauptmoduli and modular equations, computes supersingular resultant radicals, checks their degrees against Conjecture 6, and checks squarefreeness and quadratic-field splitting. Its ordinary supersingular polynomials are independently checked with the Legendre Hasse polynomial. No stored polynomial relation is an input to this run; all results/relation_N.gp files are generated output.

The characteristic-zero verifier computes the Atkin--Lehner matrices on full weight-two cusp-form spaces. It obtains invariant dimensions and fixed counts from traces without using the class-number formula as an input to that computation. Both methods share the PARI runtime. The direct construction adapts supplied code and is not claimed to be a new independently invented algorithm.

## Coverage

The direct run covers all fourteen levels at every admissible prime from 5 through 300, giving 827 pairs, plus all fourteen levels at primes 307, 401, 503 and 1009, giving 56 disjoint additional pairs. The 883 pairs include 89 with p smaller than N. The ordinary-polynomial cross-check covers 64 distinct primes. The trace run covers all admissible pairs at primes 5, 7 and 13, giving 39 cases. Every recorded comparison passed. The finite computation is evidence about implementation, not the proof.

## Results and provenance

results/degrees.csv gives the direct degree, conjectural expression, genus-based degree, covering genus, fixed-point count, rational-root count and elapsed milliseconds for every pair. results/traces.csv gives full cusp dimensions, traces and quotient genera. results/ordinary_ss.csv records the independent ordinary-polynomial comparison. results/levels.csv records the base-level invariants. results/examples.txt contains exact representative polynomials and factorizations. Complete generated modular relations and polynomials are retained in the remaining GP files. No all-883-case trace run was performed.

PROVENANCE.md records the input checksums and adaptations. SHA256SUMS.json authenticates this package's substantive files. Third-party research PDFs are cited in the report and are not redistributed in this output package. The attached inherited archives themselves are unmodified.

## Building the report

The supplied standalone TeX compiles with a standard LaTeX installation:

```sh
pdflatex -interaction=nonstopmode -halt-on-error Report.tex
pdflatex -interaction=nonstopmode -halt-on-error Report.tex
```

To regenerate that TeX from the Markdown, use Pandoc:

```sh
pandoc Report.md --from=markdown+tex_math_single_backslash+tex_math_dollars --standalone --to=latex --output=Report.tex
```
