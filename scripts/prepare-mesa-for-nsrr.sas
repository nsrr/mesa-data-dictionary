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

  %let version = 0.7.0.commercial;

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

    *limit dataset to subjects who have consented to have data shared;
    if cucmcn1c = 1;

    keep idno race1c gender1 cucmcn1c;
  run;

  data mesa_e5sleepage;
    set mesacc.Mesasleep_age_idno_20160922;

    keep idno sleepage5c ;
  run;

  data mesa_e5;
    set mesacc.Mesae5_finallabel_20160520;

    keep idno site5c htcm5 wtlb5 smkstat5 cursmk5 bmi5c;
  run;

  data mesa_sleepq;
    set mesacc.mesae5_sleepq_20140617;
  run;

  data mesa_polysomnography;
    set mesacc.mesae5_sleeppolysomn_20160922;
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
    set mesacc.mesae5_sleepactigraphy_20180201;
  run;

  data mesa_hrvfull;
    set mesacc.Mesae5_sleephrvfull_20171215;
  run;

  data mesa_hrv5min;
    set mesacc.Mesae5_sleephrv5min_20171215;
  run;

  proc import datafile="\\rfawin.partners.org\bwh-sleepepi-mesa\nsrr-prep\_datasets\endotypes\MESA_02172023.xlsx"
    out=mesa_loopgain_in
    dbms=xlsx
    replace;
    sheet = "NREM";
  run;

  data mesa_loopgain;
    set mesa_loopgain_in;

    format lgn 8.3;
    rename id = idno;

    keep id lgn;
  run;

  proc sort data=mesa_loopgain;
    by idno;
  run;

  *merge datasets;
  data mesa_nsrr;
    merge mesa_bridge
      mesa_e1 (in=d)
      mesa_e5sleepage
      mesa_e5
      mesa_sleepq (in=a)
      mesa_polysomnography (in=b)
      mesa_poly_icsd
      mesa_hrvfull
      mesa_hrv5min
      mesa_actigraphy (in=c)
      mesa_loopgain
      ;
    by idno;

    *only keep subjects with sleep-related data;
    if d and (b or c);

    *recode values for clarity;
    if inhomepsgyn5 = -9 then inhomepsgyn5 = .; /* missing code, set to nil */

    *remlaiip5 set to missing when only scored as sleep/wake (rem/non-rem is unreliable);
  if slewake5 = 1 then do;

    remlaiip5 = .;

  end;


    *drop 'idno' in favor of using 'mesaid' for dataset and files;
    drop idno;

    *drop other variables, reasons specified;
    drop
      qcomments5 /* actigraphy comments, includes dates for a handful of studies and is otherwise not useful */
      siteid5 /* site identifier */
      /* variables below removed in 2020-2021 review/harmonization */
      rdi0p5
      rdi2p5
      rdi3p5
      rdi4p5
      rdi5p5
      a0h3ai5
      ahi4p5
      ahi4pa5
      avg24hrsleeprd5
      avgact24hr5
      avgactactive5
      avgactmainsleep5
      avgactnaps5
      avgbluetaltrd5
      avgefficiencyrd5
      avgfragmentationrd5
      avggreentaltrd5
      avginbeddurationrd5
      avginbedtimerd5
      avginbedwakerd5
      avgmainsleeprd5
      avgmainteffrd5
      avgnnapsallrd5
      avgnnapssleep15rd5
      avgnnapssleeprd5
      avgonsetlatencyrd5
      avgoutbedtimerd5
      avgredtaltrd5
      avgrestmidpointrd5
      avgsleepboutsrd5
      avgsleepmidpointrd5
      avgsleepnapdaily15rd5
      avgsleepnapdailynw5
      avgsleepnapsallrd5
      avgsleepnapssleep15rd5
      avgsleepnapssleeprd5
      avgsleepoffsettimerd5
      avgsleeponsettimerd5
      avgsleepperioddurationrd5
      avgsnoozerd5
      avgwakeboutsrd5
      avgwasord5
      avgwhitetaltrd5
      losao2nr5
      losao2r5
      ndaysnapsallrd5
      ndaysnapssleep15rd5
      ndaysnapssleeprd5
      ndaysrd5
      rdi0pa5
      rdi0pns5
      rdi0ps5
      rdi2pa5
      rdi2pns5
      rdi2ps5
      rdi3pa5
      rdi3pns5
      rdi3ps5
      rdi4pa5
      rdi4pns5
      rdi4ps5
      rdi5pa5
      rdi5pns5
      rdi5ps5
      rdinba35
      rdinba5
      rdinbp5
      rdinoa35
      rdinoa5
      rdinop5
      rdinr0p5
      rdinr2p5
      rdinr3p5
      rdinr4p5
      rdinr5p5
      rdirba35
      rdirba5
      rdirbp5
      rdirem0p5
      rdirem2p5
      rdirem3p5
      rdirem4p5
      rdirem5p5
      rdiroa35
      rdiroa5
      rdirop5
      sd24hrsleeprd5
      sdefficiencyrd5
      sdinbeddurationrd5
      sdinbedtimerd5
      sdmainsleeprd5
      sdmainteffrd5
      sdoutbedtimerd5
      sdrestmidpointrd5
      sdsleepmidpointrd5
      sdsleepoffsettimerd5
      sdsleeponsettimerd5
      sdsleepperioddurationrd5
      stonset15
      timebedm5
      wake_bouts_avg_sleep5
      ;
  run;

  proc sort data=mesa_nsrr;
    by mesaid;
  run;


  proc print data= mesa_nsrr (obs= 10);
  run;
*******************************************************************************;
* create harmonized datasets ;
*******************************************************************************;

data mesa_harmonized;
set mesa_nsrr;

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

*ethnicity;
*not outputting ethnicity variable;

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

