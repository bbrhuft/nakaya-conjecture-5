\\ PARI/GP >= 2.15. Run from package root: gp -fq -s 768000000 code/verify_conjecture6.gp
\\ The nk_* routines below adapt the inspected handover's verify_nakaya.gp.
\\ This single file reconstructs relations from modular forms and q-expansions.
\\ Results and runtime are recorded in results/summary.json and environment.txt.
\\ C6_NO_RUN=1 before read() loads the functions without running the survey.
X='X; T='T; q='q;

nk_assert(b, s) = if(!b, error(s));
nk_monic(f) = f/pollead(f);


\\ Explicit enumeration, independent of PARI's class-number routine.
nk_forms(D) = {
  my(v=List(), lim=sqrtint((-D)\3));
  for(a=1,lim, for(b=-a,a,
    if((b*b-D)%(4*a), next);
    my(c=(b*b-D)/(4*a));
    if(a>c || gcd(gcd(a,b),c)!=1, next);
    if((abs(b)==a || a==c) && b<0, next);
    listput(v,[a,b,c]);
  )); Vec(v)
};

\\ Construct the Hauptmodul from a certified modular-form space, rather than
\\ importing a table of moonshine coefficients. eta-products have no zeros in H.
nk_haupt(N,P) = {
  my(k=24/gcd(N+1,24)); if(k%2,k*=2);
  my(m=k*(N+1)/24, c0=if(N==2,104,if(N==3,42,if(N==5,16,if(N==7,9,0)))));
  my(mf=mfinit([N,k],4), d=mfdim(mf), at=mfatkininit(mf,N));
  nk_assert(at[3]==1,"nonrational Atkin-Lehner normalisation");
  my(K=matker(at[2]-(-1)^(k/2)*matid(d)));
  my(E=mfcoefs(mf,m)*K, rhs=vector(m+1,i,if(i==m,1,if(i==m+1,c0-k,0)))~);
  nk_assert(matsize(E)==[m+1,m+1],"unexpected Hauptmodul dimension");
  my(v=K*matsolve(E,rhs), f=mflinear(mfbasis(mf),v));
  my(prec=P+m+6, den=q^m*eta(q+O(q^prec))^k*eta(q^N+O(q^prec))^k);
  my(t=Ser(mfcoefs(f,prec),q)/den);
  nk_assert(valuation(t)==-1 && polcoef(t,-1)==1 && polcoef(t,0)==c0,"Hauptmodul normalisation");
  for(i=-1,P,nk_assert(denominator(polcoef(t,i))==1,"nonintegral Hauptmodul coefficient"));
  [t,k,m,v]
};

nk_faber(s,t,d) = {
  my(a=0,z);
  forstep(i=d,0,-1,z=polcoef(s,-i);a+=z*T^i;s-=z*t^i);
  nk_assert(valuation(s)>0,"failed pole-part elimination");
  a
};

nk_relation(N) = {
  my(P=3*N+30,h=nk_haupt(N,P),t=h[1]);
  my(j=ellj(q+O(q^(P+N+10))), jN=subst(j,q,q^N));
  my(a=nk_faber(j+jN,t,N), b=nk_faber(j*jN,t,N+1));
  nk_assert(valuation(j+jN-subst(a,T,t))>=N+5,"sum identity failed");
  nk_assert(valuation(j*jN-subst(b,T,t))>=N+5,"product identity failed");
  [a,b,h[2],h[3]]
};

nk_ss(p) = {
  my(n=p\12,e=(1-kronecker(-1,p))/2,delta=(1-kronecker(-3,p))/2);
  my(J=sum(k=0,n,binomial(2*n+e,2*k+e)*binomial(2*n-2*k,n-k)*(-432)^(n-k)*(X-1728)^k));
  nk_monic(Mod(1,p)*X^delta*(X-1728)^e*J)
};

\\ Radical in characteristic p, including inseparable multiplicities.
nk_rad(f,p) = {
  f=nk_monic(f); if(poldegree(f)<=0,return(f));
  my(df=deriv(f));
  if(df==0,
    my(h=sum(i=0,poldegree(f)\p,polcoef(f,p*i)*T^i));
    return(nk_rad(h,p));
  );
  my(g=gcd(f,df)); if(poldegree(g)<=0,return(f));
  my(w=f/g,z=nk_rad(g,p)); nk_monic(w*z/gcd(w,z))
};

nk_polynomial(N,p,rel) = {
  my(ss=nk_ss(p),r=polresultant(ss,X^2-Mod(1,p)*rel[1]*X+Mod(1,p)*rel[2],X));
  nk_rad(r,p)
};


