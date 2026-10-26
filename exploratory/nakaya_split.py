from morton_nakaya import *
def split(N,l,R):
    one=gp(f"Mod(1,{l})"); ss=one*gp.Pol(gp.lift(ss_poly(l)),"X"); c={'A':0,'B':0,'C':0}
    for t in range(l):
        Q=gp.subst(R,"T",t)*one
        if gp.poldegree(gp.gcd(Q,ss))<1: continue
        F=gp.factor(Q); degs=[int(gp.poldegree(F[0][i])) for i in range(len(F[0]))]
        c['C' if degs==[2] else ('B' if len(degs)==1 else 'A')]+=1
    return c
rel={N:relation(N) for N in (5,7,13)}
rows=[]
for l in [int(x) for x in gp.primes([11,400])]:
    lin,quad=ss_factors(l); L=len(lin)
    for N in (5,7,13):
        if l==N: continue
        c=split(N,l,rel[N]); k=lambda a: leg(a,N)*leg(a,l)
        tA=gp("1/2")*(1+leg(-l,N))*L; tB=gp("1/8")*(2+(1-k(-1))*(2+k(-2)))*hfield(N*l)
        rows.append((N,l,c['A'],str(tA),c['B']+c['C'],str(tB),c['B'],c['C']))
okA=sum(r[2]==int(gp(r[3])) for r in rows); okB=sum(r[4]==int(gp(r[5])) for r in rows)
print(f"cases {len(rows)}: distinct-rational-roots count = term1 in {okA}; (double root + conjugate pair) = term2 in {okB}")
print("sample (N,l, A,term1, B+C,term2, B,C):", rows[-6:])
from collections import Counter
print("shift (A-term1) among mismatches:", Counter(r[2]-int(gp(r[3])) for r in rows if r[2]!=int(gp(r[3]))))
print("totals always equal:", all(r[2]+r[4]==int(gp(r[3]))+int(gp(r[5])) for r in rows))
print("mismatch with B==0 (no double roots):", sum(1 for r in rows if r[2]!=int(gp(r[3])) and r[6]==0))
