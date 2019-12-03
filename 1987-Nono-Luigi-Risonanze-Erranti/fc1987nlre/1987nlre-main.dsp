import("stdfaust.lib");
import("../faust-libraries/seam.lib");

// ------------------------------------------------------------------------ SENDS

adel = checkbox("[01] DELAY") : si.smoo;
are4 = checkbox("[02] REVERB 4 SEC") : si.smoo;
ar80 = checkbox("[03] REVERB 10~80 SEC") : si.smoo;
ahar = checkbox("[04] HARMONIZER") : si.smoo;
aha1 = checkbox("[05] HALAPHON 1") : si.smoo;
aha2 = checkbox("[06] HALAPHON 2") : si.smoo;
aha3 = checkbox("[07] HALAPHON 3") : si.smoo;

sends = vgroup("[99]PROCESSES SENDS" , *(adel), *(are4), *(ar80), *(ahar), *(aha1), *(aha2), *(aha3)) ;

// ----------------------------------------------------------------- INSTRUMENTS

contr = vgroup("[01] CONTRALTO", chstrip <: hgroup("[90] CONTRALTO", *(fader)<: vmeter , sends)) ;
flaut = vgroup("[02] FLAUTI", chstrip <: hgroup("[90] FLAUTI", *(fader) <: vmeter , sends)) ;
btuba = vgroup("[03] TUBA", chstrip <: hgroup("[90] TUBA", *(fader) <: vmeter , sends)) ;
csard = vgroup("[04] CAMPANE SARDE", chstrip <: hgroup("[90] CAMPANE SARDE", *(fader) <: vmeter , sends)) ;
bongo = vgroup("[05] BONGOS", chstrip <: hgroup("[90] BONGOS", *(fader) <: vmeter , sends)) ;
crota = vgroup("[06] CROTALI", chstrip <: hgroup("[90] CROTALI", *(fader) <: vmeter , sends)) ;

instruments = si.bus(18) <: hgroup("[01] INPUTS", contr, flaut, btuba, csard, bongo, crota) :> si.bus(8) ;

// ----------------------------------------------------------------- ELECTRONICS
// ---------------------------------------------------------------------- DELAYS
fbgroup(x) = hgroup("Feedback Delay", x);

fbgain1 = fbgroup(vslider("Fb 1", 0.,0.,1.,0.1) : si.smoo);
fbgain2 = fbgroup(vslider("Fb 3", 0.,0.,1.,0.1) : si.smoo);
fbgain3 = fbgroup(vslider("Fb 5", 0.,0.,1.,0.1) : si.smoo);
fbgain4 = fbgroup(vslider("Fb 7", 0.,0.,1.,0.1) : si.smoo);

delbank = _ <: (_+_ <: de.delay(ba.sec2samp(5.0),ba.sec2samp(5.0)), de.delay(ba.sec2samp(5.5),ba.sec2samp(5.5)))~*(fbgain1),
               (_+_ <: de.delay(ba.sec2samp(6.2),ba.sec2samp(6.2)), de.delay(ba.sec2samp(6.6),ba.sec2samp(6.6)))~*(fbgain2),
               (_+_ <: de.delay(ba.sec2samp(7.3),ba.sec2samp(7.3)), de.delay(ba.sec2samp(7.7),ba.sec2samp(7.7)))~*(fbgain3),
               (_+_ <: de.delay(ba.sec2samp(8.2),ba.sec2samp(8.2)), de.delay(ba.sec2samp(9.1),ba.sec2samp(9.1)))~*(fbgain4):
               _, ro.cross(2), _, _, ro.cross(3) : si.bus(5), ro.cross(2), _; // route the delayed signal to 1 3 2 4 5 7 8 6

// ----------------------------------------------------------------- HALAPHON x3
// ---------------------------------- gli halaphon dovvrebbero stare in nono.lib

h1ramp = os.lf_sawpos(1.0/(hslider("[01] h1 time", 3.0, -23.0, 23.0, 0.01)));
h2ramp = os.lf_sawpos(1.0/(hslider("[01] h2 time", 3.0, -23.0, 23.0, 0.01)));
h3ramp = os.lf_sawpos(1.0/(hslider("[01] h3 time", 3.0, -23.0, 23.0, 0.01)));

