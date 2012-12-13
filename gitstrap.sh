#! /usr/bin/env bash

# Execute gists (or any other curl-able url) to bootstrap a machine

# Print out usage information
function usage_f {
    echo "gitstrap.sh url [url [...]] # Run the provided urls"
    echo "            install         # Install this script for later"
}

# Install self as script
function install_f {
    echo "Installing..."
    chmod a+x $0
    cp $0 /usr/local/bin
    echo "Done."
}

# Update this script
function update_f {
    echo "Normally, I'd update myself here."
}

# Convert a gist url to a downloadable one
function gistify_f {
    if [[ "$1" == *gist.github.com* ]] ; then
        local url="`echo $1 | \
            sed 's/\(.*\.com\)\/\(.*\)/\1\/\2\/download/'`"
        # 'https://gist.github.com/X' needs to become
        # 'https://gist.github.com/gists/X/download'
        echo $url
    else
        # This isn't a gist -- let's fuggettaboutit
        echo $1
    fi
}

# Run all the scripts found in a directory, recursively
function execute_f {
    if [ -d "$1" ] ; then
        echo "Examining directory $1"
        for path in "$1"/*; do
            execute_f "$path"
        done
    else
        echo "Running $1"
        bash "$1"
        if [ $? -ne 0 ] ; then
            echo "$1 Failed :-/"
        else
            echo "$1 Complete :-)"
        fi
    fi
}

# Check to make sure we have something to do
if [ $# -eq 0 ]; then
    usage_f
    exit 1
fi

case $1 in
    install) install_f; exit;;
    update ) update_f ; exit;;
esac

while [ $# -gt 0 ] ; do
    # Read in each of the urls, curl them and interpret them.
    url=$(gistify_f $1)
    echo "Downloading $1 from $url..."
    data="`curl -s $url -o .tmp-file`"
    echo "Downloaded..."
    # Let's try to untar it. If this fails, then 
    mkdir -p .tmp
    tar xzf .tmp-file -C .tmp
    if [ $? -ne 0 ] ; then
        # If it's not a tar archive, try to run it straight up
        execute_f .tmp-file
    else
        execute_f .tmp
    fi
    
    # Clean up any files we may have downloaded...
    rm -rdf .tmp .tmp-file
    # And shift off the latest
    shift 1
done
