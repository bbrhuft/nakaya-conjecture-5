\\ Export the stored relations and correction factors as coefficient lists
\\ (lowest degree first) for flint_c4.py. Run from verification/conjecture4/:
\\   gp -q independent/export_relations.gp
\\ Output: independent/relations.json (one JSON object per level).
T='T;
{
  my(out="independent/relations.json");
  fileclose(fileopen(out,"w"));
  foreach([2,3,5,7,11,13,17,19,23,29,31,41,47,59,71], N,
    my(r=read(Str("results/relation_",N,".gp")), d=read(Str("results/data_",N,".gp")));
    write(out, Str("{\"N\":",N,",\"a\":",Vecrev(r[1]),",\"b\":",Vecrev(r[2]),
      ",\"A\":",Vecrev(d[1]),",\"B\":",Vecrev(d[2]),",\"E\":",Vecrev(d[3]),"}")));
}
quit
