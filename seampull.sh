#!/usr/bin/env bash

# use it by terminal typing:
# bash seampull.sh

say Will do, sir

cd ..

cd References
git pull -v
cd ..

cd SEAM
git submodule update --init
git pull -v
cd ..

cd faust-code
git submodule update --init
git pull -v
cd ..

cd fc1987nlre
git pull -v
cd ..

cd fc1969alis
git pull -v
cd ..

cd s-e-a-m.github.io
git submodule update --init
git pull -v
cd ..

cd maxmsp
git submodule update --init
git pull -v
cd ..

say ciao belli
