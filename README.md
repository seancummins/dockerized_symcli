# Dockerized SYMCLI

If you work with offline SYMAPI databases frequently, you've probably encountered cases where you can't open a DMX SYMAPI database on a recent version of Solutions Enabler. Getting around this typically means you must maintain several different versions of Solutions Enabler, to ensure that you can read SYMAPI databases produced by DMX, VMAX, and VMAX^3 arrays at diverse code levels. And because only one instance/version of Solutions Enabler can be installed on any given OS instance, you end up building and maintaining several virtual machines, each with a different version of Solutions Enabler installed.

Not that big of a deal, really. But it does get kind of annoying when the states of these virtual machines diverge over time. For example, when you manually install ad-hoc packages, change security settings, apply patches, modify your .dotfiles, etc.

Also, every time you need to use a particular version of Solutions Enabler, you have to boot a virtual machine -- which takes a while, and chews up memory/CPU resources just to do the same thing your host OS is already doing -- and possibly just to do the same thing that other VMs you're hosting are also doing. In other words, you're dealing with the "VM Tax" -- there's a ton of 'effort duplication' going on here just to run a particular version of Solutions Enabler on your laptop.

*Docker can make this much easier.*

First though, please understand that I would only recommend doing this for offline/test/dev use. Solutions Enabler is not designed nor tested to be used in a container, so even though it works, it could produce unexpected results -- generally not a desirable attribute in a production VMAX :)

So, to reiterate: **THIS IS NOT FOR PRODUCTION ENVIRONMENTS.**

# So what can I use it for?

Ok, I get it; it's not for production. So what's the point then?

I can think of a few good use cases:

