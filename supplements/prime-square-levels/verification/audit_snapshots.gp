\\ Read the supplied p=13 point sets; check their two actions and recount orbits.
\\ The main verifier constructs Fricke by explicit dual isogenies.
\\ This small audit operates on the saved permutations and kernel polynomials.
snap_assert(b,s)={if(!b,error(s))};
snap_frob(h,p)=sum(i=0,poldegree(h),polcoef(h,i)^p*'x^i);
snap_audit(file)={
  read(file);
  my(n=#POINTS,F=vector(n,i,POINTS[i][3]),W=vector(n,i,POINTS[i][4]),
     seen=vector(n),count=0,orbits=0,swapped=0);
  for(i=1,n,
    snap_assert(F[F[i]]==i && W[W[i]]==i && F[W[i]]==W[F[i]],"Permutation identity failed");
    snap_assert(POINTS[F[i]][2]==snap_frob(POINTS[i][2],p),"Saved Frobenius kernel mismatch");
  );
  for(i=1,n,if(!seen[i],
    seen[i]=1;seen[W[i]]=1;orbits++;
    if(F[i]==i || F[i]==W[i],count++;if(F[i]!=i,swapped++));
  ));
  print("p=",p," ell=",ell," X0 points=",n," Fricke orbits=",orbits,
        " rational=",count," swapped lifts=",swapped);
  [p,ell,n,orbits,count,swapped]
};
for(i=1,3,snap_audit(Str("example_p13_ell",[3,5,7][i],".gp")));
