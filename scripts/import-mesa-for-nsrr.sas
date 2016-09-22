*import-mesa-for-nsrr.sas;

*set library name and options;
libname mesacc "\\rfawin\bwh-sleepepi-mesa\nsrr-prep\_datasets";
options nofmterr;

*set dataset version number;
%let release = 0.1.0.pre;

*import sas datasets from mesa coordinating center;
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
  merge mesa_sleepq
    mesa_polysomnography
    mesa_actigraphy;
  by idno;

  *recode values for clarity;
  if inhomepsgyn5 = -9 then inhomepsgyn5 = .; /* missing code, set to nil */
run;

*export to csv for depositing on nsrr;
proc export 
  data=mesa_nsrr 
  outfile="\\rfawin\bwh-sleepepi-mesa\nsrr-prep\_releases\&release\mesa-sleep-dataset-&release..csv" 
  dbms=csv 
  replace; 
run;
