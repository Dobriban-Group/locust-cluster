# Locust Cluster
## Cluster access
To use the Locust cluster, currently need approval from Dylan Small and Eric Wong. Reach out to [Dylan](mailto:dsmall@wharton.upenn.edu), [Eric Wong](mailto:exwong@seas.upenn.edu), [CETS](mailto:cets@seas.upenn.edu), and CC Edgar, and ask for access to the Stats node of the Locust Cluster.

### Checking available resources


### Allocating Resources
The Locust cluster uses the [SLURM](https://slurm.schedmd.com) scheduler to manage resources - it is open-source and well-documented, thankfully (see a good cheatsheet [here](https://slurm.schedmd.com/pdfs/summary.pdf). The idea is that you submit a request for resources, and that request is queued and granted when the resources become available. You must specify a time limit -- you can't request resources indefinitely. 
We're on the `whartonstat` partition of the cluster and have some GPUs available!
A minimal example of a resource request might look something:
`salloc -t 60 -p whartonstat`
This submits your resource request to our available resource queue, and starts an interactive job that will last 60 minutes.
A more complete request:
`salloc --job-name=code --time=00-10:30:00  --partition=whartonstat --mem=20G --gpus=1`
Which allocates 20GB of RAM and 1 GPU machine for your session for 10 hours and 30 min. There are lots more options.
Right now we only have node9 available, but in general you can check where the job has been allocated with `squeue`.

Also check out [this script](/scripts/tally.sh) which you can run on the cluster to see a nicely formatted list of jobs that *also* includes GPU resources. 

### Connecting with VSCode/Cursor
Locust admin don't want us to use Remote - Tunnels, but apparently SSH is fine. Here's an example `~/.ssh/config`:
```
Host locust-login.seas.upenn.edu
  HostName locust-login.seas.upenn.edu
  IdentitiesOnly yes
  ForwardAgent yes

Host locust-node9
  HostName node9
Host locust-node8
  HostName node8

#add more like this if there are more compute nodes

Host locust-node*
  StrictHostKeyChecking no
  ControlMaster auto
  ControlPath ~/.ssh/cm/%C.compute.sock
  ProxyJump locust-login.seas.upenn.edu
```
Then in VSCode just connect to locust-node9 as the host, and it will forward you to node9. Note that you can't access node9 until you start a job on that node!

## Running (embarassingly) parallel jobs

`sbatch` : runs an array job, meaning its arguments are run in parallel and are identical except that they're each given an array index. Usually this index is either not used (jobs are identical, or perhaps just have different random initializations) or used to index a parameter list/grid so that each job runs the same function with different arguments.
*TODO: Add sbatch bash script template* 

`Dask` : A python library that let's you schedule jobs interactively in Python (it works in ipython notebooks). 
There are plenty of subtle advantages of working natively in Python inside of your current environment/session, but probably the biggest perk of the framework is that Dask provides a super nice dashboard for monitoring jobs.
Check out the [docs](https://docs.dask.org/en/stable/) and more specifically the reference for scheduling via [SLURM](https://jobqueue.dask.org/en/latest/generated/dask_jobqueue.SLURMCluster.html#dask_jobqueue.SLURMCluster). 
*TODO: Add sample script / ipython notebook*

### Using GPU
Varies depending on what program you're using. E.g. JAX will automatically detect available devices, PyTorch requires you to specify that you're using `cuda`, etc.
Basically though, if you're only doing small development work you can allocate 1 or 2 GPU to your VS Code session. Be careful though, as this reserves the resource and blocks other from using it. So DO NOT request a bunch of GPU and then leave your session idle (unless you are sure nobody else needs the resources). 
If you're running a long job you should really submit it with `srun` (for a script with a single process) or `sbatch` (for an array job)
