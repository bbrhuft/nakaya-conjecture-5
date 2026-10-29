# Nakaya Conjecture 4: uniform multiplicity audit

The corrected identity passed all 1,127 pairs at the fifteen levels and primes
5 <= p <= 400, p != N. This includes 1,051 odd-level pairs and 76 at level 2.
All 246 collision-flagged pairs passed; no pairs were skipped. A complete
geometric proof, with the integral specialization argument, is in the report.
The proof now appears as Section 7 of the paper (Proposition 7.1); the report
is kept as written, and where the two differ the paper takes precedence.
Independent re-checks (FLINT, Morton and Phi_N comparisons) are in
`independent/` (added for release v1.2; not listed in SHA256SUMS.json).

## Run

Use **PARI/GP 2.15.4**. The script deliberately refuses other versions. This
uses the pinned-version option in the request; no fix for GP 2.17.2 is claimed.
No coefficient tables, Sage, Python mathematics packages, or network access
are used by the GP computation. Python 3 standard library suffices for the
saved-output audit.

Run from this directory:

```sh
mkdir -p results
gp --version
gp -fq -s 1000000000 code/verify_c4.gp > results/run.log 2>&1
python3 code/audit_outputs.py
```

The final computation took 11.624 seconds of GP wall-clock time on the
provided amd64 environment. Timings vary. The first command reserves a
1 GB PARI stack; this is a limit/reservation, not a claim of peak memory use.
The GP run overwrites its generated result files. Do not run two copies
against the same results directory simultaneously.

To use another range, save this driver as `run_custom.gp`:

```gp
P_MAX=1000;
read("code/verify_c4.gp");
```

Then run `gp -fq -s 1000000000 run_custom.gp > results/run.log 2>&1`.
For a subset, also assign `LEVELS=[11,13,17];` before `read`.
To load only functions, assign `C4_NO_RUN=1` before `read`.

## Mathematical normalization

`T` in the GP output is Nakaya's `Y`. The constant terms of the Hauptmoduli
are 104, 42, 16, 9 at levels 2, 3, 5, 7, and zero at the other eleven levels.
For Q_c=R_N(c,T), U_c is the full part of Q_c supported on gcd(Q_c,a_N-2c)
over Q. The correction polynomials satisfy

- Q_0 = U_0 * A^3;
- Q_1728 = U_1728 * B^2;
- a_N^2 - 4*b_N = E * H^2, with E squarefree over Q.

The identity is C*V = A^(2*delta)*B^epsilon*rad(V)^2 modulo p.
For odd N, C=E^mu_N. For N=2, C=T^epsilon*(T-256)^nu.
All factors are monic; the scalar is exactly 1. Keep multiplicities in the
reductions of A and B. Do not replace E by the radical of the full discriminant.

## Files

- `report/report.pdf`: source transcription, statement, proof, tables,
  exception lists, bibliography and novelty assessment (12 pages).
- `report/statement_and_proof.tex`: editable theorem and proof fragment;
  requires amsmath, amssymb, amsthm and theorem/lemma environments.
- `report/report.tex`: full LaTeX source. Compile in `report/` with pdflatex
  twice; the two generated table fragments are included.
- `code/verify_c4.gp`: all relation reconstruction and exact computations.
- `code/audit_outputs.py`: validates the complete pair grid, saved actual
  versus predicted factor matrices, degree columns and exception coverage;
  produces the status matrix and report tables. This is not a second proof.
- `results/run.log`: GP version, all A/B/E polynomials, per-level totals,
  timings and final outcome.
- `results/pairs.csv`: all 1,127 statuses and metrics.
- `results/status_matrix.csv`: requested N-by-p PASS matrix; diagonal OUTSIDE.
- `results/levels.csv`: correction degrees and checked q-remainder orders.
- `results/summary.csv`: per-level counts and timings.
- `results/ordinary_ss.csv`: 76 independent Legendre Hasse cross-checks.
- `results/relation_N.gp`: [a_N,b_N,k,m,q_sum_O,q_product_O].
- `results/data_N.gp`: [A_N,B_N,E_N,H_N,U_0,U_1728].
- `results/integer_factors_N.txt`: full integer factorizations of Q_0,
  Q_1728, disc_X(R_N), and disc(E_N).
- `results/correction_polynomials.txt`: consolidated A/B/E and U output.
- `results/factors_N.txt`: full actual and predicted factor matrices for all p.
- `results/radicals_N.gp`: independently computed monic radical polynomials.
- `results/exceptions.csv`: all 246 flagged pairs and diagnostic names.
- `results/exceptional_details.txt`: polynomial gcd certificates of collisions.
- `results/certificates.txt`: integer discriminants and pairwise resultants.
- `results/outside_scope.csv` and `.txt`: all 43 exploratory pairs, including
  p=2,3 and p=N; the formal squared diagonal test fails at all 13 odd diagonals.
- `results/audit.json` and `.log`: structural audit of the saved computation.
- `PROVENANCE.md`: inputs, tested environment, source coverage and limitations.
- `SHA256SUMS.json`: checksums of every packaged deliverable except itself.

The theorem numbers/pages for Morton are checked in arXiv v1 (Theorem 1
p. 3; Theorem 3 p. 12; Theorem 5 p. 21). Exact journal theorem pages and
unchanged numbering in the final typesetting are **not verified**. The report
makes no exhaustive priority claim.
