#!/usr/bin/env bash

# use it by terminal typing:
# bash seampull.sh

say Will do, sir

cd ..

git clone https://github.com/s-e-a-m/fc1987nlre.git
cd fc1987nlre
git submodule update --init
cd ..
echo ""

git clone https://github.com/s-e-a-m/faust-code.git
cd faust-code
git submodule update --init
cd ..
echo ""

git clone https://github.com/s-e-a-m/maxmsp.git
cd maxmsp
git submodule update --init
cd ..
echo ""

git clone https://github.com/s-e-a-m/References.git
cd References
git submodule update --init
cd ..
echo ""

git clone https://github.com/s-e-a-m/s-e-a-m.github.io.git
cd s-e-a-m.github.io
git submodule update --init
cd ..
echo ""

say Congratulations! You have created a new element
