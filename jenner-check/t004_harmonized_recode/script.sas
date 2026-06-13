/******************************************************************************
 * NSRR-harmonized variable derivation, adapted from
 * scripts/prepare-mesa-for-nsrr.sas (the mesa_harmonized DATA step).
 * The demographic, smoking, polysomnography, and scoring-flag recodes are kept
 * exactly as written upstream, including the age-90 top-coding and the
 * character-format assignments for the categorical NSRR variables.
 ******************************************************************************/
data mesa_harmonized;
set mesa_nsrr;

  nsrrid = mesaid;

  nsrr_visit = examnumber;

*demographics
*age;
*use sleepage5c;
  format nsrr_age 8.2;
  if sleepage5c gt 89 then nsrr_age=90;
  else if sleepage5c le 89 then nsrr_age = sleepage5c;

*bmi;
*use bmi5c;
  format nsrr_bmi 8.2;
  nsrr_bmi = bmi5c;

*age_gt89;
*use sleepage5c;
  format nsrr_age_gt89 $10.;
  if sleepage5c gt 89 then nsrr_age_gt89='yes';
  else if sleepage5c le 89 then nsrr_age_gt89='no';

*sex;
*use gender1;
  format nsrr_sex $10.;
  if gender1 = 1 then nsrr_sex = 'male';
  else if gender1 = 0 then nsrr_sex = 'female';
  else if gender1 = . then nsrr_sex = 'not reported';

*race;
*use race1c;
    format nsrr_race $100.;
  if race1c = '01' then nsrr_race = 'white';
    else if race1c = '02' then nsrr_race = 'asian';
  else if race1c = '03' then nsrr_race = 'black or african american';
  else if race1c = '04' then nsrr_race = 'hispanic';
    else if race1c = '.' then nsrr_race = 'not reported';

*current smoker
*use cursmk5;
  format nsrr_current_smoker $100.;
  if cursmk5 = 0 then nsrr_current_smoker='no';
  else if cursmk5 = 1 then nsrr_current_smoker = 'yes';
  else if cursmk5 = '.' then nsrr_current_smoker = 'not reported';

*ever smoker
*use smkstat5;
  format nsrr_ever_smoker $100.;
  if smkstat5 = 0 then nsrr_ever_smoker='no';
  else if smkstat5 = 1 then nsrr_ever_smoker = 'yes';
  else if smkstat5 = 2 then nsrr_ever_smoker = 'yes';
  else if smkstat5 = 3 then nsrr_ever_smoker = 'yes';
  else if smkstat5 = 4 then nsrr_ever_smoker = 'not reported';
  else if smkstat5 = '.' then nsrr_ever_smoker = 'not reported';

*polysomnography;
*nsrr_ahi_hp3u;
*use ahi_a0h3;
  format nsrr_ahi_hp3u 8.2;
  nsrr_ahi_hp3u = ahi_a0h3;

*nsrr_ahi_hp3r_aasm15;
*use ahi_a0h3a;
  format nsrr_ahi_hp3r_aasm15 8.2;
  nsrr_ahi_hp3r_aasm15 = ahi_a0h3a;

*nsrr_tst_f1;
*use slpprdp5;
  format nsrr_tst_f1 8.2;
  nsrr_tst_f1 = slpprdp5;

*nsrr_flag_spsw;
*use slewake5;
  format nsrr_flag_spsw $100.;
    if slewake5 = 1 then nsrr_flag_spsw = 'sleep/wake only';
    else if slewake5 = 0 then nsrr_flag_spsw = 'full scoring';
    else if slewake5 = 8 then nsrr_flag_spsw = 'unknown';
  else if slewake5 = . then nsrr_flag_spsw = 'unknown';

  keep
    nsrrid
    nsrr_visit
    nsrr_age
    nsrr_age_gt89
    nsrr_sex
    nsrr_race
	nsrr_bmi
    nsrr_current_smoker
    nsrr_ever_smoker
    nsrr_ahi_hp3u
    nsrr_ahi_hp3r_aasm15
    nsrr_tst_f1
    nsrr_flag_spsw
  ;
run;

proc print data=mesa_harmonized;
run;
