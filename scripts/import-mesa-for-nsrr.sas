*import-mesa-for-nsrr.sas;

*set library name and options;
libname mesacc "\\rfawin\bwh-sleepepi-mesa\nsrr-prep\_datasets";
options nofmterr;

*set dataset version number;
%let release = 0.1.1.rc;

*import sas datasets from mesa coordinating center;
data mesa_bridge;
  set mesacc.mesabiolincc_bridgeid_20160815;

  *create exam number variable for later graph generation;
  examnumber = 5;
run;

data mesa_e1;
  set mesacc.mesae1finallabel02092016;

  *limit dataset to subjects who have consented to have data shared;
  if cucmcn1c = 1;

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

*export to csv for depositing on nsrr;
proc export
  data=mesa_nsrr
  outfile="\\rfawin\bwh-sleepepi-mesa\nsrr-prep\_releases\commercial\&release\mesa-sleep-dataset-&release..csv"
  dbms=csv
  replace;
run;
