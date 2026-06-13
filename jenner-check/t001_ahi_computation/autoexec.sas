options obs=100 nofmterr;

/* ---------------------------------------------------------------------------
 * Sample polysomnography source for the AHI-derivation step adapted from
 * scripts/prepare-mesa-for-nsrr.sas (the mesa_poly_icsd DATA step).
 * Upstream this comes from libname mesacc "\\rfawin\...\mesa-master".
 * These 3 rows reproduce the event-count column shape the script reads.
 * ------------------------------------------------------------------------- */
data mesa_poly_icsd;
  input pptid
        hrembp3 hrop3 hnrbp3 hnrop3 urbp3 urop3 unrbp3 unrop3
        carbp carop canbp canop oarbp oarop oanbp oanop
        hrembp4 hrop4 hnrbp4 hnrop4 urbp4 urop4 unrbp4 unrop4
        hremba3 hroa3 hnrba3 hnroa3 urbpa3 uropa3 unrbpa3 unropa3
        hremba4 hroa4 hnrba4 hnroa4 urbpa4 uropa4 unrbpa4 unropa4
        carba caroa canba canoa oarba oaroa oanba oanoa
        slpprdp;
  datalines;
101 5 3 2 1 4 2 1 0 1 1 0 0 2 1 1 0 5 3 2 1 4 2 1 0 4 3 2 1 3 2 1 0 4 3 2 1 3 2 1 0 1 1 0 0 2 1 1 0 360
102 2 1 1 0 1 1 0 0 0 0 0 0 1 0 0 0 2 1 1 0 1 1 0 0 1 1 0 0 1 0 0 0 1 1 0 0 1 0 0 0 0 0 0 0 1 0 0 0 420
103 8 4 3 2 5 3 2 1 2 1 1 0 4 2 2 1 8 4 3 2 5 3 2 1 7 4 3 2 4 2 2 1 7 4 3 2 4 2 2 1 2 1 1 0 4 2 2 1 300
;
run;
