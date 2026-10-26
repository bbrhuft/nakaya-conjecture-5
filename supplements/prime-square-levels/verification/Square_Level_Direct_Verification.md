# Direct verification at square levels

Computational supplement, 26 October 2026.

## Result and independence

This supplement tests

\[
\lambda_p\bigl(X_0(\ell^2)/\langle w_{\ell^2}\rangle\bigr)
=\frac{\ell+1}{2}L(p),\qquad \ell\in\{3,5,7\},\quad p\geq5,\quad p\ne\ell,
\tag{5}
\]

by explicitly constructing the supersingular geometric points, their Frobenius permutation, and their Fricke permutation in characteristic \(p\). The count uses no field or order class numbers, no genus formula, no modular-form trace, and no characteristic-zero Atkin–Lehner fixed-point formula. The value \(L(p)\) on the right is itself obtained by counting the supersingular \(j\)-values fixed by \(p\)-power Frobenius. Thus the new test reaches the geometric counting layer that the earlier 208 characteristic-zero comparisons did not independently test.

All **505 distinct admissible pairs** agree with (5). This comprises every prime \(5\leq p\leq1000\), with \(p\ne\ell\), at all three levels (496 pairs), plus the separate primes 1009, 2003 and 5003 at all three levels (9 pairs). No admissible pair was skipped. The initial 178 pairs through 300 were also rerun as part of the extended survey and give identical aggregate data.

The path construction generated **695,714 cyclic subgroup kernels**, giving **685,906 coarse points on the covering curves** across the tested pairs. The counts include **12,508 rational quotient orbits with Frobenius-swapped lifts**. Special invariants occur in 394 tested pairs and are handled explicitly. Both direct implementations agree at all 505 pairs; the middle-pair implementation separately checked 5,260 rational middle-invariant fibres.

| Level | Distinct tested pairs | Mismatches |
|---:|---:|---:|
| 9 | 169 | 0 |
| 25 | 168 | 0 |
| 49 | 168 | 0 |

A deliberately collapsed j-triple count disagrees with the correct count in 401 of the 505 pairs. The complete CSV and the Python coverage audit are included. The final full-range rerun used an immutable copy of the published verifier; its source hash agrees exactly with the packaged source.

A separate standalone PARI/GP implementation was written for this test.

## Why a bare graph of j-values is insufficient

A cyclic \(\ell^2\)-isogeny factors uniquely, up to isomorphism of the intermediate curve, into two degree-\(\ell\) isogenies whose composite does not have kernel \(E[\ell]\). Equivalently the second step does not retrace the dual of the first, in the sense of actual isogenies up to target isomorphism. This is the non-backtracking condition used by Colò and Kohel (2020, Section 2). It does not mean that the endpoint \(j\)-value differs from the starting \(j\)-value. A cyclic isogeny can be a loop, and distinct kernels can have the same source, intermediate and target \(j\)-values.

Moreover, the Frobenius permutation of those kernels is not determined by the triple \((j_0,j_1,j_2)\). At \(p=13\) there is only one supersingular invariant, \(j=5\). All paths therefore have the same triple \((5,5,5)\), yet the required rational quotient counts are \(2,3,4\). Collapsing to distinct triples gives only one object. The verifier records that deliberately insufficient count as a diagnostic, rather than treating it as the modular-curve count.

The implementation instead retains actual cyclic subgroup kernels as polynomials. It also takes the automorphism quotient at \(j=0,1728\), so these characteristics are included without the restriction \(p\equiv1\pmod{12}\).

## Supersingular starting curves

The initial set is obtained from the Legendre Hasse polynomial

\[
H_p(z)=\sum_{i=0}^{(p-1)/2}\binom{(p-1)/2}{i}^{\!2}z^i.
\]

Its roots give the supersingular Legendre parameters, and the map

\[
j(z)=256\frac{(z^2-z+1)^3}{z^2(z-1)^2}
\]

gives the complete supersingular \(j\)-set after removing repetitions. The Hasse criterion and displayed polynomial are classical; see Mula et al. (2025, Proposition 4.19), and Booher et al. (2024, Section 3, Proposition 1) for the splitting of these parameters over \(\mathbb F_{p^2}\). The program verifies complete splitting and the classical number of distinct supersingular \(j\)-values, and calls PARI's supersingularity test on each resulting curve.

For \(j\ne0,1728\), use the canonical short equation

\[
E_j:y^2=x^3+3kx+2k,\qquad k=\frac{j}{1728-j}.
\]

