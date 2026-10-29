\\ PINNED: PARI/GP 2.15.4. Run from package root: gp -fq -s 768000000 code/verify_c4.gp
\\ The nk_* routines below adapt the inspected handover's verify_nakaya.gp.
\\ This single file reconstructs relations from modular forms and q-expansions.
\\ Results are recorded in results/summary.csv, run.log, and per-level files.
\\ C4_NO_RUN=1 before read() loads functions; run from package root.
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
  my(P=6*N+80,h=nk_haupt(N,P),t=h[1]);
  my(j=ellj(q+O(q^(P+N+10))), jN=subst(j,q,q^N));
  my(a=nk_faber(j+jN,t,N), b=nk_faber(j*jN,t,N+1));
  nk_assert(valuation(j+jN-subst(a,T,t))>=5*N+40,"sum identity failed");
  nk_assert(valuation(j*jN-subst(b,T,t))>=5*N+40,"product identity failed");
  [a,b,h[2],h[3],valuation(j+jN-subst(a,T,t)),valuation(j*jN-subst(b,T,t))]
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


\\ Fresh multiplicity audit; nk_* reconstruction adapts Jordan's supplied code.
c4_radQ(f)=nk_monic(f/gcd(f,deriv(f)));
c4_write(file,s)=write(Str("results/",file),s);
c4_order(f,g)={my(v=0);while(poldegree(f)>=poldegree(g) && f%g==0,f=f/g;v++);v};
c4_powpart(F,G)={my(U=1);for(i=1,matsize(F)[1],if(poldegree(gcd(F[i,1],G))>0,U*=F[i,1]^F[i,2]));U};
c4_rootQ(f,k)={my(F=factor(f),r=1);for(i=1,matsize(F)[1],nk_assert(F[i,2]%k==0,"not a perfect polynomial power");r*=F[i,1]^(F[i,2]/k));r};
c4_data(N,r)={
 my(a=r[1],b=r[2],c=1728^2-1728*a+b,D=a*a-4*b,FD=factor(D));
 my(U0=c4_powpart(factor(b),gcd(b,a)),U4=c4_powpart(factor(c),gcd(c,a-3456)));
 my(A=c4_rootQ(b/U0,3),B=c4_rootQ(c/U4,2),E=1,H=1);
 for(i=1,matsize(FD)[1],E*=FD[i,1]^(FD[i,2]%2);H*=FD[i,1]^(FD[i,2]\2));
 nk_assert(b==U0*A^3 && c==U4*B^2 && D==E*H^2,"factor reconstruction");
 nk_assert(poldegree(U0)==1+kronecker(-3,N) && poldegree(U4)==if(N==2,1,1+kronecker(-1,N)),"unramified degrees");
 c4_write(Str("integer_factors_",N,".txt"),Str("N=",N,"\na=",a,"\nb=",b,"\nfactor b=",factor(b),"\nfactor R1728=",factor(c),"\nfactor disc_X=",FD,"\nU0=",U0,"\nU1728=",U4,"\nA=",A,"\nB=",B,"\nE=",E,"\nH=",H,"\ndisc E=",factor(poldisc(E))));
 c4_write(Str("data_",N,".gp"),[A,B,E,H,U0,U4]);
 print("N=",N," A=",A,"\nB=",B,"\nE=",E);
 c4_write("levels.csv",Str(N,",",poldegree(A),",",poldegree(B),",",poldegree(E),",",poldegree(U0),",",poldegree(U4),",",r[5],",",r[6]));
 [A,B,E,H,U0,U4]
};
c4_C(N,p,d)=if(N==2,T^((1-kronecker(-1,p))/2)*(T-256)^((1-kronecker(-2,p))/2),d[3]^((1-kronecker(-N,p))/2));
c4_degree(N,p)={
 if(N==2,return((p-1)/8+3*(1-kronecker(-1,p))/8+(1-kronecker(-2,p))/4));
 (N+1)*(p-1)/24+(1+kronecker(-1,N))*(1-kronecker(-1,p))/8+(1+kronecker(-3,N))*(1-kronecker(-3,p))/6+(1-kronecker(-N,p))*if(N==3,1,poldegree(nk_ss(N)))/2
};
c4_legendre(p)={
 my(z='z,h=(p-1)/2,H=Mod(1,p)*sum(k=0,h,binomial(h,k)^2*z^k));
 my(R=polresultant(H,z^2*(1-z)^2*X-256*(1-z+z^2)^3,z));
 subst(nk_rad(subst(R,X,T),p),T,X)
};
\\ disc_Y(disc_X) is identically zero; use disc_Y(rad_Q(disc_X)).
c4_cert(d)={my(A=d[1],B=d[2],E=d[3],G=c4_radQ(E*d[4]));[poldisc(A),poldisc(B),poldisc(E),polresultant(A,B),polresultant(A,E),polresultant(B,E),poldisc(G)]};
c4_flagtext(v)={my(s="");for(i=1,#v,s=Str(s,if(i>1,";",""),v[i]));s};
c4_flags(p,cert)={my(labels=["disc_A","disc_B","disc_E","Res_AB","Res_AE","Res_BE","disc_rad_D"],v=List());for(i=1,#cert,if(cert[i]%p==0,listput(v,labels[i])));Vec(v)};
c4_collisions(N,p,d,flags)={
 my(v=Mod(1,p)*[d[1],d[2],d[3],c4_radQ(d[3]*d[4])]);
 c4_write("exceptional_details.txt",Str("N=",N," p=",p," flags=",flags,"\ngcd(A,A')=",lift(gcd(v[1],deriv(v[1]))),"\ngcd(B,B')=",lift(gcd(v[2],deriv(v[2]))),"\ngcd(E,E')=",lift(gcd(v[3],deriv(v[3]))),"\ngcd(A,B)=",lift(gcd(v[1],v[2])),"\ngcd(A,E)=",lift(gcd(v[1],v[3])),"\ngcd(B,E)=",lift(gcd(v[2],v[3])),"\ngcd(rad_Q(D),derivative)=",lift(gcd(v[4],deriv(v[4])))));
};
c4_one(N,p,r,d,cert)={
 my(t0=getwalltime(),ss=nk_ss(p),V=polresultant(ss,X^2-Mod(1,p)*r[1]*X+Mod(1,p)*r[2],X));
 my(S=nk_rad(V,p),F=factor(V),A=Mod(1,p)*d[1],B=Mod(1,p)*d[2],C=Mod(1,p)*c4_C(N,p,d));
 my(delta=(1-kronecker(-3,p))/2,eps=(1-kronecker(-1,p))/2,status="PASS",first="",Fp=F);
 my(L=C*V,R=A^(2*delta)*B^eps*S^2,productrad=Mod(1,p));
 for(i=1,matsize(F)[1],my(f=F[i,1],actual=F[i,2],pred=2+2*delta*c4_order(A,f)+eps*c4_order(B,f)-c4_order(C,f));Fp[i,2]=pred;productrad*=f;if(pred!=actual && status=="PASS",status="FAIL";first=Str(lift(f)," predicted=",pred," actual=",actual)));
 nk_assert(productrad==S,"radical/factorization disagreement");
 if(L!=R && status=="PASS",status="FAIL";first="support or leading coefficient disagreement");
 nk_assert(poldegree(V)==(N+1)*poldegree(ss) && pollead(V)==1,"degree or leading coefficient V");
 my(degok=poldegree(S)==c4_degree(N,p),splitok=lift(Mod(T,S)^(p*p)-Mod(T,S))==0,flags=c4_flags(p,cert));
 if(!degok || !splitok,status="FAIL";first=Str(first," degree_ok=",degok," split_Fp2=",splitok));
 c4_write("pairs.csv",Str(N,",",p,",",status,",",poldegree(V),",",poldegree(S),",",c4_degree(N,p),",",matsize(F)[1],",",vecmax(F[,2]),",",#flags,",",getwalltime()-t0));
 c4_write(Str("factors_",N,".txt"),Str("N=",N," p=",p," ",status,"\nactual=",lift(F),"\npredicted=",lift(Fp),"\nfirst_mismatch=",first));
 c4_write(Str("radicals_",N,".gp"),[p,lift(S)]);
 if(#flags,c4_write("exceptions.csv",Str(N,",",p,",",status,",",c4_flagtext(flags)));c4_collisions(N,p,d,flags));
 if(status!="PASS",print("FAIL N=",N," p=",p," ",first));[status=="PASS",#flags>0]
};
c4_explore(N,p,r,d)={
 my(ss=if(p<5,Mod(1,p)*X,nk_ss(p)),V=polresultant(ss,X^2-Mod(1,p)*r[1]*X+Mod(1,p)*r[2],X),S=nk_rad(V,p),F=factor(V));
 c4_write("outside_scope.txt",Str("OUTSIDE CONJECTURE: N=",N," p=",p,"\nss=",lift(ss),"\nfactor V=",lift(F),"\nrad V=",lift(S),"\ndegree rad=",poldegree(S)));
 my(naive="NOT_DEFINED");
 if(p==N && p>=5,my(delta=(1-kronecker(-3,p))/2,eps=(1-kronecker(-1,p))/2,A=Mod(1,p)*d[1],B=Mod(1,p)*d[2],E=Mod(1,p)*d[3]);naive=if(E*V^2==A^(4*delta)*B^(2*eps)*S^4,"PASS_SQUARED_FORM","FAIL_SQUARED_FORM");c4_write("outside_scope.txt",Str("Formal squared identity using mu=1/2: ",naive)));
 c4_write("outside_scope.csv",Str(N,",",p,",",poldegree(V),",",poldegree(S),",",vecmax(F[,2]),",",naive));
};
c4_main()={
 my(levels=if(type(LEVELS)=="t_VEC",LEVELS,[2,3,5,7,11,13,17,19,23,29,31,41,47,59,71]),pmax=if(type(P_MAX)=="t_INT",P_MAX,400),t0=getwalltime(),cnt=0,bad=0,exc=0);
 nk_assert(version()==[2,15,4],"Pinned to PARI/GP 2.15.4; other versions are not certified by this script");
 print("PARI ",version(),"; P_MAX=",pmax,"; seed=20261028; pinned tested version 2.15.4");setrand(20261028);
 my(files=["pairs.csv","exceptions.csv","exceptional_details.txt","levels.csv","outside_scope.txt","outside_scope.csv","ordinary_ss.csv","summary.csv","certificates.txt"]);
 for(i=1,#files,fileclose(fileopen(Str("results/",files[i]),"w")));
 c4_write("pairs.csv","N,p,status,degree_V,degree_rad,Jordan_degree,irreducible_factors,max_multiplicity,exception_flags,milliseconds");
 c4_write("levels.csv","N,degree_A,degree_B,degree_E,degree_U0,degree_U1728,q_sum_O,q_product_O");
 c4_write("exceptions.csv","N,p,status,flags");c4_write("ordinary_ss.csv","p,degree,Legendre_equal");
 c4_write("outside_scope.csv","N,p,degree_V,degree_rad,max_multiplicity,formal_diagonal_check");
 c4_write("summary.csv","N,tested,failed,exceptional,milliseconds");
 forprime(p=5,pmax,nk_assert(c4_legendre(p)==nk_ss(p),Str("ordinary ss mismatch at ",p));c4_write("ordinary_ss.csv",Str(p,",",poldegree(nk_ss(p)),",PASS")));
 print("ordinary ss polynomials cross-checked against Legendre Hasse polynomials");
 for(i=1,#levels,
  my(N=levels[i],tN=getwalltime(),rel=nk_relation(N));
  my(outfiles=[Str("relation_",N,".gp"),Str("integer_factors_",N,".txt"),Str("data_",N,".gp"),Str("factors_",N,".txt"),Str("radicals_",N,".gp")]);
  for(j=1,#outfiles,fileclose(fileopen(Str("results/",outfiles[j]),"w")));c4_write(Str("relation_",N,".gp"),rel);
  my(d=c4_data(N,rel),cert=c4_cert(d),n=0,b=0,e=0);
  c4_write("certificates.txt",Str("N=",N,"\n[disc A,disc B,disc E,Res(A,B),Res(A,E),Res(B,E),disc rad(D)]=",cert));
  if(N==2,nk_assert(d[1]==T+144 && d[2]==T-648 && d[3]==T*(T-256),"Nakaya N2 constants"));
  if(N==3,nk_assert(d[1]==T+192 && d[2]==T^2-576*T-1728 && d[3]==T*(T-108),"Nakaya N3 constants"));
  if(N==5,nk_assert(d[1]==T^2+216*T+144 && d[2]==T^2-540*T-6480 && d[3]==T^2-44*T-16,"Nakaya N5 constants"));
  if(N==7,nk_assert(d[1]==T^2+224*T+448 && d[2]==T^4-528*T^3-9024*T^2-5120*T-1728 && d[3]==(T+1)*(T-27),"Nakaya N7 constants"));
  forprime(p=5,pmax,if(p==N,next);my(res=c4_one(N,p,rel,d,cert));n++;b+=!res[1];e+=res[2]);
  c4_explore(N,2,rel,d);c4_explore(N,3,rel,d);if(N>=5,c4_explore(N,N,rel,d));cnt+=n;bad+=b;exc+=e;
  c4_write("summary.csv",Str(N,",",n,",",b,",",e,",",getwalltime()-tN));
  print("N=",N," tested=",n," failed=",b," exceptional=",e," elapsed_s=",(getwalltime()-tN)/1000.);fileflush();
 );
 print("COMPLETE tested=",cnt," failed=",bad," exceptional_pairs=",exc," elapsed_s=",(getwalltime()-t0)/1000.);fileflush();if(bad,quit(1));
};
if(type(C4_NO_RUN)!="t_INT" || C4_NO_RUN!=1,iferr(c4_main(),E,print("ERROR: ",E);quit(1));quit(0));
