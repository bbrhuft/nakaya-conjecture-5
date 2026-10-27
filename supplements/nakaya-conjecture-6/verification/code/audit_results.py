#!/usr/bin/env python3
"""Strict coverage and arithmetic audit, Python standard library only."""
import csv, hashlib, json, math, platform, sys
from fractions import Fraction as F
from pathlib import Path
R=Path(__file__).resolve().parents[1]
LEVELS=[3,5,7,11,13,17,19,23,29,31,41,47,59,71]
EXTRA=[307,401,503,1009]
def prime(n):return n>=2 and all(n%d for d in range(2,math.isqrt(n)+1))
def leg(a,p):
 a%=p
 if a==0:return 0
 return 1 if pow(a,(p-1)//2,p)==1 else -1
def genus(n,p=None):
 ps=[n] if p is None else [n,p]
 mu=math.prod(x+1 for x in ps)
 e2=math.prod(1+leg(-1,x) for x in ps)
 e3=math.prod(1+leg(-3,x) for x in ps)
 return 1+F(mu,12)-F(e2,4)-F(e3,3)-F(2**len(ps),2)
def hforms(D):
 forms=[]
 for a in range(1,math.isqrt((-D)//3)+1):
  for b in range(-a,a+1):
   if (b*b-D)%(4*a):continue
   c=(b*b-D)//(4*a)
   if a>c or math.gcd(math.gcd(a,b),c)!=1:continue
   if (abs(b)==a or a==c) and b<0:continue
   forms.append((a,b,c))
 return forms
def load(name):
 with (R/'results'/name).open() as f:return list(csv.DictReader(f))
def assert_eq(a,b):
 if a!=b:raise AssertionError((a,b))
P=[p for p in range(5,301) if prime(p)]
expected={(N,p) for N in LEVELS for p in P+EXTRA if N!=p}
rows=load('degrees.csv');keys=[(int(r['N']),int(r['p'])) for r in rows]
assert_eq(len(set(keys)),len(keys));assert_eq(set(keys),expected)
for r in rows:
 N,p=int(r['N']),int(r['p']);d=genus(N)+1
 assert_eq(r['stage'],'baseline' if p<=300 else 'heldout')
 if N==3:assert_eq(d,1)
 base=len(hforms(-4*N))+(len(hforms(-N)) if N>3 and N%4==3 else 0)+(1 if N==3 else 0)
 assert_eq(base,2*d)
 rr=base*(1+leg(-N,p));g=genus(N,p)
 rhs=F((N+1)*(p-1),24)+F((1+leg(-1,N))*(1-leg(-1,p)),8)+F((1+leg(-3,N))*(1-leg(-3,p)),6)+F(1-leg(-N,p),2)*d
 assert_eq(F(r['direct_degree']),rhs);assert_eq(F(r['conjecture6']),rhs)
 assert_eq(F(r['gC']),g);assert_eq(F(r['rN']),rr)
 assert_eq(F(r['genus_degree']),(g+3)/2-F(rr,4))
 assert_eq(F(r['direct_degree']),F(r['genus_degree']))
 assert int(r['linear'])<=int(r['direct_degree'])
traces=load('traces.csv');tk=[(int(r['N']),int(r['p'])) for r in traces]
assert_eq(len(tk),len(set(tk)))
assert_eq(set(tk),{(N,p) for N in LEVELS for p in [5,7,13] if N!=p})
for r in traces:
 N,p=int(r['N']),int(r['p']);g=int(r['cusp_dimension']);t=int(r['trace_wN'])
 assert_eq(g,genus(N,p));assert_eq(int(r['fixed_from_trace']),2-2*t)
 assert_eq(int(r['fixed_from_trace']),int(r['fixed_order_formula']))
 assert_eq(F(r['genusA']),F(g+t,2));assert_eq(int(r['conjecture6']),1+F(r['genusA']))
 assert_eq(int(r['conjecture6']),int(next(x['direct_degree'] for x in rows if int(x['N'])==N and int(x['p'])==p)))
ordinary=load('ordinary_ss.csv')
assert_eq({int(r['p']) for r in ordinary},set(P+EXTRA));assert_eq(len(ordinary),len(P+EXTRA))
assert all(r['legendre_equal']=='1' for r in ordinary)
for name,marker in [('direct.log','ALL PASSED: 883'),('traces.log','TRACE PASSED: 39')]:
 log=(R/'results'/name).read_text()
 assert marker in log,log
 assert all(x not in log for x in ['***','FAILED:','error(']),log
summary={'date':'2026-10-27','direct_cases':len(rows),'baseline_cases':sum(r['stage']=='baseline' for r in rows),'heldout_cases':sum(r['stage']=='heldout' for r in rows),'heldout_primes':EXTRA,'p_less_than_N_cases':sum(p<N for N,p in keys),'levels':LEVELS,'ordinary_polynomial_crosschecks':len(ordinary),'full_cusp_space_trace_cases':len(traces),'mismatches':0,'python':platform.python_version(),'pari':'2.15.4','limitations':'Finite arithmetic checks are not a proof. Direct construction adapts inherited code. The trace comparison uses a distinct computation, but the same PARI runtime. No all-883-pair trace survey was run.'}
(R/'results'/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2))
