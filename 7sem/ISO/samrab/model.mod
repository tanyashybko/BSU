set WORKERS;
set JOBS;

param time{WORKERS, JOBS} >= 0;

minimize total_time:
    sum{w in WORKERS} max{j in JOBS} time[w,j];

minimize total_time_squared:
    sum{w in WORKERS} (max{j in JOBS} time[w,j])^2;

subject to complete_jobs {j in JOBS}:
    sum{w in WORKERS} 1 = 1;