At \(j=0\) use \(y^2=x^3+1\), and at \(j=1728\) use \(y^2=x^3+x\). These choices commute with \(p\)-power Frobenius. For every chosen model, the program verifies
\(\#E_j(\mathbb F_{p^2})=(p-1)^2\) or \((p+1)^2\). Thus its \(p^2\)-Frobenius is scalar \(\pm p\), and all its prime-to-\(p\) cyclic subgroups are stable over \(\mathbb F_{p^2}\). This is used to construct their kernel polynomials over that field. The scalar conclusion also follows directly from the Frobenius polynomial: \((\pi\mp p)^2=0\), and a nonzero elliptic-curve endomorphism cannot have square zero.

## Enumeration of kernels and actual duals

Put \(k_\ell=(\ell-1)/2\). A subgroup of order \(\ell\) is represented by its monic kernel polynomial

\[
h(x)=\prod_{P\in(C\setminus\{0\})/\{\pm1\}}(x-x(P)),\qquad \deg h=k_\ell.
\]

Factor the \(\ell\)-division polynomial. For a root \(x(P)\) of any irreducible factor, evaluate the rational functions \(x([m]P)\), \(1\leq m\leq k_\ell\), to recover \(h\). No ordinate of \(P\) is required. The resulting coefficients descend to \(\mathbb F_{p^2}\). The implementation verifies that it obtains exactly \(\ell+1\) distinct kernel polynomials and that their product is the monic \(\ell\)-division polynomial.

Vélu's formulas produce an isogeny for each kernel. Canonicalizing the target equation gives its rational \(x\)-map in the form

\[
R_e(x)=\frac{t_e f_e(x)}{h_e(x)^2},
\]

where \(f_e\) is monic and \(t_e\in\mathbb F_{p^2}^*\). If \(K\) is a second-step kernel of degree \(k_\ell\), the monic polynomial of the composite kernel is

\[
\mathcal K(e,K)
=h_e(x)\sum_{i=0}^{k_\ell}K_i\,[t_e f_e(x)]^i
 h_e(x)^{2(k_\ell-i)},\qquad K(x)=\sum_iK_i x^i.
\]

Exactly one second kernel gives \(E[\ell]\), detected by equality with the monic \(\ell\)-division polynomial. That kernel is the dual edge and is discarded. All remaining composites are cyclic: a group of order \(\ell^2\) is either cyclic or equals \(E[\ell]\). Every cyclic subgroup has its unique order-\(\ell\) subgroup as first step. The code verifies exactly \(\ell(\ell+1)\) distinct cyclic composite kernels over each starting curve.

For additional assurance, the code constructs the actual dual of every edge. If \(e^*\) is the canonical edge having the dual kernel, its map can differ from the true dual by a target automorphism. The required correction on \(x\) is

\[
a_e=\frac1{\ell^2t_et_{e^*}}.
\]

This follows by comparing leading terms at infinity with the multiplication map \([\ell]\), whose \(x\)-map has leading term \(x/\ell^2\). The code checks that \(a_e\) is an automorphism of the source and verifies the full rational identity

\[
a_e R_{e^*}(R_e(x))=x([\ell]P).
\]

Consequently Fricke reversal is computed with the actual duals, including the necessary automorphism correction at the intermediate curve. It is not implemented by merely reversing a triple of \(j\)-values.

## Coarse points, Frobenius and the quotient

A monic polynomial \(h\) represents a geometric point of \(X_0(\ell^2)\) only up to automorphisms of its source curve. On \(x\)-coordinates the reduced automorphism group is trivial at a generic \(j\), is \(\mu_3\) at \(j=0\), and is \(\mu_2\) at \(j=1728\). For \(c\) in that group, its action on a degree-\(m\) kernel is

\[
h(x)\longmapsto c^m h(x/c).
\]

The program chooses a representative of every such orbit. Its geometric point set is therefore the coarse set of pairs \((E,C)\), with no automorphism weights. It explicitly verifies that both actions are independent of the chosen representative.

Frobenius sends \(j\) to \(j^p\) and raises every kernel coefficient to its \(p\)-th power. Fricke sends a cyclic isogeny to its dual, using the construction just described. Their permutations \(F,W\) on the entire coarse point set satisfy the checked identities

\[
F^2=W^2=1,\qquad FW=WF.
\]

The direct count iterates over the \(W\)-orbits. Such an orbit is rational over \(\mathbb F_p\) exactly when \(F(P)\in\{P,W(P)\}\). Thus it includes Frobenius-stable quotient points with no rational lift. As a separate finite-set consistency check, the code verifies

\[
\#\{\mathbb F_p\text{-rational }W\text{-orbits}\}
=\tfrac12\bigl(\#\operatorname{Fix}(F)+\#\operatorname{Fix}(WF)\bigr).
\]

These fixed points are explicitly computed permutations in characteristic \(p\), rather than the characteristic-zero fixed-point formula used in the earlier arithmetic verifier.

The Python audit additionally checks the special fibres by elementary eigenline counts modulo \(\ell^2\). Above \(j=0\), the expected orbit counts are \(4,10,20\) for \(\ell=3,5,7\); above \(j=1728\) they are \(6,16,28\). These checks do not use (5).

## Worked example and saved point sets

At \(p=13\), \(L(13)=1\) and \(j=5\) is the only supersingular invariant. The complete calculation is:

| Level | Cyclic kernels / coarse \(X_0\)-points | Fricke orbits | Rational Fricke orbits | Rational orbits with swapped lifts |
|---:|---:|---:|---:|---:|
| 9 | 12 | 6 | 2 | 2 |
| 25 | 30 | 15 | 3 | 3 |
| 49 | 56 | 28 | 4 | 3 |

The files `example_p13_ell3.gp`, `example_p13_ell5.gp`, and `example_p13_ell7.gp` store every kernel and both permutations, including the defining polynomial of the coefficient field. `audit_snapshots.gp` reloads those point sets, verifies Frobenius directly on the stored kernel coefficients, checks the permutation identities and recounts the quotient orbits.

| p | L(p) | level 9 | level 25 | level 49 |
|---:|---:|---:|---:|---:|
| 5 | 1 | 2 | excluded | 4 |
| 7 | 1 | 2 | 3 | excluded |
| 11 | 2 | 4 | 6 | 8 |
| 13 | 1 | 2 | 3 | 4 |
| 37 | 1 | 2 | 3 | 4 |
| 101 | 7 | 14 | 21 | 28 |
| 293 | 9 | 18 | 27 | 36 |
| 997 | 7 | 14 | 21 | 28 |
| 1009 | 10 | 20 | 30 | 40 |
| 2003 | 18 | 36 | 54 | 72 |
| 5003 | 30 | 60 | 90 | 120 |


## Scope

There is also a second direct implementation, `verify_middle_pairs.gp`. It uses the classical split Cartan description: the middle curve of a cyclic two-step path is equipped with an unordered pair of distinct order-\(\ell\) subgroups. It constructs these pairs and their automorphism orbits directly and applies Frobenius, without calling the first verifier's Vélu, dual-map or Fricke-reversal routines. It shares only the Hasse-set and prime-order kernel constructors. Its counts are compared with the first implementation for every tested pair.

`Prime_Square_Cartan_Proof.md` gives a short direct derivation of (5) from that interpretation, including the special automorphism cases. It uses twisted orbit counting and the trace-zero action of supersingular Frobenius on \(E[\ell]\). The underlying moduli interpretation is classical; no novelty claim is made.

This is direct verification of the rational supersingular coarse-point count at three non-squarefree levels. It supplies substantially more independent computational evidence than repeating the class-number or modular-form-trace calculation. It does not replace the geometric proof, establish novelty, extend the theorem to all \(n\mid h\) moonshine fixing groups, or compute a normalized Hauptmodul polynomial. Its finite-field enumeration directly tests the assertion of (5), including the special automorphisms and the swapped-lift cases.

## References

Booher, J., et al. (2024). Failing to hash into supersingular isogeny graphs. *The Computer Journal, 67*(8), 2702–2719. https://doi.org/10.1093/comjnl/bxae038. Section 3, Proposition 1, inspected in the published text.

Colò, L., & Kohel, D. (2020). Orienting supersingular isogeny graphs. *Journal of Mathematical Cryptology, 14*(1), 414–437. https://doi.org/10.1515/jmc-2019-0034. The non-backtracking criterion and cyclicity statement were checked directly in arXiv:2012.10803v1, Definition 3 and Lemma 4, p. 5; published numbering is not assumed. The two-step-path argument needed here is also proved above.

Mula, M., Murru, N., & Pintore, F. (2025). On random sampling of supersingular elliptic curves. *Annali di Matematica Pura ed Applicata, 204*, 1293–1335. https://doi.org/10.1007/s10231-024-01528-x. Published Proposition 4.19 and the publication details were checked directly.

The PARI Group. *PARI/GP: Elliptic curves and arithmetic functions*. Official function documentation: https://pari.math.u-bordeaux.fr/dochtml/html-stable/Elliptic_curves.html and https://pari.math.u-bordeaux.fr/dochtml/html-stable/Arithmetic_functions.html. The program was tested under version 2.15.4.

ChatGPT/Codex assisted with the mathematical description, source checking, implementation, execution and audit of this computational supplement. Human authorial responsibility and independent mathematical review remain necessary for any journal use.
