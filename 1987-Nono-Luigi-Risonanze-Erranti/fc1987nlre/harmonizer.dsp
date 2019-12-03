import("stdfaust.lib");

gstranspose(w, x, r, sig) = de.fdelay(maxDelay,d,sig)*ma.fmin(d/x,1) +
	de.fdelay(maxDelay,d+w,sig)*(1-ma.fmin(d/x,1))
with {
	maxDelay = 65536;
	i = 1 - pow(2, r/1000);
	d = i : (+ : +(w) : fmod(_,w)) ~ _;
};

harmonizer = vgroup("Pitch Shifter", gstranspose(
  hslider("window (samples)", 1000, 50, 10000, 1),
  hslider("xfade (samples)", 10, 1, 10000, 1),
  hslider("shift (cents) ", 0, -2600, +100, 0.01))
	);

process = harmonizer;
