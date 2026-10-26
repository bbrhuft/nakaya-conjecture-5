\\ Direct supersingular coarse-point count on X_0(ell^2)/<w_(ell^2)>.
\\ PARI/GP >= 2.15; no imports or external data. No class numbers,
\\ modular-form traces, genera, or characteristic-zero fixed counts are used.
\\ Set SD_NO_RUN=1 before read(...) to load functions only.

sd_assert(b,msg)={if(!b,error(msg))};
sd_monic(f)=f/pollead(f);
sd_frob(f,p)=sum(i=0,poldegree(f),polcoef(f,i)^p*'x^i);
\\ Polynomial of the subgroup obtained by x-coordinate scaling by c.
sd_scale(f,c)=c^poldegree(f)*subst(f,'x,'x/c);
sd_canon(f,U)=Set(vector(#U,i,sd_scale(f,U[i])))[1];

sd_ss(p,a)={
  my(n=(p-1)/2,H=sum(i=0,n,Mod(binomial(n,i)^2,p)*'x^i),r,J);
  r=polrootsmod(H,a);
  sd_assert(#r==n,"Legendre polynomial did not split completely");
  J=Set(vector(#r,i,256*(r[i]^2-r[i]+1)^3/(r[i]^2*(r[i]-1)^2)));
  sd_assert(#J==p\12+if(p%12==1,0,if(p%12==11,2,1)),"Wrong supersingular j count");
  J
};

sd_curve(j)={
  my(k);
  if(j==0,return(ellinit([0*j,1+0*j])));
  if(j==1728,return(ellinit([1+0*j,0*j])));
  k=j/(1728-j);ellinit([3*k,2*k])
};

sd_aut(j,a)={
  if(j==0,return(polrootsmod('x^3-1,a)));
  if(j==1728,return(polrootsmod('x^2-1,a)));
  [a^0]
};

\\ Recover every ell-kernel from a factor of the division polynomial.
\\ x([m]P) is evaluated without choosing the y-coordinate of P.
sd_kernels(E,ell,a)={
  my(k=(ell-1)/2,D=sd_monic(elldivpol(E,ell)),F=factor(D),L=List(),
     xn=vector(k,i,ellxn(E,i)),f,z,ext,emb,inv,h,zs,covered);
  for(i=1,matsize(F)[1],
    f=F[i,1];covered=0;
    for(j=1,#L,if((L[j]%f)==0,covered=1;break));
    if(covered,next);
    if(poldegree(f)==1,
      z=-polcoef(f,0)/polcoef(f,1);
      h=prod(m=1,k,'x-subst(xn[m][1],'x,z)/subst(xn[m][2],'x,z));
    ,
      ext=ffextend(a,f,'b);z=ext[1];emb=ext[2];inv=ffinvmap(emb);
      h=prod(m=1,k,'x-subst(ffmap(emb,xn[m][1]),'x,z)/subst(ffmap(emb,xn[m][2]),'x,z));
      h=ffmap(inv,h);
      sd_assert(type(h)=="t_POL","Kernel failed to descend to F_(p^2)");
    );
    h=sd_monic(h);
    sd_assert(poldegree(h)==k && (D%h)==0,"Invalid ell-kernel");
    listput(L,h);
  );
  L=Set(Vec(L));
  sd_assert(#L==ell+1,"Wrong number of ell-kernels");
  sd_assert(prod(i=1,#L,L[i])==D,"ell-kernels do not partition ell-torsion");
  L
};

\\ x-only isomorphism from a short quotient model to its canonical j-model.
sd_iso(A,B,Ec,a)={
  my(t,R);
  if(Ec.a4==0,R=polrootsmod('x^3-Ec.a6/B,a);sd_assert(#R>0,"No cube x-isomorphism");t=R[1],
    if(Ec.a6==0,R=polrootsmod('x^2-Ec.a4/A,a);sd_assert(#R>0,"No square x-isomorphism");t=R[1],
      t=Ec.a6*A/(B*Ec.a4)
    )
  );
  sd_assert(t^2*A==Ec.a4 && t^3*B==Ec.a6,"Invalid canonical isomorphism");t
};

\\ An edge stores [target j-index, kernel h, numerator t*f, t, dual index, dual scale].
\\ Pull back a second kernel K through the edge, including the first kernel.
sd_compker(e,K)={
  my(k=poldegree(K),h=e[2],f=e[3]);
  sd_monic(h*sum(i=0,k,polcoef(K,i)*f^i*h^(2*(k-i))))
};

sd_check(p,ell,{savefile=""})={
  my(a=ffgen([p,2],'a),J=sd_ss(p,a),n=#J,E=vector(n,i,sd_curve(J[i])),
     U=vector(n,i,sd_aut(J[i],a)),K,edges=vector(n),jm=Map(),
     divs=vector(n,i,sd_monic(elldivpol(E[i],ell))),XN,
     Z,jt,t,h,v,back,g,sc,R1,R2,states=Map(),raw=0,
     M,key,rev,revkey,frobkey,data,idx,keys,fr,wr,seen,
     D,lambda=0,swapped=0,rfix=0,Lp,expected,quotientD=0,
     triple=Map(),naive=0,tm,tk,tr,tF,naiveSeen,
     rawspec=0,coarsespec=0,collision=0,alpha);
  sd_assert(isprime(p) && p>=5 && isprime(ell) && ell%2 && p!=ell,"Invalid p, ell");
  for(i=1,n,
    mapput(jm,J[i],i);
    sd_assert(ellissupersingular(E[i]),"A Legendre j-value is not supersingular");
    alpha=(p^2+1-ellcard(E[i]))/2;
    sd_assert(abs(alpha)==p,"Chosen j-model lacks scalar p^2-Frobenius");
  );
  for(i=1,n,
    K=sd_kernels(E[i],ell,a);v=vector(#K);
    for(e=1,#K,
      Z=ellisogeny(E[i],K[e]);
      sd_assert(Z[1][1]==0 && Z[1][2]==0 && Z[1][3]==0,"Quotient is not short");
      jt=ellinit(Z[1]).j;
      sd_assert(mapisdefined(jm,jt),"Isogeny escaped supersingular j-set");
      jt=mapget(jm,jt);t=sd_iso(Z[1][4],Z[1][5],E[jt],a);
      sd_assert(sd_monic(Z[2][3])==K[e],"Unexpected Velu denominator");
      v[e]=[jt,K[e],t*Z[2][1],t,0,0];
    );edges[i]=v;
  );
  \\ Identify the actual dual kernel, not a return to the same j-value.
  for(i=1,n,for(e=1,#edges[i],
    v=edges[i][e];jt=v[1];back=List();
    for(f=1,#edges[jt],if(sd_compker(v,edges[jt][f][2])==divs[i],listput(back,f)));
    sd_assert(#back==1,"Dual kernel is not unique");back=back[1];g=edges[jt][back];
    sd_assert(g[1]==i,"Dual edge has wrong endpoint");
    sc=1/(ell^2*v[4]*g[4]);
    sd_assert(setsearch(Set(U[i]),sc)>0,"Dual correction is not a source automorphism");
    \\ Verify the full rational x-map dual(phi) o phi = [ell].
    R1=v[3]/v[2]^2;R2=g[3]/g[2]^2;XN=ellxn(E[i],ell);
    sd_assert(sc*subst(R2,'x,R1)==XN[1]/XN[2],"Dual rational-map identity failed");
    edges[i][e][5]=back;edges[i][e][6]=sc;
  ));

  for(i=1,n,
    my(rawK=List());
    for(e=1,#edges[i],
      v=edges[i][e];jt=v[1];
      for(f=1,#edges[jt],
        if(f==v[5],next);
        g=edges[jt][f];h=sd_compker(v,g[2]);listput(rawK,h);raw++;
        if(#U[i]>1,rawspec++);
        key=[i,sd_canon(h,U[i])];
        \\ Reverse using dual(g), correcting its target automorphism before dual(v).
        rev=edges[g[1]][g[5]];
        rev=sd_compker(rev,sd_scale(edges[jt][v[5]][2],1/g[6]));
        revkey=[g[1],sd_canon(rev,U[g[1]])];
        frobkey=[mapget(jm,J[i]^p),sd_canon(sd_frob(h,p),U[mapget(jm,J[i]^p)])];
        data=[frobkey,revkey];
        if(mapisdefined(states,key),
          sd_assert(mapget(states,key)==data,"Actions depend on a representative"),
          mapput(states,key,data)
        );
        mapput(triple,[i,jt,g[1]],1);
      );
    );
    sd_assert(#Set(Vec(rawK))==ell*(ell+1),"Cyclic ell^2 kernels are missing or duplicated");
  );
  M=Mat(states);keys=Vec(M[,1]);D=#keys;idx=Map();
  for(i=1,D,mapput(idx,keys[i],i);if(#U[keys[i][1]]>1,coarsespec++));
  fr=vector(D);wr=vector(D);
  for(i=1,D,
    data=mapget(states,keys[i]);
    sd_assert(mapisdefined(idx,data[1]) && mapisdefined(idx,data[2]),"Action left the coarse point set");
    fr[i]=mapget(idx,data[1]);wr[i]=mapget(idx,data[2]);
  );
  for(i=1,D,
    sd_assert(fr[fr[i]]==i && wr[wr[i]]==i,"An action is not an involution");
    sd_assert(fr[wr[i]]==wr[fr[i]],"Frobenius and Fricke do not commute");
  );
  seen=vector(D);
  for(i=1,D,if(!seen[i],
    seen[i]=1;seen[wr[i]]=1;quotientD++;
    if(fr[i]==i || fr[i]==wr[i],
      lambda++;if(fr[i]!=i,swapped++);if(wr[i]==i,rfix++);
    );
  ));
  sd_assert(2*lambda==sum(i=1,D,fr[i]==i)+sum(i=1,D,fr[i]==wr[i]),"Twisted Burnside check failed");
  Lp=sum(i=1,n,J[i]^p==J[i]);expected=(ell+1)*Lp/2;
  sd_assert(lambda==expected,Str("Formula (5) mismatch at p=",p,", ell=",ell));

  \\ Diagnostic: collapse actual paths to j-triples and count their stable reverse-orbits.
  tm=Mat(triple);tk=Vec(tm[,1]);naiveSeen=Map();
  for(i=1,#tk,if(!mapisdefined(naiveSeen,tk[i]),
    tr=[tk[i][3],tk[i][2],tk[i][1]];
    sd_assert(mapisdefined(triple,tr),"Triple reversal left its set");
    mapput(naiveSeen,tk[i],1);mapput(naiveSeen,tr,1);
    tF=vector(3,j,mapget(jm,J[tk[i][j]]^p));
    if(tF==tk[i] || tF==tr,naive++);
  ));
  if(savefile!="",
    my(fd=fileopen(savefile,"w"));
    filewrite(fd,Str("CASE=[",p,",",ell,"] ;"));
    filewrite(fd,Str("p=",p,";ell=",ell,";a=ffgen(",minpoly(a,'t),",'a);"));
    filewrite(fd,Str("SS_J=",J,";"));
    filewrite(fd,Str("POINTS=",vector(D,i,[keys[i][1],keys[i][2],fr[i],wr[i]]),";"));
    filewrite(fd,"POINTS=vector(#POINTS,i,[POINTS[i][1],a^0*POINTS[i][2],POINTS[i][3],POINTS[i][4]]);");
    fileclose(fd);
  );
  [p,ell,ell^2,n,Lp,raw,D,quotientD,lambda,expected,swapped,rfix,rawspec,coarsespec,#tk,naive]
};

sd_main()={
  my(P=if(type(SD_MAXP)=="t_INT",SD_MAXP,300),
     ps=if(type(SD_PRIMES)=="t_VEC",SD_PRIMES,primes([5,P])),
     ls=if(type(SD_ELLS)=="t_VEC",SD_ELLS,[3,5,7]),
     out=if(type(SD_OUT)=="t_STR",SD_OUT,"square_direct.csv"),fd,z,count=0);
  fd=fileopen(out,"w");
  filewrite(fd,"p,ell,N,supersingular_j,rational_j,raw_cyclic_kernels,coarse_X0_points,Fricke_orbits,direct_rational_quotient,formula5,swapped_lift_orbits,rational_Fricke_fixed,raw_special_j_kernels,coarse_special_j_points,distinct_j_triples,naive_triple_count");fileflush(fd);
  for(i=1,#ps,for(j=1,#ls,if(ps[i]!=ls[j],
    z=sd_check(ps[i],ls[j]);filewrite(fd,concat(vector(#z,k,Str(if(k==1,"",","),z[k]))));fileflush(fd);
    count++;print("PASS p=",ps[i]," ell=",ls[j]," direct=",z[9]," expected=",z[10]);
  )));
  fileclose(fd);print("ALL PASSED: ",count," direct square-level comparisons");
};

if(type(SD_NO_RUN)!="t_INT" || !SD_NO_RUN,iferr(sd_main(),SD_ERR,print(SD_ERR);quit(1)));
