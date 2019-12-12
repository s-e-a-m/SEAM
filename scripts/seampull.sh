#!/usr/bin/env bash

# use it by terminal typing:
# bash seampull.sh

git submodule update --remote
git pull -v
cd ..

cd cs1954sks2
git pull -v
cd ..

cd faust-code
git submodule update --remote
git pull -v
cd ..

cd faust-libraries
git pull -v
cd ..

cd fc1969lais
git pull -v
cd ..

cd fc1987nlre
git pull -v
cd ..

cd fc1991lmml
git pull -v
cd ..

cd max1969lais
git pull -v
cd ..

cd maxmsp
git pull -v
cd ..

cd References
git pull -v
cd ..

cd s-e-a-m.github.io
git pull -v
cd ..

cd seam-lac2020
git pull -v
cd ..

cd snd1987nlre
git pull -v
cd ..