h1dist = hslider("[02] h1 distance", 1, 0, 1, 0.01);
h2dist = hslider("[02] h2 distance", 1, 0, 1, 0.01);
h3dist = hslider("[02] h3 distance", 1, 0, 1, 0.01);

//gain = vslider("[1]", 0, -70, +0, 0.1) : ba.db2linear : si.smoo;

h1(v) = vgroup("Ch %v", hmeter);
h2(v) = vgroup("Ch %v", hmeter);
h3(v) = vgroup("Ch %v", hmeter);

h1meters = vgroup("h1 meters", par(i, 4, h1(i)));
h2meters = vgroup("h2 meters", par(i, 4, h2(i)));
h3meters = vgroup("h3 meters", par(i, 4, h3(i)));

hal1 = vgroup("h1", sp.spat(4, h1ramp, h1dist) : h1meters);
hal2 = vgroup("h2", sp.spat(4, h2ramp, h2dist) : h2meters);
hal3 = vgroup("h3", sp.spat(4, h3ramp, h3dist) : h3meters);

halaphones = hgroup("HALAPHONES", hal1, hal2, hal3 :> si.bus(4));

// ----------------------------------------------------------------- HARMONIZER

harmonizer = vgroup("HARMONIZER", ef.transpose(
  hslider("window (samples)", 1000, 50, 10000, 1),
  hslider("xfade (samples)", 10, 1, 10000, 1),
  hslider("shift (cents) ", 0, -2600, +100, 0.01))
	);

// ---------------------------------------------------------------- METER BRIDGE

meterbridge = vgroup("[02] METER BRIDGE",
              vgroup("[01] DIRECT", hmeter),
              vgroup("[02] DELAY", hmeter),
              vgroup("[03] REVERB 10~80 sec", hmeter),
              vgroup("[04] REVERB 4 sec", hmeter),
              vgroup("[05] HARMONIZER", hmeter),
              vgroup("[06] HALAPHON 1", hmeter),
              vgroup("[07] HALAPHON 2", hmeter),
              vgroup("[08] HALAPHON 3", hmeter));

// -----------------------------------------------------------------  DIRECT

direct = _;

// ---------------------------------------------------------------- REV4

reverb4(N,NB,BBSO) = _ : rinmeter <: re.fdnrev0(MAXDELAY,delays,BBSO,freqs,durs,loopgainmax,nonl) :> *(gain), *(gain) : routmeter, routmeter
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
	pathmin = path_group(hslider("[1] min acoustic ray length [unit:m] [scale:log]", 12.0, 0.1, 63, 0.1));
	pathmax = path_group(hslider("[2] max acoustic ray length [unit:m] [scale:log]", 63.0, 0.1, 63, 0.1));
	durvals(i) = t60_group(nentry("[%i] %i [unit:s]",ba.take(i+1,defdurs), 0.1, 100, 0.1));
  durs = par(i,NB,durvals(NB-1-i));
	freqvals(i) = freq_group(nentry("[%i] Band %i upper edge in Hz [unit:Hz]",ba.take(i+1,deffreqs), 100, 10000, 1));
  freqs = par(i,NB-1,freqvals(i));
	delays = de.prime_power_delays(N,pathmin,pathmax);
	gain = hslider("[3] Output Level (dB) [unit:dB][tooltip: Output scale factor]", -40, -70, 20, 0.1) : ba.db2linear;
  rinmeter(x) = attach(x, envelop(x) : hbargraph("[00][unit:dB]", -70, +5));
  routmeter(x) = attach(x, envelop(x) : hbargraph("[99][unit:dB]", -70, +5));
  envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
	// (can cause infinite loop:) with { db2linear(x) = pow(10, x/20.0); };
};

rev4 =  _ <: reverb4(16,5,3) : _,_;

rev80 = _ <: si.bus(8);

ch1a8 = delbank, rev80 :> si.bus(8);

electronics = vgroup("[03] ELECTRONICS",
  direct,
  ch1a8,
  rev4,
  harmonizer,
  halaphones) ;

process = tgroup("PANELS", instruments : meterbridge : electronics);

vmeter(x)		= attach(x, envelop(x) : vbargraph("[02][unit:dB] Meter", -70, +5));
hmeter(x)		= attach(x, envelop(x) : hbargraph("[05][unit:dB] Meter", -70, +5));
envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;

fader	= vslider("[01] Volume", -96, -96, +12, 0.1) : ba.db2linear : si.smoo ;
