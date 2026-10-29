\\ Comparison of Hajouji's Table 1 with g(X_0(Np)^*) (Remark 8.4 of the paper).
\\
\\ Hajouji, "Supersingular isogeny graphs from algebraic modular curves",
\\ arXiv:2303.09096v3, Section 2.5 and Table 1, gives Ob(p,l): the number of
\\ irreducible quadratic factors over F_p of the level-l supersingular polynomial,
\\ for all pairs of primes p, l in Nakaya's set. T1 below is transcribed from
\\ that table (rows and columns in the order of S).
\\
\\ By Corollary 6.3 this number is g(X_0(pl)^*) for l in S\{2}, p >= 5, p != l.
\\ Since X_0(p)^+ and X_0(l)^+ have genus 0, the old part of S_2(Gamma_0(pl))
\\ contributes nothing, and g(X_0(pl)^*) is the number of newforms with both
\\ Atkin-Lehner eigenvalues +1. For a newform, w_q = -a_q (q | pl), so
\\   g(X_0(pl)^*) = (dim S_2^new - tr U_p - tr U_l + tr U_pl) / 4,
\\ with traces read from PARI's trace form on the newspace.
\\ Run: gp -q -s 2000000000 hajouji_table1.gp   (PARI/GP 2.15.4; about 1 s)
T1=[0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1; 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 1, 1, 2, 2; 0, 0, 0, 0, 0, 1, 2, 0, 2, 1, 1, 2, 5, 3, 4; 0, 0, 0, 0, 1, 1, 0, 2, 2, 3, 3, 2, 3, 5, 9; 0, 0, 0, 1, 0, 1, 3, 2, 5, 4, 4, 6, 10, 12, 15; 0, 0, 1, 1, 1, 0, 2, 4, 2, 5, 8, 11, 9, 12, 16; 0, 0, 2, 0, 3, 2, 0, 5, 5, 10, 7, 15, 12, 18, 22; 0, 1, 0, 2, 2, 4, 5, 0, 7, 5, 10, 11, 16, 17, 20; 0, 0, 2, 2, 5, 2, 5, 7, 0, 12, 12, 16, 21, 27, 33; 1, 0, 1, 3, 4, 5, 10, 5, 12, 0, 12, 24, 26, 28, 38; 0, 2, 1, 3, 4, 8, 7, 10, 12, 12, 0, 17, 28, 34, 39; 1, 1, 2, 2, 6, 11, 15, 11, 16, 24, 17, 0, 36, 46, 51; 0, 1, 5, 3, 10, 9, 12, 16, 21, 26, 28, 36, 0, 56, 67; 1, 2, 3, 5, 12, 12, 18, 17, 27, 28, 34, 46, 56, 0, 83; 1, 2, 4, 9, 15, 16, 22, 20, 33, 38, 39, 51, 67, 83, 0];
S=[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71];
gstar(p,l)={my(M=p*l,tf=mftraceform([M,2],0),c=mfcoefs(tf,M),d=mfdim([M,2],0));(d-c[p+1]-c[l+1]+c[M+1])/4};
{
  my(bad=0,cnt=0);
  print("Hajouji Table 1 symmetric: ",T1==T1~);
  for(i=1,15,for(k=i+1,15,
    my(p=S[i],l=S[k],g=gstar(p,l)); cnt++;
    print(p," ",l," g*=",g," table=",T1[i,k],"/",T1[k,i]);
    if(g!=T1[i,k]||g!=T1[k,i],bad++;print("  MISMATCH"))));
  print("off-diagonal unordered pairs: ",cnt,", mismatches: ",bad);
}
quit
