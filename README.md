# imaginarium

This is my development machine.

## H/W Configuration

Azure Ds series v3 (v3 to support nested virtualization). With the following configuration:

- OS disk: 2048GB 
- additional disk: code - 2048GB
- additional disk: data - 2048GB

> Large disks are used to get higher i/o quotas 

<<TODO MOUNT UNIT FILES>>

## Basic software
packages i use are in `./installed-packages`

they were captured with
`apt list --installed 2>/dev/null | sed '/^$/d' |  awk '{split($0,a,"/"); print a[1]}' > ./installed-packages`

to install them run
` xargs -n 1 -I{} sudo apt install -y {} < <( cat ./imaginarium/installed-packages)`


## configuring the box

### tmux:
link tmux configuration file to what is in the imaginarium
`ln -s ./imaginarium/box/.tmux.conf ./.tmux.conf`

### vi:
link the configuration file:
`ln -s ./imaginarium/box/.vimrc ./.vimrc`

link the plugin/theme director
`ln -s ./imaginarium/box/.vim ./vim`



### additional software packages: nodejs etc

- nodejs
I use a more modern `v 10.x` nodejs (for typescript). Follow instruction here: https://github.com/nodesource/distributions/blob/master/README.md

- typescript
`do not install via apt` follow https://www.typescriptlang.org/docs/tutorial.html. or just run(after nodeks is installed) `npm install -g typescript`

- tool chain stuff 
rushjs `npm install -g @microsoft/rush` 
