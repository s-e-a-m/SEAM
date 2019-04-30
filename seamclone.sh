#!/usr/bin/env bash

# use it by terminal typing:
# bash seampull.sh

cd ..

git clone https://github.com/s-e-a-m/fc1987nlre.git
git submodule update --init

git clone https://github.com/s-e-a-m/faust-code.git
git submodule update --init

git clone https://github.com/s-e-a-m/maxmsp.git
git submodule update --init

git clone https://github.com/s-e-a-m/References.git
git submodule update --init

git clone https://github.com/s-e-a-m/s-e-a-m.github.io.git
git submodule update --init

say ciao belli
