\\ Self-contained PARI/GP verification. Tested version and run results are recorded
\\ in verification_summary.json. Run: gp -fq -s 256000000 verify_nakaya.gp
\\ Set NK_MAXP and NK_LEVELS before read() to change the default survey.
X='X; T='T; q='q;

nk_assert(b, s) = if(!b, error(s));
nk_monic(f) = f/pollead(f);

nk_hfield(d) = qfbclassno(if(d%4==3,-d,-4*d));

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

nk_fixed(Q,M) = {
  nk_assert(Q>=5 && M%Q==0 && gcd(Q,M/Q)==1,"fixed-point hypotheses");
  my(Ds=if(Q%4==3,[-4*Q,-Q],[-4*Q]), r=0, fs=factor(M/Q)[,1]);
  for(i=1,#Ds,
    my(z=#nk_forms(Ds[i]));
    for(j=1,#fs,
      my(ell=fs[j], cnt=0);
      if(ell==2,
        cnt=if(Q%4==1,1,if(Ds[i]==-4*Q,2,1+kronecker(-Q,2))),
        for(a=0,ell-1,if((a*a+Q)%ell==0,cnt++))
      );
      z*=cnt;
    );
    r+=z;
  ); r
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

nk_rhs(N,p) = {
  my(L=poldegree(gcd(nk_ss(p),X^p-X)));
  if(N==2,return((2+(1-kronecker(-1,p))*(4+kronecker(-2,p)))*nk_hfield(p)/8+nk_hfield(2*p)/4));
  (1+kronecker(-p,N))*L/2+(2+(1-kronecker(-1,N*p))*(2+kronecker(-2,N*p)))*nk_hfield(N*p)/8
};

nk_run(maxp=300, levels=[3,5,7,11,13,17,19,23,29,31,41,47,59,71]) = {
  my(cases=0);
  fileclose(fileopen("verification.csv","w"));
  write("verification.csv","N,p,degree,linear,rhs,r_p,r_Np,fixed_count");
  for(i=1,#levels,
    my(N=levels[i],t0=getwalltime(),rel=nk_relation(N),cnt=0);
    fileclose(fileopen(Str("relation_",N,".gp"),"w"));
    fileclose(fileopen(Str("polynomials_",N,".gp"),"w"));
    write(Str("relation_",N,".gp"),Str("[",rel[1],",",rel[2],"]"));
    forprime(p=5,maxp,
      if(p==N,next);
      my(S=nk_polynomial(N,p,rel));
      my(L=poldegree(gcd(S,T^p-T)),rhs=nk_rhs(N,p));
      my(rp=nk_fixed(p,N*p),rnp=nk_fixed(N*p,N*p));
      nk_assert(L==rhs && 4*L==rp+rnp,Str("count mismatch N=",N," p=",p));
      nk_assert(lift(Mod(T,S)^(p*p)-Mod(T,S))==0,"root outside Fp^2");
      write("verification.csv",Str(N,",",p,",",poldegree(S),",",L,",",rhs,",",rp,",",rnp,",",(rp+rnp)/4));
      write(Str("polynomials_",N,".gp"),Str("[",p,",",lift(S),"]"));
      fileflush();
      cnt++; cases++;
    );
    print("level ",N,": ",cnt," cases passed in ",(getwalltime()-t0)/1000.," s");
  );
  fileflush(); print("ALL PASSED: ",cases," cases"); cases
};

if(type(NK_NO_RUN)!="t_INT" || NK_NO_RUN!=1,if(type(NK_MAXP)=="t_INT",nk_run(NK_MAXP,if(type(NK_LEVELS)=="t_VEC",NK_LEVELS,[3,5,7,11,13,17,19,23,29,31,41,47,59,71])),nk_run()));
