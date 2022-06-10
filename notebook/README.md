If you have jupyter notebook already installed, please check that it is installed in your virtual environment (you see it with `python -c "import jupyter; print(jupyter.__file__)"`) and not in your `.local/lib/` folder. If the latter is the case, please uninstall it and properly install it in your virtual environment.

Before you start to run the notebook on the remote server, set the jupyter notebook password on the on the frontend server
```
jupyter notebook password
```
Then you can use the job script `notebook_job.sh` to run the notebook on a server which binds the remote port 8889. Wait until the job runs (check with `squeue`). In general you can build an ssh tunnel from your local machine to a remote node with
```
ssh -t <GASPAR_ACCOUNT>@<FRONTEND_SERVER_ADDRESS> -L <LOCAL_PORT>:localhost:<REMOTE_PORT> ssh <NODE_NAME> -L <REMOTE_PORT>:localhost:<REMOTE_PORT>
```
You can see that the ssh connection is forwarded from your local machine to the frontend server and from the frontend server to the computation port. We use the same `<REMOTE_PORT>` for the frontend server and computation node for simplicity. If you not already runnig some application on port 8888, you can bind the notebook on your local machine on port 8888 and forward it to the remote server with 
```
ssh -t <GASPAR_ACCOUNT>@<FRONTEND_SERVER_ADDRESS> -L 8888:localhost:8889 ssh <NODE_NAME> -L 8889:localhost:8889
```
where `<NODE_NAME>` can be seen in the output of the slurm job `slurm.out`. You can check on the frontend server if the port is already in use by typing
```
netstat -l | grep 8889
```
If the output is empty, then it should be not in use. Now type in your browser on your local machine
```
localhost:8888
```
and type the password you have set at the beginning or if you haven't done so, you can also copy the token in the slurm.out script

## FAQs

Q1. When entering my password for jupyter notebooks on my local browser, I get an error message that states "Invalid credentials." I am entering the correct password that I set with `jupyter notebook password`. Why is this?

Answer: This may come from the <REMOTE_PORT> on the Frontend Server already being in use. Check the output in terminal when starting up the SSH connection to the node. You might have received an inconspicuous error message that states:
```
bind [127.0.0.1]:8889: Address already in use
channel_setup_fwd_listener_tcpip: cannot listen to port: 8889
Could not request local forwarding.
```
when your <REMOTE_PORT> is set to 8889, for example.

To remedy this, change the <REMOTE_PORT> address on the Frontend Server when connecting through SSH. For example:
```
ssh -t <GASPAR_ACCOUNT>@<FRONTEND_SERVER_ADDRESS> -L 8888:localhost:9001 ssh <NODE_NAME> -L 9001:localhost:8889
```
