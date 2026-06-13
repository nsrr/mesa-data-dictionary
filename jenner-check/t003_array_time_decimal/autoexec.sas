options obs=100 nofmterr;

/* ---------------------------------------------------------------------------
 * Sample sleep clock-time columns for the time-conversion step adapted from
 * scripts/prepare-mesa-for-nsrr.sas (the "Convert time variables to hours of
 * day" block of the mesa_nsrr DATA step). Upstream these character HH:MM:SS
 * fields arrive on the merged mesa_nsrr dataset; here three rows supply the
 * five clock-time columns the array logic reads.
 * ------------------------------------------------------------------------- */
data mesa_nsrr;
  length stendp5 stlonp5 stloutp5 stonsetp5 ststartp5 $8;
  input mesaid $ stendp5 $ stlonp5 $ stloutp5 $ stonsetp5 $ ststartp5 $;
  datalines;
1001 06:30:00 23:15:00 06:45:00 23:40:00 22:50:00
1002 05:55:00 00:05:00 06:10:00 00:30:00 23:30:00
1003 07:10:00 22:45:00 07:25:00 23:05:00 22:20:00
;
run;
