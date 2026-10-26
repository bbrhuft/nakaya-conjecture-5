# A direct proof of the prime-square formula

The following deduction uses the classical split Cartan moduli interpretation. It is included as an explanation and an additional mathematical check of the direct computations. No claim of novelty or priority is made.

**Proposition.** Let \(p\geq5\) and \(\ell\) be distinct primes, with \(\ell\) odd. If \(L(p)\) is the number of supersingular \(j\)-invariants in \(\mathbb F_p\), then

\[
\lambda_p\bigl(X_0(\ell^2)^+\bigr)=\frac{\ell+1}{2}L(p).
\]

The count refers to unweighted geometric supersingular coarse points fixed by Frobenius. It does not require genus zero.

**The middle-curve description.** A cyclic degree-\(\ell^2\) isogeny has a canonical factorization

\[
E_0\xrightarrow{\phi_1}E\xrightarrow{\phi_2}E_2.
\]

The subgroups \(A=\ker\widehat\phi_1\) and \(B=\ker\phi_2\) of \(E[\ell]\) are distinct: if they were equal, the composite would have kernel \(E_0[\ell]\), rather than a cyclic kernel. Conversely, from \(E\) with an ordered pair of distinct subgroups \((A,B)\), take the dual of \(E\to E/A\), followed by \(E\to E/B\). Their composite has cyclic degree \(\ell^2\). These constructions are inverse up to isomorphism.

Fricke reversal interchanges \(A\) and \(B\) and preserves the middle curve. Therefore the noncuspidal points of \(X_0(\ell^2)^+\) correspond to isomorphism classes

\[
(E,\{A,B\}),\qquad A\ne B,\quad |A|=|B|=\ell.
\]

The construction uses quotients and dual isogenies and commutes with Galois. Supersingularity is preserved along these isogenies. This is the classical normalizer-of-split-Cartan interpretation: see Chen (1998), and Rebolledo and Wuthrich (2018, p. 412) for the unordered-pair moduli problem. The explicit constructions above give the required compatibility in every characteristic different from \(\ell\).

In particular, a Frobenius-fixed quotient point has a rational supersingular *middle* \(j\)-invariant. The endpoint invariants need not be rational. Fix such a middle invariant and choose a representative \(E/\mathbb F_p\). Put

\[
\Omega=\mathbb P(E[\ell])\simeq\mathbb P^1(\mathbb F_\ell),\qquad
U=\{\{A,B\}\subset\Omega:A\ne B\},\qquad
G=\operatorname{Aut}_{\overline{\mathbb F}_p}(E)/\{\pm1\}.
\]

The geometric coarse fibre over this middle invariant is \(U/G\). Frobenius normalizes \(G\) and induces its usual action on this orbit set.

**A twisted orbit count.** If a permutation \(F\) of a finite set \(U\) normalizes a finite group \(G\), then

\[
\#\operatorname{Fix}(F\mid U/G)
=\frac1{|G|}\sum_{g\in G}\#\operatorname{Fix}(gF\mid U).
\tag{1}
\]

Indeed, count pairs \((g,u)\) with \(gF(u)=u\). A non-stable \(G\)-orbit contributes none. In a stable orbit, each \(u\) has exactly \(|G_u|\) choices of \(g\), and the orbit contributes \(|G|\). This argument permits nontrivial stabilizers and is why it applies at the special invariants.

**The Frobenius permutations.** Let \(\pi\) be the \(p\)-power Frobenius of \(E/\mathbb F_p\). Since \(p\geq5\) and \(E\) is supersingular, its trace is zero, and

\[
\pi^2=[-p].
\]

For every automorphism \(g\) of \(E\), Frobenius conjugates \(g\) to \(g^{-1}\). At a generic invariant this is immediate because the automorphisms are \(\pm1\). At \(j=1728\), supersingularity requires \(p\equiv-1\pmod4\), and Frobenius inverts the fourth roots of unity. At \(j=0\), it requires \(p\equiv-1\pmod6\), and Frobenius inverts the sixth roots of unity. These assertions follow from the short equations and their scaling automorphisms; the supersingularity criteria are also stated in Mula et al. (2025, Section 5.1).

Consequently

\[
(g\pi)^2=[-p]
\]

for every lift of \(g\in G\). The endomorphism \(g\pi\) has degree \(p\) and trace zero. For example, its dual is \(-g\pi\), since multiplication of these two maps is \([p]\), so their sum, its trace, is zero. On the two-dimensional \(\mathbb F_\ell\)-space \(E[\ell]\), its matrix therefore has characteristic polynomial \(X^2+p\).

Because \(\ell\ne p\) is odd, that matrix is invertible, is not scalar, and has two distinct eigenvalues over the algebraic closure. The induced permutation of the \(\ell+1\) projective lines is an involution with

\[
f=\begin{cases}2,&(-p/\ell)=1,\\0,&(-p/\ell)=-1\end{cases}
\]

fixed lines. An unordered pair of distinct lines fixed by this involution is either a pair of fixed lines or one of its two-cycles. Hence, for every \(g\in G\),

\[
\#\operatorname{Fix}(g\pi\mid U)
=\binom f2+\frac{\ell+1-f}{2}
=\frac{\ell+1}{2}.
\]

By (1), each rational supersingular middle invariant contributes exactly \((\ell+1)/2\) rational coarse points, including when \(G\) has order two or three. Summing over the \(L(p)\) middle invariants proves the proposition.

## Computational cross-check of this description

`verify_middle_pairs.gp` constructs \(U/G\) explicitly from the order-\(\ell\) kernel polynomials at each rational supersingular middle invariant, applies coefficient Frobenius and counts the fixed coarse points. It does not call the first verifier's Vélu, dual-map or Fricke-reversal routines. It shares the Hasse-polynomial and prime-order kernel constructors. The coverage audit compares these middle-pair counts with the complete-path counts for every tested pair; the per-middle-invariant contribution is checked as well.

This proof explains the square-level formula directly. The broader arbitrary-level class-number formula and the question of all moonshine fixing groups are separate matters.

## References

Chen, I. (1998). The Jacobians of non-split Cartan modular curves. *Proceedings of the London Mathematical Society, 77*(1), 1–38. https://doi.org/10.1112/S0024611598000392. The published abstract explicitly records the isomorphism between the split Cartan normalizer curve and \(X_0^+(\ell^2)\); no internal theorem number from the inaccessible full article is asserted here.

Rebolledo, M., & Wuthrich, C. (2018). A moduli interpretation for the non-split Cartan modular curve. *Glasgow Mathematical Journal, 60*, 411–434. https://doi.org/10.1017/S0017089517000180. The ordered and unordered split Cartan descriptions were inspected directly on p. 412 of the published PDF.

Mula, M., Murru, N., & Pintore, F. (2025). On random sampling of supersingular elliptic curves. *Annali di Matematica Pura ed Applicata, 204*, 1293–1335. https://doi.org/10.1007/s10231-024-01528-x. Section 5.1 records the special supersingularity congruences; the ordinary Frobenius trace criterion and Hasse bound are recalled earlier in the paper.
