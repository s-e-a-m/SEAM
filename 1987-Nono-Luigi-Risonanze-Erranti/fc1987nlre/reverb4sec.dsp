import("stdfaust.lib");

envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
vmeter(x) = attach(x, envelop(x) : vbargraph("[03][unit:dB]", -70, +5));
inmeter(x) = attach(x, envelop(x) : hbargraph("[00][unit:dB]", -70, +5));
outmeter(x) = attach(x, envelop(x) : hbargraph("[99][unit:dB]", -70, +5));

gs_fdnrev(N,NB,BBSO) = _ : inmeter <: re.fdnrev0(MAXDELAY,delays,BBSO,freqs,durs,loopgainmax,nonl) :> *(gain), *(gain) : outmeter, outmeter
with{
	MAXDELAY = 8192; // sync w delays and prime_power_delays above
	defdurs = (3.00, 4.0, 6.5, 4.5, 2.0); // NB default durations (sec)
	deffreqs = (350, 1250, 3500, 8000); // NB-1 default crossover frequencies (Hz)

	fdn_group(x)  = vgroup("FDN REVERB", x);

	freq_group(x)   = fdn_group(hgroup("[1] Crossover Frequencies", x));
	t60_group(x)    = fdn_group(hgroup("[2] Band Decay Times (T60)", x));
	path_group(x)   = fdn_group(vgroup("[3] Room Dimensions", x));
	revin_group(x)  = fdn_group(hgroup("[4] Input Controls", x));
	nonl_group(x)   = revin_group(vgroup("[4] Nonlinearity",x));
	quench_group(x) = revin_group(vgroup("[3] Reverb State",x));

	nonl = nonl_group(hslider("[style:knob] [tooltip: nonlinear mode coupling]", 0, -0.999, 0.999, 0.001));

	loopgainmax = 1.0-0.5*quench_group(button("[1] Clear [tooltip: Hold down to clear the reverberator]"));

	pathmin = path_group(hslider("[1] min acoustic ray length [unit:m] [scale:log]
                                [tooltip: This length (in meters) determines the shortest delay-line used in the FDN reverberator. Think of it as the shortest wall-to-wall separation in the room.]",
                                12.0, 0.1, 63, 0.1));
	pathmax = path_group(hslider("[2] max acoustic ray length [unit:m] [scale:log]
                                [tooltip: This length (in meters) determines the longest delay-line used in the FDN reverberator. Think of it as the largest wall-to-wall separation in the room.]",
                                63.0, 0.1, 63, 0.1));

	durvals(i) = t60_group(nentry("[%i] %i [unit:s] [tooltip: T60 is the 60dB decay-time in seconds.]",ba.take(i+1,defdurs), 0.1, 100, 0.1));

  durs = par(i,NB,durvals(NB-1-i));

	freqvals(i) = freq_group(nentry("[%i] Band %i upper edge in Hz [unit:Hz]",ba.take(i+1,deffreqs), 100, 10000, 1));

  freqs = par(i,NB-1,freqvals(i));

	delays = de.prime_power_delays(N,pathmin,pathmax);

	gain = hslider("[3] Output Level (dB) [unit:dB][tooltip: Output scale factor]", -40, -70, 20, 0.1) : ba.db2linear;
	// (can cause infinite loop:) with { db2linear(x) = pow(10, x/20.0); };
};

process =  _ <: gs_fdnrev(16,5,3) : _,_;
