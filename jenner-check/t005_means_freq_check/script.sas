/******************************************************************************
 * Harmonized-dataset quality checks, adapted from
 * scripts/prepare-mesa-for-nsrr.sas (the "checking harmonized datasets"
 * block). PROC MEANS scans the continuous NSRR variables for extreme values
 * and PROC FREQ tabulates the categorical NSRR variables, with the same VAR
 * and TABLE variable lists used upstream.
 ******************************************************************************/
/* Checking for extreme values for continuous variables */
proc means data=mesa_harmonized;
VAR   nsrr_age
      nsrr_bmi
    nsrr_ahi_hp3u
    nsrr_tst_f1
    nsrr_waso_f1
      ;
run;

/* Checking categorical variables */
proc freq data=mesa_harmonized;
table   nsrr_age_gt89
      nsrr_sex
      nsrr_race
	  nsrr_current_smoker
      nsrr_ever_smoker
      nsrr_flag_spsw;
run;
