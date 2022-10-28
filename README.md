# imaginarium

This is my development machine. be aware that this is *mine* and what works for me does not necessarily work for you.

## H/W Configuration

Azure Ds series v3 (v3 to support nested virtualization). With the following configuration:

- OS disk: 2048GB 
- additional disk: code - 2048GB
- additional disk: data - 2048GB

> Large disks are used to get higher i/o quotas 

### mounting disks
create directories


> note the below redirect home to one of the data disks.

```
sudo -s
mkdir /opt/code
mkdir /opt/data
mkdir /opt/code/home/khenidak

# own them
chown -R khenidak:khenidak /opt/code
chown -R khenidak:khenidak /opt/data
```

create the following files

```
#/etc/systemd/system/opt-data.mount
[Unit]
Description=mount data disk

[Mount]
What=/dev/disk/azure/scsi1/<FIND THE LUN IN DISKS VIEW>
Where=/opt/data
Type=ext4

[Install]
WantedBy=multi-user.target
```

```
#/etc/systemd/system/opt-code.mount
[Unit]
Description=mount code disk

[Mount]
What=/dev/disk/azure/scsi1/<FIND THE LUN IN DISKS VIEW>
Where=/opt/code
Type=ext4

[Install]
WantedBy=multi-user.target
```
Change user name as needed, don't forget to change the directory in `/opt`
```
/etc/systemd/system/home-khenidak.mount
[Unit]
Description=bind home
After=opt-code.mount
[Mount]
What=/opt/code/home/khenidak
Where=/home/khenidak
Type=none
Options=bind

[Install]
WantedBy=multi-user.target
```
enable and start the units

```
systemctl enable opt-data.mount
systemctl enable opt-code.mount
systemctl enable opt-code-home-khenidak.mount

systemctl start opt-data.mount
systemctl start opt-code.mount
systemctl start opt-code-home-khenidak.mount
```

## Basic software
packages i use are in `./installed-packages`

they were captured with
`apt list --installed 2>/dev/null | sed '/^$/d' |  awk '{split($0,a,"/"); print a[1]}' > ./installed-packages`

to install them run
` xargs -n 1 -I{} sudo apt install -y {} < <( cat ./imaginarium/installed-packages)`

## configuring the box

### bash profile
load up additional bash setting by adding this to your bashrc
`source ./imaginarium/box/.bashrc__extra` 

### tmux
link tmux configuration file to what is in the imaginarium
`ln -s ./imaginarium/box/.tmux.conf ./.tmux.conf`

### vi

The entire setup uses git submodules. You will need to perform after first pull

```
git submodule update --init --recursive
```

Like everything else these submodules may depend on other submodules (YCM does that) and also like everything else
these submodules undergo updates and bug fixes so it is always a good idea to bring in the latest. Depending on your git config YMMV on how to bring the latest. This answer covers the details https://stackoverflow.com/questions/18770545/why-is-my-git-submodule-head-detached-from-master/55570998#55570998  

TL;DR; submodules refs are on commits. When you use `git submodule update ..` you are bringing down the same refs (detached). To work around that use `git submodule update --remote --rebase` to ff your refs.

add  the following to `~/.vimrc`

`source /home/khenidak/imaginarium/box/.vimrc`

In my setup i have empty .vimrc on home directory with just sourcing whatever
i have in my imaginarium


build YouCompleteMe
```
cd ~/.vim/bundles/YouCompleteMe/
python3 install.py --all
```

> note: install .net if you are building for omnisharp, details here: https://docs.microsoft.com/en-us/dotnet/core/install/linux-package-manager-ubuntu-1804. Also check https://github.com/ycm-core/YouCompleteMe for more details about YCM

### additional software packages: nodejs etc

-**nodejs**: I use a more modern `v 10.x` nodejs (for typescript). Follow instruction here: https://github.com/nodesource/distributions/blob/master/README.md

- **typescript**: `do not install via apt` follow https://www.typescriptlang.org/docs/tutorial.html. or just run(after nodeks is installed) `npm install -g typescript`

- **tool chain stuff**: rushjs `npm install -g @microsoft/rush` 

## additional software: azure cli
follow: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest


**TODO: MORE ON CONFIG **
## workflow
my day starts with 

1. `sDev xyz` where xyz is whatever i am working in. That starts (or connects to existing) tmux session. `iDev` starts a default profile named `kal` where core stuff are always there.
2. the session is kept with multiple tabs panes etc with code (vi) running.

** TODO nested virtual machines  
