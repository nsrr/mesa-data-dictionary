options obs=100 nofmterr;

/* ---------------------------------------------------------------------------
 * Sample master datasets for the multi-way MERGE step adapted from
 * scripts/prepare-mesa-for-nsrr.sas (the mesa_nsrr DATA step).
 * Upstream these are eleven libname mesacc datasets; here four representative
 * contributors stand in for the e1 (demographics), sleep-questionnaire,
 * polysomnography, and actigraphy sources, keyed by idno.
 * ------------------------------------------------------------------------- */
data mesa_e1;
  length race1c $2;
  input idno race1c $ gender1 cucmcn1c;
  datalines;
1 01 1 100
2 02 0 100
3 03 1 100
4 04 0 100
5 01 1 100
;
run;

data mesa_sleepq;
  input idno inhomepsgyn5;
  datalines;
1 1
2 1
3 0
5 1
;
run;

data mesa_polysomnography;
  input idno slpprdp5;
  datalines;
1 360
2 420
4 300
;
run;

data mesa_actigraphy;
  input idno avgmainsleep5;
  datalines;
1 400
3 380
5 410
;
run;

proc sort data=mesa_e1;             by idno; run;
proc sort data=mesa_sleepq;         by idno; run;
proc sort data=mesa_polysomnography; by idno; run;
proc sort data=mesa_actigraphy;     by idno; run;
