options obs=100 nofmterr;

/* ---------------------------------------------------------------------------
 * Sample mesa_nsrr input for the harmonization step adapted from
 * scripts/prepare-mesa-for-nsrr.sas (the mesa_harmonized DATA step).
 * Upstream mesa_nsrr is the merged master dataset; here four rows carry the
 * source variables the NSRR-standard recodes read (age, bmi, sex, race,
 * smoking, AHI, total sleep time, scoring flag).
 * ------------------------------------------------------------------------- */
data mesa_nsrr;
  length race1c $2;
  input mesaid examnumber sleepage5c bmi5c gender1 race1c $ cursmk5 smkstat5
        ahi_a0h3 ahi_a0h3a slpprdp5 slewake5;
  datalines;
1001 5 62 27.3 1 01 0 2 12.4 10.1 360 0
1002 5 91 31.0 0 03 1 1 28.7 25.5 410 1
1003 5 58 24.8 1 04 0 0 5.2 4.1 380 0
1004 5 74 29.1 0 02 1 4 18.0 16.2 350 8
;
run;
