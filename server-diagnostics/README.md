My job was killed, what happened?
--------------------------------

Most likely your job was killed because of too much memory usage or it was running too long.
Look in your SLURM log, you will probably find the answer there. 
What also might help is the command
```
sacct
```
which can give you a lot of information about your jobs.

If you are looking for a job which was started one day ago or earlier, you probably will not find your job because `sacct` only shows you the jobs that started today by default. You can set the starting time to look for older jobs
```
sacct --starttime=2021-05-04
```

If your job has reached the time limit, can be checked with 
```
sacct --job=your_job_id --format=Timelimit,CPUTime
```
where `Timelimit` is the time limit of the job and `CPUTime` is the actual time the job took.
If your job has reached the memory RAM limit, can be checked with 
```
sacct --job=your_job_id --unit=M --format=ReqMem,MaxRSS
```
where `ReqMem` is the memory limit of the job and `MaxRSS` is the maximum memory usage of the job and unit returns the statistics in megabytes. Be aware the `MaxRSS` is not always accurate (see subfolder `ram_usage` for more information), since is only polled every 60 seconds by default. So it could be that the correct peak memory usage was not polled, if your job increased the memory usage very fast. It is in general advisable to log your program probably to know in which state it was when the job was killed.


I don't see my log messages in the SLURM log
---------------------------------------------

The problem is most likely that the log messages are buffered somewhere before being written into the log file. Depending on the programming language you use there are different solutions.

In python you can enforce immediate prints by runnig python with the flag '-u'
```
python -u <PROGRAM>.py
```
or if you want to only immediately output certain prints then you can use `flush=True`
```
print("My log message", flush=True)
```


My job does not start, why?
--------------------------

It could be that some node is down or drained, you can check this with
```
sinfo
```
You can see the `STATE` of the cluster, and the reason for getting into drained or down state with
```
scontrol show node NODE_NAME
```
There should be an explanation under `Reason`. You can contact the admin with that output
