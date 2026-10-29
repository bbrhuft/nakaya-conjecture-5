\\ Two checks of the stored relations R_N(X,Y) = X^2 - a_N(Y) X + b_N(Y).
\\ (1) At N = 2, 3, 5, 7, R_N equals the polynomial printed by Morton
\\     (arXiv:2105.14532v1, Section 1; also Morton, JNT 218 (2021), Section 6).
\\ (2) At all fifteen levels, for 20 random Y0 in F_l (l = 1000003), the two roots
\\     j, j' of R_N(X, Y0) in F_{l^2} satisfy Phi_N(j, j') = 0, where Phi_N is
\\     PARI's classical modular polynomial (polmodular). This checks the curve,
\\     not the additive normalization of Y.
\\ Run from verification/conjecture4/:  gp -q -s 2000000000 independent/check_relations.gp
T='T; X='X;
{
  my(M=Map());
  mapput(M,2, X^2 - X*(T^2-207*T+3456) + (T+144)^3);
  mapput(M,3, X^2 - X*T*(T^2-126*T+2944) + T*(T+192)^3);
  mapput(M,5, X^2 - X*(T^5-80*T^4+1890*T^3-12600*T^2+7776*T+3456) + (T^2+216*T+144)^3);
  mapput(M,7, X^2 - X*T*(T^2-21*T+8)*(T^4-42*T^3+454*T^2-1008*T-1280) + T^2*(T^2+224*T+448)^3);
  foreach([2,3,5,7],N, my(r=read(Str("results/relation_",N,".gp")));
    print("N=",N," stored R_N equals Morton's R_N: ", X^2-r[1]*X+r[2]==mapget(M,N)));
  my(l=1000003, bad=0); setrand(1);
  foreach([2,3,5,7,11,13,17,19,23,29,31,41,47,59,71],N,
    my(r=read(Str("results/relation_",N,".gp")), g=ffgen(ffinit(l,2),'w), Phi=polmodular(N), ok=0, tot=0);
    for(t=1,20,
      my(y0=random(l), a=subst(r[1],T,y0), b=subst(r[2],T,y0), disc=(a^2-4*b)*g^0);
      if(disc==0, next);
      my(s=sqrt(disc), j1=(a+s)/2, j2=(a-s)/2);
      tot++; if(subst(subst(Phi,x,j1),y,j2)==0, ok++));
    if(ok<tot, bad++);
    print("N=",N," Phi_N(j,j')=0 on ",ok,"/",tot," random fibres"));
  print(if(bad,"FAILED","ALL RELATIONS CONSISTENT WITH PHI_N"));
}
quit
