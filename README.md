Blackbird Docker / Consul Demo
==============================

This repository uses [boot2docker](https://github.com/boot2docker/boot2docker) to provision a running, in-memory linux instance of Kernel 3.14.1 with AUFS, Docker 0.10.1, and LXC 0.8.0 under Vagrant using VirtualBox under $DEMOROOT. 

Once up and running, you can run the three Docker containers defined by the Dockerfiles in the subprojects - they are as follows:

     1. consul-agent-bootstrap-local: This container runs consul in "consul agent -server -bootstrap" mode, which provisions a new gossip pool in the default (dc1) datacenter. The script *start_join.sh* both builds the docker container and starts it, so it should be run in a separate terminal window or put (nohup) in the background. It also must be run before any other container. 

     2. tutam-docker-mysql: This container uses supervisord to start an instance of mysql and a local consul agent, which is configured (via the consul config file *tutum-mysql-docker/consul.json*) to add a service to the consul catalog called *mysql* and a health check called *tutum-mysql-docker/check_mysql.sh*.

     3. consul-monitor: This container also uses supervisord to run an instance of consul, and a script that dumps the consul members and service catalog to a logfile ($DEMOLOGS/supervisor/check_consul-stdout-*). This allows you to prove that the service catalog is made available to the entire gossip pool. 

Installation and Operation
__________________________

	1. Install [VirtualBox](https://www.virtualbox.org/).
	2. Make sure you have git installed.
	3. cd to the root of this repository.
	4. If desired, edit *env.sh* to set DEMOROOT and DEMOLOGS to a place of your choosing. By default, they are created at */tmp/b2d*.
	5. Run *./setup.sh* - this creates $DEMOROOT and $DEMOLOGS on your host system (the one running VirtualBox), and starts up a docker host under boot2docker. ___ NOTE: you must enter the password *tcuser* when requested.___It also downloads consul and installs it on the docker host (see step *10*)
	6. Open 3 terminal windows and cd to the root of this repository in each.
	7. In the first terminal window, run *./start_join.sh*. You should see the consul -bootstrap agent start up and show that a new gossip pool is created and running.
	8. In the second window, run *./start_mysql.sh*. You should see mysql startup and supervisord report mysql and consul are healthy.
	9. In the third window, run *./start_monitor.sh*. You should see supervisord report that consul and check_consul.sh are healthy. *start_monitor.sh* exposes all of the consul ports to the docker host, such that you can now access one consul agent from the docker host.
	10. Open a fourth terminal window, and cd to this repository root. Now run *. env.sh*, which will set the B2D (boot2docker executable) environment variable. Now run *$B2D ssh*, log in with password *tcuser*, and run *consul members*. If you can see output that looks like the following, you know things are probably working:

> fa609389e13b  172.17.0.4:8301  alive  role=node,dc=dc1,vsn=1,vsn_min=1,vsn_max=1
> 7909e2d40d8c  172.17.0.3:8301  alive  role=node,dc=dc1,vsn=1,vsn_min=1,vsn_max=1
> 733d4e37638e  172.17.0.2:8301  alive  role=consul,dc=dc1,vsn=1,vsn_min=1,vsn_max=1,port=8300,bootstrap=1

At this point you should feel free to inspect the HTTP and DNS APIs of consul from the docker host, i.e.:

   1. (after $B2D ssh'ing in): *curl localhost:8500/v1/catalog/services*: list all registered consul services. You should see mysql reported.
   2. *curl localhost:8500/v1/agent/members*: list all nodes registered with this consul agent.
   3. *./start_monitor.sh* also deploys the (consul UI)[http://www.consul.io/intro/getting-started/ui.html] on the consul http port (8500), and exposes it to the docker host. I suggest you open up virtualbox, and port-forward 8500 to your physical host (the machine running virtualbox), so that you can pop a browser on [localhost:8500/ui](http://localhost:8500/ui) and play with it.


Finally, you can shut the whole thing down and delete the boot2docker VM with *./stop_and_delete.sh*, or just shut the containers down with *./stop_containers.sh*, which will leave the docker host running and allow you to restart the containers. Note that you may get an error like "name xxx is already assigned to yyyy", and if this is case you will need to perform a "docker rm yyyy" (where yyyy is the hash of the container) to set things right again. 

Logging
_______

Logging is a little complicated in this setup, because there doesn't seem to be a great way to expose virtualbox host directories to docker containers, since that is a 3-pancake stack of AUFS filesystems, which doesn't work very well. Hence: 
	1. docker run output goes to stdout when you run each container start script.
	2. Logs from daemons running inside the containers are collected **on the docker host** under $DEMOLOGS/logs/*.
