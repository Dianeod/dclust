dbscan:{[sample;minpts;eps]
  diste:{(where y>=sum each m*m:x[z]-/:x) except z}[sample;eps]each til count sample;
  dbtab:([] idx:til count sample;dist:diste;clust:0N;valid:1b);
  
  db.clust:{
     ncl:{[x;y;z] raze{$[y<=count cl:x[z][`dist];exec idx from x where idx in cl,valid;]
      }[x;y]each exec idx from x where idx in z,valid}[dbtab:z[0];y]each cl1:z[1];
     dbtab:update clust:x,valid:0b from dbtab where idx in distinct raze cl1;
     (dbtab;ncl)};

    calc:{cl:{0<>sum type each x[1]}db.clust[y[2];x]/(y[0];y[1]);
      nc:first exec idx from dbtab:cl[0] where valid;
      (dbtab;nc;y[2]+1)};

    NN:{0N<>x[1]}calc[minpts]/(dbtab;0;0);
    {[x;y] exec idx from x[0] where clust=y}[NN]each distinct NN[0]`clust
    }
