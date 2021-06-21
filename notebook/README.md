Before you start to run the notebook on the remote server, set the jupyter notebook password on the on the frontend server
```
jupyter notebook password
```
Then you can use the job script `notebook_job.sh` to run the notebook on a server which binds the remote port 8889. Wait until the job runs (check with `squeue`). In general you can build an ssh tunnel from your local machine to a remote node with
```
ssh -t <GASPAR_ACCOUNT>@<FRONTEND_SERVER_ADDRESS> -L <LOCAL_PORT>:localhost:<REMOTE_PORT> ssh <REMOTE_PORT> -L <REMOTE_PORT>:localhost:<REMOTE_PORT>
```
You can see that the ssh connection is forwarded from your local machine to the frontend server and from the frontend server to the computation port. We use the same REMOTE_PORT for the frontend server and computation node for simplicity. If you not already runnig some application on port 8888, you can bind the notebook on your local machine on port 8888 and forward it to the remote server with 
```
ssh -t <GASPAR_ACCOUNT>@<FRONTEND_SERVER_ADDRESS> -L 8888:localhost:8889 ssh <NODE_NAME> -L 8889:localhost:8889
```
where <NODE_NAME> can be seen in the output of the slurm job `slurm.out`. You can check on the frontend server if the port is already in use by typing
```
netstat -l | grep 8889
```
If the output is empty, then it should be not in use. Now type in your browser on your local machine
```
localhost:8888
```
and type the password you have set at the beginning or if you haven't done so, you can also copy the token in the slurm.out script
