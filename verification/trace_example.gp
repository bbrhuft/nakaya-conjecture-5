\\ A separate modular-form trace computation for the worked example.
\\ Run with PARI/GP: gp -fq -s 256000000 trace_example.gp
mf=mfinit([143,2],1);
at=mfatkininit(mf,13); rp=2-2*trace(at[2]/at[3]);
at=mfatkininit(mf,143); rnp=2-2*trace(at[2]/at[3]);
if(rp!=4 || rnp!=20,error("independent trace check failed"));
print("N=11, p=13: r_p=",rp,", r_Np=",rnp,", count=",(rp+rnp)/4);
