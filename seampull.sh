#!/usr/bin/env bash

# use it by terminal typing:
# bash seampull.sh

say Will do, sir

cd ..

cd References
git pull -v
cd ..

cd SEAM
git pull --recurse-submodules -v
cd ..

cd faust-code
git pull --recurse-submodules -v
cd ..

cd fc1987nlre
git pull -v
cd ..

cd fc1969alis
git pull -v
cd ..

cd s-e-a-m.github.io
git pull --recurse-submodules -v
cd ..

cd maxmsp
git pull --recurse-submodules -v
cd ..

say ciao belli
