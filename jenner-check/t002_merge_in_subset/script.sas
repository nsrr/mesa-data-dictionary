/******************************************************************************
 * Multi-way MERGE with IN= subsetting, adapted from
 * scripts/prepare-mesa-for-nsrr.sas (the mesa_nsrr DATA step).
 * The IN= flags and the "only keep subjects with sleep-related data" subset
 * rule (if d and (b or c)) are kept exactly as written upstream, and the
 * missing-code recode for inhomepsgyn5 is also preserved.
 ******************************************************************************/
  *merge datasets;
  data mesa_nsrr;
    merge mesa_e1 (in=d)
      mesa_sleepq (in=a)
      mesa_polysomnography (in=b)
      mesa_actigraphy (in=c)
      ;
    by idno;

    *only keep subjects with sleep-related data;
    if d and (b or c);

    *recode values for clarity;
    if inhomepsgyn5 = -9 then inhomepsgyn5 = .; /* missing code, set to nil */
  run;

  proc print data=mesa_nsrr;
  run;
