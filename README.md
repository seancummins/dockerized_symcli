# Dockerizing SYMCLI (For fun and... well mainly for fun)

If you work with offline SYMAPI databases frequently, you've probably encountered cases where you can't open a DMX SYMAPI database on a recent version of Solutions Enabler. Getting around this typically means you must maintain several different versions of Solutions Enabler, to ensure that you can read SYMAPI databases produced by DMX, VMAX, and VMAX^3 arrays at diverse code levels. And because only one instance/version of Solutions Enabler can be installed on any given OS instance, you end up building and maintaining several virtual machines, each with a different version of Solutions Enabler installed.

No that big of a deal, really. But it does get kind of annoying when the states of these virtual machines diverge over time. For example, when you manually install ad-hoc packages, change security settings, apply patches, modify your .dotfiles, etc.

Also, every time you need to use a particular version of Solutions Enabler, you have to boot a virtual machine -- which takes a while, and chews up memory/CPU resources just to do the same thing your host OS is already doing -- and possibly just to do the same thing that other VMs you're hosting are also doing. There's a ton of 'effort duplication' going on here just to run a particular version of Solutions Enabler on your laptop.

*Docker can make this much easier.*

First though, please understand that I would only recommend doing this for offline/test/dev use. Solutions Enabler is not designed nor tested to be used in a container, so even though it works, it could produce unexpected results -- generally not a desirable attribute in a production VMAX :)

So, to reiterate: **THIS IS NOT FOR PRODUCTION ENVIRONMENTS.**

# So what can I use it for?

Ok, I get it; it's not for production. So what's the point then?

I can think of a few good use cases:

