options obs=100 nofmterr;

/* ---------------------------------------------------------------------------
 * Sample harmonized dataset for the QC step adapted from
 * scripts/prepare-mesa-for-nsrr.sas (the "checking harmonized datasets"
 * PROC MEANS and PROC FREQ block). Upstream this runs on mesa_harmonized;
 * here five rows carry the continuous and categorical NSRR variables the
 * two checks summarize.
 * ------------------------------------------------------------------------- */
data mesa_harmonized;
  length nsrr_sex $10 nsrr_race $30 nsrr_age_gt89 $10
         nsrr_current_smoker $12 nsrr_ever_smoker $12 nsrr_flag_spsw $20;
  input nsrrid nsrr_age nsrr_bmi nsrr_ahi_hp3u nsrr_tst_f1 nsrr_waso_f1
        nsrr_sex $ nsrr_race $ nsrr_age_gt89 $ nsrr_current_smoker $
        nsrr_ever_smoker $ nsrr_flag_spsw $;
  datalines;
1001 62 27.3 12.4 360 45 male white no no yes full_scoring
1002 90 31.0 28.7 410 60 female black no yes yes sleepwake_only
1003 58 24.8 5.2 380 30 male hispanic no no no full_scoring
1004 74 29.1 18.0 350 52 female asian no yes yes unknown
1005 66 26.5 9.8 395 38 male white no no no full_scoring
;
run;
