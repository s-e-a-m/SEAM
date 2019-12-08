#!/usr/bin/env bash

# use it by terminal typing:
# bash seamclull.sh

cd ..

git clone --recurse-submodules -v https://github.com/s-e-a-m/cs1954sks2.git

git clone --recurse-submodules -v https://github.com/s-e-a-m/faust-code.git

git clone --recurse-submodules -v https://github.com/s-e-a-m/faust-libraries.git

git clone --recurse-submodules -v https://github.com/s-e-a-m/fc1969lais.git

git clone --recurse-submodules -v https://github.com/s-e-a-m/fc1987nlre.git

git clone --recurse-submodules -v https://github.com/s-e-a-m/fc1991lmml.git

git clone --recurse-submodules -v https://github.com/s-e-a-m/maxmsp.git

git clone --recurse-submodules -v https://github.com/s-e-a-m/References.git

git clone --recurse-submodules -v https://github.com/s-e-a-m/s-e-a-m.github.io.git

git clone --recurse-submodules -v https://github.com/s-e-a-m/max1969lais.git

git clone --recurse-submodules -v https://github.com/s-e-a-m/snd1987nlre.git

#pull

cd SEAM
git submodule update --init --recursive
git pull -v --recurse-submodules
cd ..

cd faust-code
git submodule update --init --recursive
git pull -v --recurse-submodules
cd ..

cd faust-libraries
git submodule update --init --recursive
git pull -v --recurse-submodules
cd ..

cd cs1954sks2
git pull -v
cd ..

cd fc1969lais
git pull -v
cd ..

cd max1969lais
git pull -v
cd ..

cd fc1987nlre
git pull -v
cd ..

cd fc1991lmml
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

cd snd1987nlre
git pull -v
cd ..
