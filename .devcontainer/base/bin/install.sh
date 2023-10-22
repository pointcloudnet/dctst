#!/usr/bin/env /bin/bash

    # For debugging...
    set -ax

    # ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
    # → Be safe: use deterministic paths ← 
    # ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    PATH=/bin:$PATH

    # devcontainer.json invokes this, so cwd is set there
    bin=$PWD
    main=$bin/..
    app=$main/app
    skel=$main/skel
    wsdir=/workspaces
    classname=utx
    tgtdir=$wsdir/$classname
    tgtrepo=https://git.bootcampcontent.com/University-of-Texas-at-Austin/UTA-VIRT-FSF-PT-10-2023-U-LOLC.git
    bclname=edxbc
    bcldir=$wsdir/$bclname
    bclrepo=https://github.com/coding-boot-camp/fullstack-live.git
    instname=ghinstr
    instrdir=$wsdir/$instname
    nodenpm=$main/node-18.16.tgz

    [[ $1 ]] && sc=$1 || sc=". ~/.env"
    [[ $2 ]] && fn=$2 || fn=$HOME/.bashrc

    # Copy dotfiles to home directory
    cd $skel
    for f in .*; do [[ -f $f && $f != .bashrc ]] && cp $f $HOME; done

    # Source .env from inside of .bashrc
    #   grep return values...
    #     pattern found: $? = 0 => do nothing
    #     not found: $? = 1 => pattern not found, append to file
    #     no file: $? = 2 => no file, copy from skel
    [[ ! -f $fn ]] && cp $skel/.bashrc $fn \
    || [[ $(grep "${sc}" ${fn} > /dev/null 2>&1; echo $?) == 1 ]] \
    && echo "${sc}" >> ${fn}

    # Fix broken ps1 in .bashrc
    cd $main
    [[ -f $bin/fmod.sh && -f $app/ps1.sh ]] && $bin/fmod.sh $app/ps1.sh ${fn}
    
    # [[ ! -d /workspaces/utx || ! `/bin/ls /workspaces/utx` ]] && git clone https://git.bootcampcontent.com/University-of-Texas-at-Austin/UTA-VIRT-FSF-PT-10-2023-U-LOLC.git /workspaces/utx
    # [[ -d $wsdir/utx ]] && [[ ! $(/bin/ls -F $wsdir/utx | wc -w 2>/dev/null) -gt 0 ]] && git clone https://git.bootcampcontent.com/University-of-Texas-at-Austin/UTA-VIRT-FSF-PT-10-2023-U-LOLC.git /workspaces/utx
    [[ ! -d $tgtdir ]] && git clone $tgtrepo $tgtdir
    [[ -d $tgtdir && ! $(/bin/ls -F $tgtdir 2>/dev/null | wc -w 2>/dev/null) -gt 0 ]] && /bin/rm -rf $tgtdir && git clone $tgtrepo $tgtdir
    cd $instrdir && git config user.name jrollio && git config user.email jrollio@outlook.com
    cd $wsdir
    [[ ! -d $bcldir ]] && git clone $bclrepo $bcldir
    [[ -d $bcldir && ! $(/bin/ls -F $bcldir 2>/dev/null | wc -w 2>/dev/null) -gt 0 ]] && /bin/rm -rf $bcldir && git clone $bclrepo $bcldir

    # && git clone https://github.com/jrollio/ghinstr \
#    cd /usr
#    sudo tar zxvf $nodenpm;
    # Add and update pkgs
    # note: worlds should be unique per dev container type base vs enhanced etc...
    # todo:  add graceful fail
#    [[ -r $app/world ]] && \
#        sudo apk add --update --no-cache $(< $app/world) \
#        && sudo apk update \
#        && sudo apk upgrade \
#    ;
    id -a;
    srcpth=/usr/local/share/npm-global/lib/node_modules
    trgpth=/usr/local/bin
    [[ $((npm -v)) -lt 10 ]] && sudo npm i -g npm@10.1.0 \
    && [[ -d $srcpth ]] && for f in npm npx pnpm tsc tslint-to-eslint-config tsserver; do sudo /bin/ln -sf $srcpth/$f $trgpth/$f; done