* Provides a safe "read-only" development sandbox for creating custom reports in environments with multiple generations of Symmetrix systems.
* You're in an EMC or Partner pre-sales, post-sales, or support role, and you work with Symmetrix systems on a regular basis. [Offline SYMCLI](http://blog.scummins.com/?p=56) is a very useful for people who help other organizations install, manage, and support their VMAX arrays.
* You work with Symmetrix systems on a regular basis, and you want to learn more about shiny new stuff like [Docker](https://docker.com/) and [Vagrant](https://www.vagrantup.com).



# What does it look like?

Well, my new workflow is significantly simplified, and I no longer have to boot up different VMs to use different versions of Solutions Enabler (SE). Generally, I know which version of SE I need for a given task, so I'll start up and enter a Docker container for that particular SE version. This takes about a second, and it looks like this:

![](usage_screenshot.gif)

The commands I used above ('se74', 'se76', 'and 'se8') are just aliases for starting and attaching to version-specific SE containers.


# How to set it up (things you have to do once)

Note, if you're on Linux, all “docker” commands below need to be prefaced by “sudo” — but you can avoid this by adding your user account to the “docker” group on your Linux host. You don't have to do this on MacOS with boot2docker, but you would if you're running this in a Linux VM on MacOS.

The example I'm providing here is for Solutions Enabler 7.6, but setting this up for other versions is basically the same process. I've also added all of my Dockerfiles and a few simple shell scripts to GitHub [here](https://github.com/seancummins/dockerized_symcli).

## Step 1: Install Some Stuff
First, you'll need to install a few things to get started.

* [Vagrant](https://www.vagrantup.com/downloads.html): For automatically deploying the host VM and containers.
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads): For hosting the host VM.
* [Git](http://git-scm.com/download/): For downloading the relevant Vagrantfiles, Dockerfiles, and supporting files.


## Step 2: Stage files locally

Now make a directory to house all of the files you'll need to deploy this crazy setup, and drop to a command prompt or terminal inside that directory.

~~~bash
cd ~
mkdir Projects
cd Projects
~~~

## Step 3: Clone GitHub Repo
Now that you're in your staging directory, you can clone [my GitHub repository](https://github.com/seancummins/dockerized_symcli.git) into your directory. You can do this via the 'git' CLI, or you can download one of the various git GUIs instead.

~~~bash
git clone https://github.com/seancummins/dockerized_symcli.git
~~~

## Step 4: Download Solutions Enabler Linux Binaries
Unfortunately this was one part of the setup I couldn't automate with Vagrant -- mainly because I can't distribute Solutions Enabler outside of the normal channel ([support.emc.com](http://support.emc.com)).

You want the Linux binaries even if you're doing this on Mac or Windows, because Solutions Enabler will ultimately be running in a Linux container.

* Download [SE 8.0.3](https://download.emc.com/downloads/DL58417_Solutions-Enabler-8.0.3-for-Linux-x64.tar.gz) and move it into the "dockerized_symcli/se8" directory.
* Download [SE 7.6](https://download.emc.com/downloads/DL53239_se7628-Linux-i386-ni.tar.gz.gz) and move it into the "dockerized_symcli/se76" directory.
* Download [SE 7.4](https://download.emc.com/downloads/DL39938_se7400-Linux-i386-ni.tar.gz.tar.gz) and move it into the "dockerized_symcli/se74" directory.

## Step 5: Deploy

You can now use Vagrant to deploy this project from the main "dockerized_symcli" directory.

~~~bash
cd dockerized_symcli
vagrant up
~~~


And that's it. You won't have to do any of this again, unless you want to redeploy your VM and containers for some reason (e.g. to make a change, or to provision a new container for a new version of SE).

**Note**: If you're on the EMC network (or VPN), you may run into issues when Docker tries to pull images from Docker Hub. If you run into this, try navigating to [Docker Hub](https://hub.docker.com) first, then retry your deploy. To retry the deploy, use the command `vagrant reload --provision`.

# Normal Workflow

Normal workflow, all via CLI (as depicted in the screenshot):

~~~bash
# Connect to the host VM (Note: this must be done from the dockerized_symcli directory)
vagrant ssh

# Use one of the predefined SE aliases ('se8', 'se76', or 'se74') to attach to an SE container
se76

# Note: you may need to hit enter here in order to see a shell prompt.

# Find your symapi_db file, set your SYMCLI_DB_FILE environment variable, and get working
# Note: your home directory inside each container is mapped directly to your laptop's home directory.
cd symapi_bins
export SYMCLI_DB_FILE=symapi_db.bin
symcfg list
~~~

Now you can execute offline SYMCLI commands.

When you're done, exit the container (just type exit or Ctrl-D), then exit the host VM (same deal).


Personally, I use the following bash/zsh aliases from my MacBook to enter each container. They handle starting the host VM (if necessary), SSHing to it, and attaching to the relevant container. And when you're done, you are returned to your previous working directory.

~~~bash
alias se8='PREVDIR=$PWD && cd ~/Projects/docker/symcli && vagrant ssh -c "docker start se8 && docker attach se8" || { vagrant up && vagrant ssh -c "docker start     se8 && docker attach se8" } && cd $PREVDIR'
alias se76='PREVDIR=$PWD && cd ~/Projects/docker/symcli && vagrant ssh -c "docker start se76 && docker attach se76" || { vagrant up && vagrant ssh -c "docker st    art se76 && docker attach se76" } && cd $PREVDIR'
alias se74='PREVDIR=$PWD && cd ~/Projects/docker/symcli && vagrant ssh -c "docker start se74 && docker attach se74" || { vagrant up && vagrant ssh -c "docker st    art se74 && docker attach se74" } && cd $PREVDIR'
alias symcli='PREVDIR=$PWD && cd ~/Projects/docker/symcli && vagrant ssh || { vagrant up && vagrant ssh } && cd $PREVDIR'

~~~

# That's It!
For the most part, offline SYMCLI seems to run fine inside containers. I’ve seen some cases where commands will take longer to complete (e.g 'symcfg list -v'), but other than that I haven’t had many issues (yet).