setrand(20261027);
c6_levels=[3,5,7,11,13,17,19,23,29,31,41,47,59,71];
c6_extra=[307,401,503,1009];
c6_dN(N)=if(N==3,1,poldegree(nk_ss(N)));
c6_rhs(N,p)=(N+1)*(p-1)/24+(1+kronecker(-1,N))*(1-kronecker(-1,p))/8+(1+kronecker(-3,N))*(1-kronecker(-3,p))/6+(1-kronecker(-N,p))*c6_dN(N)/2;
c6_gprime(N)=1+(N+1)/12-(1+kronecker(-1,N))/4-(1+kronecker(-3,N))/3-1;
c6_genus(N,p)=(N+1)*(p+1)/12-1-(1+kronecker(-1,N))*(1+kronecker(-1,p))/4-(1+kronecker(-3,N))*(1+kronecker(-3,p))/3;
\\ IJK Proposition 2.1: at Q=3 the second term is exceptional, NOT h(-3).
c6_basefixed(N)=#nk_forms(-4*N)+if(N>3 && N%4==3,#nk_forms(-N),0)+if(N==3,1,0);
c6_fixed(N,p)=c6_basefixed(N)*(1+kronecker(-N,p));
c6_degree_genus(N,p)=(c6_genus(N,p)+3)/2-c6_fixed(N,p)/4;

\\ Independent ordinary supersingular polynomial from the Legendre Hasse polynomial.
c6_legendre_ss(p)={
  my(z='z,h=(p-1)/2,H=Mod(1,p)*sum(k=0,h,binomial(h,k)^2*z^k));
  my(R=polresultant(H,z^2*(1-z)^2*X-256*(1-z+z^2)^3,z));
  subst(nk_rad(subst(R,X,T),p),T,X)
};
c6_one(N,p,rel,stage)={
  my(t0=getwalltime(),S=nk_polynomial(N,p,rel),D=poldegree(S));
  my(rhs=c6_rhs(N,p),gg=c6_degree_genus(N,p),linear=poldegree(gcd(S,T^p-T)));
  nk_assert(D==rhs && D==gg,Str("degree mismatch at ",N,",",p));
  nk_assert(poldegree(gcd(S,deriv(S)))==0,"not squarefree");
  nk_assert(lift(Mod(T,S)^(p*p)-Mod(T,S))==0,"root outside Fp^2");
  write("results/degrees.csv",Str(stage,",",N,",",p,",",D,",",rhs,",",gg,",",c6_genus(N,p),",",c6_fixed(N,p),",",linear,",",getwalltime()-t0));
  write(Str("results/polynomials_",N,".gp"),[p,lift(S)]);
  if((N==3 && (p==5 || p==7 || p==11 || p==13)) || (N==11 && p==13),
    write("results/examples.txt",Str("N=",N," p=",p,"\nss_p(j)=",lift(nk_ss(p)),"\nS(T)=",lift(S),"\nfactor=",lift(factor(S)),"\ngC=",c6_genus(N,p)," rN=",c6_fixed(N,p)," genusA=",D-1,"\n"));
  );
};
c6_main()={
  my(P=List(),cnt=0,t0=getwalltime());
  my(files=["environment.txt","degrees.csv","ordinary_ss.csv","levels.csv","examples.txt"]);
  for(i=1,#files,fileclose(fileopen(Str("results/",files[i]),"w")));
  forprime(p=5,300,listput(P,p));for(i=1,#c6_extra,listput(P,c6_extra[i]));
  write("results/environment.txt",Str("PARI ",version(),"; seed 20261027"));
  write("results/degrees.csv","stage,N,p,direct_degree,conjecture6,genus_degree,gC,rN,linear,milliseconds");
  write("results/ordinary_ss.csv","p,degree,legendre_equal");
  write("results/levels.csv","N,gN,dN,Fricke_fixed,gplus");
  for(i=1,#P,
    my(p=P[i],S=c6_legendre_ss(p));
    nk_assert(S==nk_ss(p),Str("ordinary supersingular polynomial mismatch at ",p));
    write("results/ordinary_ss.csv",Str(p,",",poldegree(S),",1"));
  );
  for(i=1,#c6_levels,
    my(N=c6_levels[i],rel=nk_relation(N),r=c6_basefixed(N),g=c6_gprime(N));
    fileclose(fileopen(Str("results/relation_",N,".gp"),"w"));
    fileclose(fileopen(Str("results/polynomials_",N,".gp"),"w"));
    nk_assert(c6_dN(N)==g+1 && r==2*g+2,"base-level identity failed");
    write("results/levels.csv",Str(N,",",g,",",c6_dN(N),",",r,",",(2*g+2-r)/4));
    write(Str("results/relation_",N,".gp"),rel);
    for(j=1,#P,if(P[j]!=N,c6_one(N,P[j],rel,if(P[j]<=300,"baseline","heldout"));cnt++));
    print("level ",N," done; cumulative ",cnt);fileflush();
  );
  print("ALL PASSED: ",cnt," direct degrees; ",#P," independent ordinary polynomials; elapsed ",(getwalltime()-t0)/1000.," s");fileflush();
};
if(type(C6_NO_RUN)!="t_INT" || C6_NO_RUN!=1,iferr(c6_main(),E,print("FAILED: ",E);quit(1));quit(0));