*nsrr_ahi_hp4u_aasm15;
*use ahi_a0h4;
  format nsrr_ahi_hp4u_aasm15 8.2;
  nsrr_ahi_hp4u_aasm15 = ahi_a0h4;

*nsrr_ahi_hp4r;
*use ahi_a0h4a;
  format nsrr_ahi_hp4r 8.2;
  nsrr_ahi_hp4r = ahi_a0h4a;

*nsrr_ttldursp_f1;
*use slpprdp5;
  format nsrr_ttldursp_f1 8.2;
  nsrr_ttldursp_f1 = slpprdp5;
 
*nsrr_tst_f1;
*use slpprdp5;
  format nsrr_tst_f1 8.2;
  nsrr_tst_f1 = slpprdp5;
  
*nsrr_phrnumar_f1;
*use ai_all5;
  format nsrr_phrnumar_f1 8.2;
  nsrr_phrnumar_f1 = ai_all5;

*nsrr_flag_spsw;
*use slewake5;
  format nsrr_flag_spsw $100.;
    if slewake5 = 1 then nsrr_flag_spsw = 'sleep/wake only';
    else if slewake5 = 0 then nsrr_flag_spsw = 'full scoring';
    else if slewake5 = 8 then nsrr_flag_spsw = 'unknown';
    else if slewake5 = . then nsrr_flag_spsw = 'unknown';
 
*nsrr_ttleffsp_f1;
*use slp_eff5;
  format nsrr_ttleffsp_f1 8.2;
  nsrr_ttleffsp_f1 = slp_eff5;  

*nsrr_ttlmefsp_f1;
*use slp_maint_eff5;
  format nsrr_ttlmefsp_f1 8.2;
  nsrr_ttlmefsp_f1 = slp_maint_eff5;  
  
*nsrr_ttllatsp_f1;
*use slp_lat5;
  format nsrr_ttllatsp_f1 8.2;
  nsrr_ttllatsp_f1 = slp_lat5; 

*nsrr_ttlprdsp_s1sr;
*use rem_lat15;
  format nsrr_ttlprdsp_s1sr 8.2;
  nsrr_ttlprdsp_s1sr = rem_lat15; 

*nsrr_ttldursp_s1sr;
*use remlaiip5;
  format nsrr_ttldursp_s1sr 8.2;
  nsrr_ttldursp_s1sr = remlaiip5; 

*nsrr_waso_f1;
*use waso5;
  format nsrr_waso_f1 8.2;
  nsrr_waso_f1 = waso5;
  
*nsrr_pctdursp_s1;
*use timest1p5;
  format nsrr_pctdursp_s1 8.2;
  nsrr_pctdursp_s1 = timest1p5;

*nsrr_pctdursp_s2;
*use timest2p5;
  format nsrr_pctdursp_s2 8.2;
  nsrr_pctdursp_s2 = timest2p5;

*nsrr_pctdursp_s3;
*use times34p5;
  format nsrr_pctdursp_s3 8.2;
  nsrr_pctdursp_s3 = times34p5;

*nsrr_pctdursp_sr;
*use timeremp5;
  format nsrr_pctdursp_sr 8.2;
  nsrr_pctdursp_sr = timeremp5;

*nsrr_tib_f1;
*use time_bed5;
  format nsrr_tib_f1 8.2;
  nsrr_tib_f1 = time_bed5;  
 
  keep 
    mesaid
    examnumber
    nsrr_age
    nsrr_age_gt89
    nsrr_sex
    nsrr_race
	  nsrr_bmi
    nsrr_current_smoker
    nsrr_ever_smoker
    nsrr_ahi_hp3u
    nsrr_ahi_hp3r_aasm15
    nsrr_ahi_hp4u_aasm15
    nsrr_ahi_hp4r
    nsrr_tst_f1
    nsrr_phrnumar_f1
    nsrr_flag_spsw
    nsrr_ttleffsp_f1
    nsrr_ttlmefsp_f1
    nsrr_ttllatsp_f1
    nsrr_ttlprdsp_s1sr
    nsrr_ttldursp_s1sr
    nsrr_waso_f1
    nsrr_pctdursp_s1
    nsrr_pctdursp_s2
    nsrr_pctdursp_s3
    nsrr_pctdursp_sr
    nsrr_tib_f1
  ;
run;

*******************************************************************************;
* checking harmonized datasets ;
*******************************************************************************;
/* Checking for extreme values for continuous variables */
proc means data=mesa_harmonized;
VAR   nsrr_age
      nsrr_bmi
    nsrr_ahi_hp3u
    nsrr_ahi_hp3r_aasm15
    nsrr_ahi_hp4u_aasm15
    nsrr_ahi_hp4r
    nsrr_tst_f1
    nsrr_phrnumar_f1
    nsrr_ttleffsp_f1
    nsrr_ttlmefsp_f1
  nsrr_ttllatsp_f1
  nsrr_ttlprdsp_s1sr
  nsrr_ttldursp_s1sr
  nsrr_waso_f1
  nsrr_pctdursp_s1
  nsrr_pctdursp_s2
  nsrr_pctdursp_s3
  nsrr_pctdursp_sr
  nsrr_tib_f1
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
  %lowcase(mesa_harmonized);

*******************************************************************************;
* create permanent sas datasets ;
*******************************************************************************;
  data mesansrr.mesansrr_&sasfiledate;
    set mesa_nsrr;
  run;

    data mesaharmonized.mesaharmonized_&sasfiledate;
    set mesa_harmonized;
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

    proc export
    data=mesa_harmonized
    outfile="\\rfawin\bwh-sleepepi-mesa\nsrr-prep\_releases\&version\mesa-sleep-harmonized-dataset-&version..csv"
    dbms=csv
    replace;
  run;
