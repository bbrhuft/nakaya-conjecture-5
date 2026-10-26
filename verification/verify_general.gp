\\ Independent check of the general-level count (Theorem 1.1 + Section 4) at prime
\\ levels N, including levels OUTSIDE Nakaya's set, where X_0(N)^+ has positive genus.
\\
\\ Method (independent of Hauptmoduln, genus formulas and Ogg's fixed-point formula):
\\   * Supersingular j-invariants: roots of the classical supersingular polynomial in F_{p^2}.
\\   * Supersingular points of X_0(N): for each supersingular j, the N+1 cyclic N-subgroups C,
\\     recorded as directed edges (j, j') with j' = j(E/C), from the roots of Phi_N(j, Y).
\\   * Restriction p = 1 (mod 12): then j = 0, 1728 are ordinary, so Aut(E) = {+-1} acts
\\     trivially on subgroups and the coarse points over j are exactly the N+1 subgroups.
\\   * A root j' of multiplicity m gives m points of X_0(N) over (j, j'). w_N sends the
\\     class (j, j') to (j', j) and Frobenius sends it to (j^p, j'^p). A w_N-orbit of classes
\\     not preserved by Frobenius contains no rational point of X_0(N)^+.
\\   * Frobenius-stable classes with m > 1 (for instance a subgroup C and its conjugate C^p
\\     with the same j, j' in F_p) are resolved by the branch tangents of the plane curve
\\     Phi_N(x, y) = 0 at (j, j'); see vg_slopes. If the tangent cone has repeated slopes,
\\     the prime is reported and skipped, never guessed.
\\   * lambda = number of points of X_0(N)^+ fixed by Frobenius.
\\ The count lambda is compared with
\\   (a) Nakaya's class-number formula (1.3) and
\\   (b) (r_p(Np) + r_Np(Np))/4 from the class-number evaluation (4.2)-(4.3).
\\ Run:  gp -fq -s 512000000 verify_general.gp
\\ Options (set before read): VG_LEVELS, VG_MAXP.

X='X; Y='Y; VG_RESOLVED=0;

vg_ss(p) = {
  my(n=p\12,e=(1-kronecker(-1,p))/2,d=(1-kronecker(-3,p))/2);
  my(J=sum(k=0,n,binomial(2*n+e,2*k+e)*binomial(2*n-2*k,n-k)*(-432)^(n-k)*(X-1728)^k));
  X^d*(X-1728)^e*J
};

\\ key of a finite-field element: its coordinate vector
vg_key(z) = my(P=z.pol); [polcoef(P,0), polcoef(P,1)];

vg_roots(f) = {   \\ roots with multiplicities over the field of f's coefficients
  my(F=factor(f), R=List(), ok=1);
  for(i=1,#F~,
    if(poldegree(F[i,1])!=1, ok=0; next);
    listput(R,[-polcoef(F[i,1],0)/polcoef(F[i,1],1), F[i,2]]));
  [Vec(R), ok]
};

vg_hfield(d) = qfbclassno(if(d%4==3,-d,-4*d));

vg_count(N,p,PHI) = {
  my(w=ffgen([p,2],'w), o=w^0, ssr=vg_roots(subst(vg_ss(p),X,X*o)), S=ssr[1]);
  if(!ssr[2], error("supersingular j not all in F_p^2"));
  my(js=vector(#S,i,S[i][1]), Lp=sum(i=1,#js,js[i]^p==js[i]));
  my(E=Map(), nedges=0, PHIp=PHI*Mod(1,p));
  for(i=1,#js,
    my(j=js[i], r=vg_roots(substvec(PHIp,['x,'y],[j,Y])));
    if(!r[2], error("non-split Phi_N(j,Y)"));
    for(k=1,#r[1], nedges+=r[1][k][2];
      mapput(E,[vg_key(j),vg_key(r[1][k][1])],[j,r[1][k][1],r[1][k][2]])));
  if(nedges!=#js*(N+1), error("edge count"));
  \\ X_0(N) is the normalization of the plane curve Phi_N(x,y) = 0, and j : X_0(N) -> X(1)
  \\ is etale over j != 0, 1728. So the m points over an edge class (j,j') are the m smooth
  \\ branches through (j,j'), each with x as local parameter: their tangent slopes
  \\ s = dy/dx are finite, nonzero, and are the roots of the degree-m tangent cone.
  \\ Frobenius sends a branch of slope s to the branch of slope s^p at (j^p,j'^p);
  \\ w_N sends it to the branch of slope 1/s at (j',j). A point of X_0(N)^+ is rational
  \\ iff Frobenius fixes it or sends it to its w_N-image. Tangent cones with repeated
  \\ slopes (tacnodes) cannot be resolved this way and are flagged.
  my(seen=Map(), lam=0, amb=0, M=Mat(E));
  for(i=1,#M~,
    my(e=M[i,2], a=e[1], b=e[2], m=e[3], k1=[vg_key(a),vg_key(b)], k2=[vg_key(b),vg_key(a)]);
    if(mapisdefined(seen,k1), next);
    mapput(seen,k1,1); mapput(seen,k2,1);
    my(fk=[vg_key(a^p),vg_key(b^p)]);
    if(fk!=k1 && fk!=k2, next);
    if(m==1, lam++; next);
    my(S=vg_slopes(PHIp,a,b,m,o));
    if(S==0, amb++; next);
    VG_RESOLVED++;
    if(k1!=k2,
      if(fk==k1, lam+=sum(t=1,#S,S[t]^p==S[t]), lam+=sum(t=1,#S,S[t]^p==1/S[t])),
      \\ loop j = j': points of X_0(N)^+ are the orbits {s, 1/s} of w_N on branches
      my(done=vector(#S), cnt=0);
      for(t=1,#S, if(done[t], next);
        my(u=1/S[t], q=t); for(r=1,#S, if(S[r]==u, q=r)); done[t]=1; done[q]=1;
        my(sp=S[t]^p); if(sp==S[t] || sp==u, cnt++));
      lam+=cnt));
  [amb==0, amb, Lp, lam]
};

\\ tangent slopes at the m-fold point (a,b) of Phi_N = 0; returns 0 if not m distinct roots
vg_slopes(PHIp,a,b,m,o) = {
  my(P=substvec(PHIp,['x,'y],['U+a,'V+b]), T=0);
  for(k=0,m, T+=polcoef(polcoef(P,k,'U),m-k,'V)*'s^(m-k));
  for(d=0,m-1, for(k=0,d, if(polcoef(polcoef(P,k,'U),d-k,'V)!=0, return(0))));
  T=T*o; if(poldegree(T,'s)!=m, return(0));
  my(r=vg_roots(subst(T,'s,'s)));
  if(!r[2] || #r[1]!=m, return(0));
  my(S=vector(m,i,r[1][i][1]));
  if(#Set(apply(vg_key,S))<m || vecsum(apply(z->z==0,S)), return(0));
  S
};

vg_V(d) = if(d%4==1, qfbclassno(-4*d), qfbclassno(-4*d)+qfbclassno(-d));
vg_rhs(N,p,Lp) = (1+kronecker(-p,N))*Lp/2 + (2+(1-kronecker(-1,N*p))*(2+kronecker(-2,N*p)))*vg_hfield(N*p)/8;

vg_run(levels, maxp) = {
  my(tot=0, skipped=List(), bad=List());
  for(i=1,#levels,
    my(N=levels[i], PHI=polmodular(N), t0=getwalltime(), n=0);
    forprime(p=13,maxp,
      if(p%12!=1 || p==N, next);
      my(c=vg_count(N,p,PHI));
      if(!c[1], listput(skipped,[N,p]); next);
      my(rhs=vg_rhs(N,p,c[3]), fp=((1+kronecker(-p,N))*vg_V(p)+vg_V(N*p))/4);
      if(c[3]!=vg_V(p)/2, error("Deuring check failed"));
      if(c[4]!=rhs || c[4]!=fp, listput(bad,[N,p,c[4],rhs,fp]));
      n++; tot++);
    print("N=",N,": ",n," primes checked in ",(getwalltime()-t0)/1000.," s"));
  print("skipped (degenerate tangent cone at a Frobenius-stable multiple point): ",Vec(skipped));
  print("Frobenius-stable multi-branch points resolved by tangent slopes: ",VG_RESOLVED);
  if(#bad, print("MISMATCHES: ",Vec(bad)), print("ALL AGREE: ",tot," cases"));
  [tot, Vec(skipped), Vec(bad)]
};

{
if(type(VG_NO_RUN)!="t_INT" || VG_NO_RUN!=1,
  vg_run(if(type(VG_LEVELS)=="t_VEC",VG_LEVELS,[11,13,37,43,53,61,67,73,79,83,89,97]),
         if(type(VG_MAXP)=="t_INT",VG_MAXP,600)));
}
