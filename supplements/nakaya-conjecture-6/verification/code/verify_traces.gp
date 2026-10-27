\\ Independent characteristic-zero computation on the FULL weight-two cusp space.
C6_NO_RUN=1;read("code/verify_conjecture6.gp");
c6_traces()={
  my(cnt=0);
  fileclose(fileopen("results/traces.csv","w"));
  write("results/traces.csv","N,p,level,cusp_dimension,trace_wN,fixed_from_trace,fixed_order_formula,genusA,conjecture6");
  for(i=1,#c6_levels,
    my(N=c6_levels[i]);
    for(j=1,3,
      my(p=[5,7,13][j]);if(p==N,next);
      my(mf=mfinit([N*p,2],1),g=mfdim(mf),at=mfatkininit(mf,N),W=at[2]/at[3],t=if(g==0,0,trace(W)));
      nk_assert(g==c6_genus(N,p),"cusp dimension differs from genus");
      if(g>0,nk_assert(W*W==matid(g),"Atkin-Lehner matrix not involution"));
      my(r=2-2*t,gA=(g+t)/2);
      nk_assert(r==c6_fixed(N,p) && gA+1==c6_rhs(N,p),Str("trace mismatch ",N,",",p));
      write("results/traces.csv",Str(N,",",p,",",N*p,",",g,",",t,",",r,",",c6_fixed(N,p),",",gA,",",c6_rhs(N,p)));
      cnt++;
    );
    print("trace level ",N," done");fileflush();
  );
  print("TRACE PASSED: ",cnt," cases");
};
iferr(c6_traces(),E,print("FAILED: ",E);quit(1));
quit(0);