* Provides a safe "read-only" development sandbox for creating custom reports in environments with multiple generations of Symmetrix systems.
* You're in an EMC or Partner pre-sales, post-sales, or support role, and you work with Symmetrix systems on a regular basis. [Offline SYMCLI](http://blog.scummins.com/?p=56) is a very useful for people who help other organizations install, manage, and support their VMAX arrays.
* You work with Symmetrix systems on a regular basis, and you want to learn more about [Docker](https://docker.com/).



# What does it look like?

Well, my new workflow is significantly simplified, and I no longer have to boot up different VMs to use different versions of Solutions Enabler (SE). Generally, I know which version of SE I need for a given task, so I'll start up and enter a Docker container for that particular SE version. This takes about a second, and it looks like this:

![](http://blog.scummins.com/wp-content/uploads/2014/11/SE7.6_enter_exit.gif)

The commands I used above ('se74', 'se76', 'and 'se8') are just aliases for starting and attaching to version-specific SE containers.


# How to set it up (stuff you have to do once)

Note, if you're on Linux, all “docker” commands below need to be prefaced by “sudo” — but you can avoid this by adding your user account to the “docker” group on your Linux host. You don't have to do this on MacOS with boot2docker, but you would if you're running this in a Linux VM on MacOS.

The example I'm providing here is for Solutions Enabler 7.6, but setting this up for other versions is basically the same process. I've also added all of my Dockerfiles and a few simple shell scripts to GitHub [here](https://github.com/seancummins/dockerized_symcli).

## Install Docker
First, install Docker. It's super easy; just follow the installation instructions [here](https://docs.docker.com/installation/).

I'd recommend using the latest version of Docker, which requires a few extra steps if you're on Linux. Those steps are documented at the link above.

If you're running this on MacOS, I'd highly recommend using Docker 1.3 or later -- as Docker 1.3 makes it possible to access your Mac's filesystem from within your containers (via boot2docker). Incidentally, this also enables [Fig](http://www.fig.sh/) to run seamlessly on Mac. Prior to this feature, I would run Docker on a Linux VM inside VMware Fusion on my Mac, and pass through my Mac's filesystem via VMware hgfs -- this extra VMware and hgfs layer is now unnecessary with Docker 1.3.

## Build Solutions Enabler Docker Images
### Set up your workspace
#### Option 1 (GitHub)
* Clone my [GitHub repo](https://github.com/seancummins/dockerized_symcli.git).
* Copy the appropriate Solutions Enabler install kit into each SE directory. The install kits can be downloaded from [support.emc.com](https://support.emc.com/downloads/2071_Solutions-Enabler).

#### Option 2 (Manual)
* Create a directory to house all of your Dockerfiles and dependencies. I’ll just call it "$HOME/Projects/docker/symcli/”.
* In this directory, create a subdirectory for each version of Solutions Enabler you want to run (e.g. se74, se76, se8).
* Copy the appropriate Solutions Enabler install kit into each SE directory. The install kits can be downloaded from [support.emc.com](https://support.emc.com/downloads/2071_Solutions-Enabler).

### Dockerfiles
* If you cloned my git repo, you already have the necessary Dockerfiles. So you can read the rest of this section for a walkthrough of the Dockerfiles, or you can just continue to the next section.

* If you wish to do this manually, create a file called “Dockerfile” in each of your seNN directories. This is basically a build file that tells Docker how to build each Solutions Enabler image.

* Here are the contents of my se76 Dockerfile (which resides in $HOME/Projects/docker/symcli/se76/ along with the se76 install tarball):

~~~
# Version 0.0.1
FROM centos:latest
MAINTAINER Sean Cummins "sean.cummins@emc.com"
RUN yum -y install tar hostname glibc.i686
RUN yum -y install git zsh sudo man
ADD se7628-Linux-i386-ni.tar.gz /tmp
WORKDIR /tmp
RUN ./se7628_install.sh -install -64bit -silent
WORKDIR /
ENV PATH $PATH:/opt/emc/SYMCLI/bin
ENV SYMCLI_OFFLINE 1
~~~

To break this down, here's what he Dockerfile instructs Docker to do during the image build process:

* The “FROM” statement tells docker to build this new image on top of the latest CentOS image (centos7 — which will be downloaded from DockerHub automatically if you don’t already have it). You should also be able to use opensuse, if that's your preference. And your host machine can be an entirely different distribution, including Debian-based distros like Ubuntu.

* Then we install a few commands/libraries that are required for SE to be installed correctly (you can skip glibc.i686 for SE8).

* Then we copy the SE install kit into /tmp with the “ADD” command, and change directories into /tmp.

* Next we perform an automated/silent install of SE (you can skip the –64bit flag for SE8)

* Then we change the working directory back to / and add the SYMCLI binary directory to our PATH.

* And finally, we set the SYMCLI_OFFLINE variable to 1, because we'll be using these containers for offline SYMCLI/SYMAPI purposes.

### Now we need to build this image:
~~~
cd $HOME/Projects/docker/symcli/se76
docker build -t="se76” .
~~~


The “docker images” command should list the new se76 image.

![](http://blog.scummins.com/wp-content/uploads/2014/11/ss_docker_images.png)

## Create SE Docker Containers from these Images

Now we need to start new interactive Docker containers for each version of Solutions Enabler. Once you've created the containers, they will persist across reboots -- so you'll only need to do this once. Subsequent usage of these containers is as simple as starting them (if necessary) and attaching to them -- steps which we'll cover in the next section.

### To create your containers:
~~~
docker run -v $HOME:/root -w /root -h se76 --name="se76" -i -t se76 /bin/bash
~~~
This starts a new docker container named “se76” running an interactive bash shell. If you prefer a different shell, then you can simply replace /bin/bash with the shell of your choice. You'll have to make sure you install this shell when you build your Docker images though.

- The -v flag passes your home directory on your host machine through to the containers. The coolest thing about doing this, IMHO, is that your personal home directory becomes the container's "root" home directory -- so all of your files, dotfiles, and preferences get passed through to the container. It's pretty slick.

- The -w flag sets the container's working directory to be /root.

- The -h flag sets the container's hostname.

- The --name=<name> flag sets the name of the container (which you'll see when you run 'docker ps -a').

- The -i and -t flag tell Docker that this will be an interactive container. The alternative is -d, which is a daemonized container.

- And the "se76" bit towards the end just specifies the image that we're using to spin up this container.

### Create aliases to interact with your new containers
You can skip this step, but personally I find it makes working with the containers a little easier/faster. All you need to do to enter a particular SE container is to type "se76" or "se8", and the alias will start and attach to the container you want.

To set this up, just fire up your favorite text editor, and add the following to your .bashrc, .zshrc, or whatever the appropriate dotfile is for your shell:
~~~
alias se74='docker start se74 && docker attach se74'
alias se76='docker start se76 && docker attach se76'
alias se8='docker start se8 && docker attach se8'
~~~



## Normal Workflow
Now that you've created all of your SE images and containers, you can get working. You won't need to worry about all of those Dockerfiles, building images, creating containers, etc anymore -- unless you want to modify the images, in which case I'd recommend tearing everything down, modifying your Dockerfiles, and rebuilding everything (a simple shell script can make this much easier). The alternative would be to enter each container and make changes manually, but that kind of defeats the purpose of this exercise.

Normal workflow (as depicted in the screenshot):

- Start and attach to your SE container

~~~
# If you set up aliases:
se76

# Without aliases:
docker start se76
docker attach se76
~~~

- Now that you're inside your Docker container, point SYMCLI to an offline SYMAPI database:

~~~
# Navigate to a directory containing the SYMAPI DB (~ in this case)
cd ~
# Set your SYMCLI_DB_FILE variable
export SYMCLI_DB_FILE=symapi_db.bin
~~~

- Now you can execute offline SYMCLI commands.

- When you're done, exit the container by detaching (Ctrl-P, Ctrl-Q), or by exiting the shell. The shell is essentially PID 1 within the container, so killing it will stop the container -- but starting it again takes like a second, so this is fine.

# That's It!
For the most part, offline SYMCLI seems to run fine inside containers. I’ve seen some cases where commands will take longer to complete (e.g 'symcfg list -v'), but other than that I haven’t had many issues (yet). At some point I’ll simplify this setup process with a private Docker registry and/or fig, but that’s a project for another day.

# Er wait, one more thing (for EMCers)
If you're trying to do this from a computer connected to the EMC VPN, and you're using boot2docker on MacOS or Windows, you'll have to deal with VPN split tunneling. This is probably the most annoying part of this whole process. If you're running into this, drop me an email and I'll give you some pointers.