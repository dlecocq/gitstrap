gitstrap
========

Store your bootstrap configuration in github gists, compose into recipes.
Boostrapping recipes change from time to time. Gists are nice because they're
one-off, low-maintenance, hosted, and can easily change over time.

While this is aimed at Amazon EC2, it can, of course, be used anywhere.

Using
=====
This can be invoked on any machine with `curl`, `tar`, and `bash`. Of course, 
you can provide any interpretere you'd like in each of the recipes on the 
hashbang line:

    gs_url='https://raw.github.com/dlecocq/gitstrap/master/gitstrap.sh'
    curl -s $gs_url | bash -s - gist [gist [...]]

If a gist contains multiple files, it will attempt to run all of those files in
the __order they appear in `ls`__. If the order of execution is important, you 
should order their names lexigoraphically.

It also supports downloading __any tarball__ that has a bunch of shell scripts. 
Or if a __single uncompressed script__ is more your style, that's possible, too.

Using on EC2
============
EC2 instances can be started with user data. Interestingly enough, this user 
data is interpreted as a script if it begins with a hashbang line. So, if you
were to supply:

    #! /usr/bin/env bash
    gs_url='https://raw.github.com/dlecocq/gitstrap/master/gitstrap.sh'
    curl -s $gs_url | bash -s - gist [gist [...]]

as your user data when starting an instance, when it boots, it would run all the
gists provided at those urls.

Installing
==========
If you'd like to use it more regularly, you can also install gitstrap:

    git clone https://github.com/dlecocq/gitstrap.git
    cd gitstrap
    ./gitstrap.sh install
