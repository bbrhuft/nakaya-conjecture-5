\\ A second direct count: middle curve with an unordered pair of ell-subgroups.
\\ Reuses only the Hasse j-set and ell-kernel constructors, not Velu or Fricke.
SD_NO_RUN=1;read("verify_square_direct.gp");

mp_check(p,ell)={
  my(a=ffgen([p,2],'a),J=sd_ss(p,a),ans=0,nj=0,pairs=0,E,U,K,
     objects,orb,can,fc,fp,rows=List(),r,kkey,images);
  for(i=1,#J,if(J[i]^p==J[i],
    nj++;E=sd_curve(J[i]);U=sd_aut(J[i],a);K=sd_kernels(E,ell,a);objects=Map();
    for(c=1,#K,for(d=c+1,#K,
      pairs++;
      orb=vector(#U,u,Set([sd_scale(K[c],U[u]),sd_scale(K[d],U[u])]));
      can=Set(orb)[1];
      fc=sd_frob(K[c],p);fp=sd_frob(K[d],p);
      orb=vector(#U,u,Set([sd_scale(fc,U[u]),sd_scale(fp,U[u])]));
      images=Set(orb)[1];
      if(mapisdefined(objects,can),sd_assert(mapget(objects,can)==images,"Pair action is ill-defined"),mapput(objects,can,images));
    ));
    r=Mat(objects);kkey=Vec(r[,1]);kkey=sum(k=1,#kkey,mapget(objects,kkey[k])==kkey[k]);
    sd_assert(kkey==(ell+1)/2,"Middle-j fibre did not give (ell+1)/2");
    ans+=kkey;
  ));
  [p,ell,nj,pairs,ans]
};

mp_main()={
  my(ps=concat(primes([5,1000]),[1009,2003,5003]),ls=[3,5,7],fd=fileopen("middle_pairs.csv","w"),z,n=0);
  filewrite(fd,"p,ell,rational_middle_j,raw_unordered_pairs,direct_middle_pair_count");fileflush(fd);
  for(i=1,#ps,for(j=1,#ls,if(ps[i]!=ls[j],
    z=mp_check(ps[i],ls[j]);filewrite(fd,concat(vector(#z,k,Str(if(k==1,"",","),z[k]))));fileflush(fd);n++;
  )));
  fileclose(fd);print("MIDDLE PAIRS ALL PASSED: ",n);
};
iferr(mp_main(),MP_ERR,print(MP_ERR);quit(1));
