*******************************************************************************;
/* prepare-mesa-for-nsrr.sas */
*******************************************************************************;

*******************************************************************************;
* establish options and libnames ;
*******************************************************************************;
  options nofmterr;
  data _null_;
    call symput("sasfiledate",put(year("&sysdate"d),4.)||put(month("&sysdate"d),z2.)||put(day("&sysdate"d),z2.));
  run;

  libname mesacc "\\rfawin\bwh-sleepepi-mesa\nsrr-prep\_datasets\mesa-master";
  libname mesansrr "\\rfawin\bwh-sleepepi-mesa\nsrr-prep\_datasets";

  *set data dictionary version;
  %let version = 0.2.0.beta2;

*******************************************************************************;
* import and process master datasets from source ;
*******************************************************************************;
  data mesa_bridge;
    set mesacc.mesabiolincc_bridgeid_20160815;

    *create exam number variable for later graph generation;
    examnumber = 5;
  run;

  data mesa_e1;
    set mesacc.mesae1finallabel02092016;

    keep idno race1c gender1 cucmcn1c;
  run;

  data mesa_e5;
    set mesacc.Mesasleep_age_idno_20160922;

    keep idno sleepage5c;
  run;

  data mesa_sleepq;
    set mesacc.mesae5_sleepq_20140617;
  run;

  data mesa_polysomnography;
    set mesacc.mesae5_sleeppolysomn_20150630;
  run;

  data mesa_poly_icsd;
    set mesacc.mesasleepdata_20140904;

    rename pptid = idno;

    *create new AHI variables for icsd3;
    ahi_a0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                    urbp3 + urop3 + unrbp3 + unrop3 +
                    carbp + carop + canbp + canop +
                    oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_a0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                    urbp4 + urop4 + unrbp4 + unrop4 +
                    carbp + carop + canbp + canop +
                    oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_a0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                      urbpa3 + uropa3 + unrbpa3 + unropa3 +
                      carbp + carop + canbp + canop +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_a0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                      urbpa4 + uropa4 + unrbpa4 + unropa4 +
                      carbp + carop + canbp + canop +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;

    ahi_o0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                    urbp3 + urop3 + unrbp3 + unrop3 +
                    oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_o0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                    urbp4 + urop4 + unrbp4 + unrop4 +
                    oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_o0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                      urbpa3 + uropa3 + unrbpa3 + unropa3 +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;
    ahi_o0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                      urbpa4 + uropa4 + unrbpa4 + unropa4 +
                      oarbp + oarop + oanbp + oanop ) / slpprdp;

    ahi_c0h3 = 60 * (hrembp3 + hrop3 + hnrbp3 + hnrop3 +
                    urbp3 + urop3 + unrbp3 + unrop3 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h4 = 60 * (hrembp4 + hrop4 + hnrbp4 + hnrop4 +
                    urbp4 + urop4 + unrbp4 + unrop4 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h3a = 60 * (hremba3 + hroa3 + hnrba3 + hnroa3 +
                    urbpa3 + uropa3 + unrbpa3 + unropa3 +
                    carbp + carop + canbp + canop ) / slpprdp;
    ahi_c0h4a = 60 * (hremba4 + hroa4 + hnrba4 + hnroa4 +
                    urbpa4 + uropa4 + unrbpa4 + unropa4 +
                    carbp + carop + canbp + canop ) / slpprdp;

    cent_obs_ratio = (carbp + carop + canbp + canop) /
                      (oarbp + oarop + oanbp + oanop);
    cent_obs_ratioa = (carba + caroa + canba + canoa) /
                      (oarba + oaroa + oanba + oanoa);

    keep pptid ahi_a0h3--cent_obs_ratioa;
  run;

  data mesa_actigraphy;
    set mesacc.mesae5_sleepactigraphy_20140617;
  run;

  *merge datasets;
  data mesa_nsrr;
    merge mesa_bridge
      mesa_e1 (in=d)
      mesa_e5
      mesa_sleepq (in=a)
      mesa_polysomnography (in=b)
      mesa_poly_icsd
      mesa_actigraphy (in=c);
    by idno;

    *only keep subjects with sleep-related data;
    if d and (b or c);

    *recode values for clarity;
    if inhomepsgyn5 = -9 then inhomepsgyn5 = .; /* missing code, set to nil */

    *drop 'idno' in favor of using 'mesaid' for dataset and files;
    drop idno;

    *drop other variables, reasons specified;
    drop qcomments5 /* actigraphy comments, includes dates for a handful of studies and is otherwise not useful */
      siteid5 /* site identifier */;
  run;

  proc sort data=mesa_nsrr;
    by mesaid;
  run;

*******************************************************************************;
* make all variable names lowercase ;
*******************************************************************************;
  options mprint;
  %macro lowcase(dsn);
       %let dsid=%sysfunc(open(&dsn));
       %let num=%sysfunc(attrn(&dsid,nvars));
       %put &num;
       data &dsn;
             set &dsn(rename=(
          %do i = 1 %to &num;
          %let var&i=%sysfunc(varname(&dsid,&i));    /*function of varname returns the name of a SAS data set variable*/
          &&var&i=%sysfunc(lowcase(&&var&i))         /*rename all variables*/
          %end;));
          %let close=%sysfunc(close(&dsid));
    run;
  %mend lowcase;

  %lowcase(mesa_nsrr);

*******************************************************************************;
* create permanent sas datasets ;
*******************************************************************************;
  data mesansrr.mesansrr_&sasfiledate;
    set mesa_nsrr;
  run;

*******************************************************************************;
* export nsrr csv datasets ;
*******************************************************************************;
  proc export
    data=mesa_nsrr
    outfile="\\rfawin\bwh-sleepepi-mesa\nsrr-prep\_releases\&version\mesa-sleep-dataset-&version..csv"
    dbms=csv
    replace;
  run;
