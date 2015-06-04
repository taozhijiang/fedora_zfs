#!/bin/bash
destdir="./fedora/updates/22"
for arch in x86_64 noarch SRPMS
do
    pushd ${destdir}/${arch} >/dev/null 2>&1
        createrepo -d .
    popd >/dev/null 2>&1
done
