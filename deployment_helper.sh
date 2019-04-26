#!/bin/bash

nodes=( "$@" )
master_node=${nodes[0]}
packages=(
	'http://jenkins.deepfield.net:8080/view/Packaging%20/job/build-deeploy-debian-xenial/lastStableBuild/console'
	'http://jenkins.deepfield.net:8080/view/Packaging%20/job/pipedream-debian-build-4.1-xenial/lastStableBuild/console'
	'http://jenkins.deepfield.net:8080/view/Packaging%20/job/build-systems-debian/lastStableBuild/console'
	'http://jenkins.deepfield.net:8080/view/Packaging%20/job/build-conda-debian/lastStableBuild/console'
	)

echo "Downloading Packages..."

if [ ! -d "$DIRECTORY"]; then
	mkdir -p /tmp/packages/
fi

for package in $packages
do
	echo $package;
	deb_location="$(curl -v --header "Connection: keep-alive" $package | grep -Eio 's3.*deb$')"; # Find the s3 url from Jenkins output and download deb from s3
	aws s3 cp $deb_location /tmp/packages/;
done

echo "All packages downloaded."
