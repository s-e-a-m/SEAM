k = hslider("panner", 0.5, 0, 1, 0.01);
process = _ <: _* (1-k), _ * (k);
