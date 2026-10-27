\\ Direct count of ALL supersingular points D on X_0(N)^+ from the modular polynomial
\\ Phi_N, with no Hauptmodul, relation, genus formula or class number.
\\ Restricted to p = 1 (mod 12), so that j = 0, 1728 are ordinary.
\\   * Points of X_0(N) over (j, j') = roots j' of Phi_N(j, Y) with multiplicity m.
\\   * A w_N-orbit {(j,j'), (j',j)} with j != j' contains m points of X_0(N)^+.
\\   * A loop (j, j) of multiplicity m: points of X_0(N)^+ are the orbits s <-> 1/s of
\\     w_N on the m branch slopes of Phi_N = 0 at (j, j); pairs with a repeated slope are
\\     skipped and reported.
\\ Checks:
\\   (a) N in Nakaya's set: D = right-hand side of (C6).
\\   (b) N prime outside the set: D = (C6) - (1 - (-N/p)) g(X_0(N)^+).
\\   (c) Level 3 fixed points: r_3(3p) = 2(1 + (-3/p)) via Atkin-Lehner traces.
\\ Run from this directory:  gp -fq -s 1000000000 c6_direct.gp
\\ Needs verify_general.gp in this directory (set C6_GENERAL to override).

VG_NO_RUN=1;
read(if(type(C6_GENERAL)=="t_STR", C6_GENERAL, "verify_general.gp"));

vgD(N,p,PHI) = {
  my(w=ffgen([p,2],'w), o=w^0, S=vg_roots(subst(vg_ss(p),X,X*o))[1], js=vector(#S,i,S[i][1]));
  my(E=Map(), PHIp=PHI*Mod(1,p));
  for(i=1,#js, my(j=js[i], r=vg_roots(substvec(PHIp,['x,'y],[j,Y])));
    for(k=1,#r[1], mapput(E,[vg_key(j),vg_key(r[1][k][1])],[j,r[1][k][1],r[1][k][2]])));
  my(seen=Map(), D=0, M=Mat(E));
  for(i=1,#M~,
    my(e=M[i,2], a=e[1], b=e[2], m=e[3], k1=[vg_key(a),vg_key(b)], k2=[vg_key(b),vg_key(a)]);
    if(mapisdefined(seen,k1), next); mapput(seen,k1,1); mapput(seen,k2,1);
    if(k1!=k2, D+=m; next);
    if(m==1, D++; next);
    my(Sl=vg_slopes(PHIp,a,b,m,o)); if(Sl==0, return(-1));
    D+=(m+sum(t=1,#Sl,Sl[t]^2==1))/2);
  D
};
dN(N) = if(N==3,1,N\12+[0,0,0,0,1,0,1,0,0,0,2][N%12]);
c6(N,p) = (N+1)*(p-1)/24 + (1+kronecker(-1,N))*(1-kronecker(-1,p))/8 \
        + (1+kronecker(-3,N))*(1-kronecker(-3,p))/6 + (1-kronecker(-N,p))*dN(N)/2;
gplus(N) = {my(mf=mfinit([N,2],1), a=mfatkininit(mf,N)); (mfdim(mf)+trace(a[2])/a[3])/2};

c6_survey(levels, maxp, general) = {
  my(tot=0, skip=0, bad=List());
  foreach(levels, N, my(PHI=polmodular(N), gX=if(general, gplus(N), 0));
    forprime(p=13, maxp, if(p%12!=1 || p==N, next);
      my(D=vgD(N,p,PHI)); if(D<0, skip++; next);
      my(pred=c6(N,p)-(1-kronecker(-N,p))*gX);
      if(D!=pred, listput(bad,[N,p,D,pred])); tot++));
  [tot, skip, Vec(bad)]
};

{
my(a=c6_survey([11,13,17,19,23,29,31], 700, 0));
print("(a) Nakaya levels 11-31, p <= 700: ",a[1]," pairs, skipped ",a[2],", mismatches ",a[3]);
my(b=c6_survey([37,43,53,61,67,73], 600, 1));
print("(b) levels 37-73 (genus of X_0(N)^+ = ",apply(gplus,[37,43,53,61,67,73]),"), p <= 600: ",
      b[1]," pairs, skipped ",b[2],", mismatches ",b[3]);
my(bad=List());
foreach([5,7,11,13,17,19,23,29,31,37,41,43],p,
  my(mf=mfinit([3*p,2],1), at=mfatkininit(mf,3), r=2-2*trace(at[2])/at[3]);
  if(r!=2*(1+kronecker(-3,p)), listput(bad,[p,r])));
print("(c) level 3, r_3(3p) = 2(1 + (-3/p)) at 12 primes 5..43: mismatches ",Vec(bad));
}
