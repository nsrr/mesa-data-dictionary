/******************************************************************************
 * Clock-time to decimal-hours conversion, adapted from
 * scripts/prepare-mesa-for-nsrr.sas (the "Convert time variables to hours of
 * day" block). The three parallel arrays, the INPUT(...,time.) parse, and the
 * 43200-second pivot that wraps pre-noon times past midnight are kept exactly
 * as written upstream.
 ******************************************************************************/
  data mesa_nsrr;
    set mesa_nsrr;

*Convert time variables to hours of day;
array char_times {5} $ stendp5 stlonp5 stloutp5 stonsetp5 ststartp5;
array num_times {5} stendp5_num stlonp5_num stloutp5_num stonsetp5_num ststartp5_num;
array dec_times {5} stendp5_dec stlonp5_dec stloutp5_dec stonsetp5_dec ststartp5_dec;

format stendp5_dec stlonp5_dec stloutp5_dec stonsetp5_dec ststartp5_dec 8.2;

do i = 1 to 5;
    ** Convert character to numeric time **;
    num_times[i] = input(char_times[i], time.);

    ** Convert to decimal hours **;
    if not missing(num_times[i]) then do;
        if num_times[i] < 43200 then dec_times[i] = num_times[i]/3600 + 24;
        else dec_times[i] = num_times[i]/3600;
    end;
end;

drop i stendp5_num	stlonp5_num	stloutp5_num	stonsetp5_num	ststartp5_num;
  run;

  proc print data=mesa_nsrr;
    var mesaid stendp5_dec stlonp5_dec stloutp5_dec stonsetp5_dec ststartp5_dec;
  run;
