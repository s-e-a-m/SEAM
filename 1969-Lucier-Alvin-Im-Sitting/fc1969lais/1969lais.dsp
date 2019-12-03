declare name "ALVIN LUCIER - I'M SITTING IN A ROOM (1969)";
declare version "0.1.0";
declare author "Giuseppe Silvi";
declare license "GNU-GPL-v3";
declare copyright "(c)SEAM 2019";
declare options "[midi:on]";

//-------------------------------------------------
// Alvin Lucier - I'm sitting in a room
//-------------------------------------------------

import("stdfaust.lib");

maxdel = ma.SR *(180);

gain = hslider("[1] [midi:ctrl 1]", 0, -70, +6, 0.1) : ba.db2linear : si.smoo;

B = checkbox("[1] Uncheck me after the incipit (max 180s)");
I = int(B);
R = (I-I') <= 0; // Clear
D = (+(I):*(R))~_; // Caompuite the delay time during Incipit

L = checkbox("[2] I'm Sitting... Uncheck me at the end");	//
IL = int(L); // convert button signal from float to integer

process = vgroup("[2] Input", hmeter) :
          vgroup("[1] -------> Check both boxes to start <-------", *(IL) : de.delay(maxdel, D-1)) :
          vgroup("[3] ", preeq : studioeq : *(gain) : hmeter);

//================= Environment - Tweaked from faust examples ===============
// it will be included into SEAM.lib 

hmeter(x)	= attach(x, envelop(x) : hbargraph("[2][unit:dB]", -46, +5));
vmeter(x)	= attach(x, envelop(x) : vbargraph("[2][unit:dB]", -46, +5));
envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-46)) : ba.linear2db;

preeq =  ba.bypass1(hip,fi.highpass(2,HP)) : ba.bypass1(lop,fi.lowpass(2,LP))
with{
  pre_group(x) = hgroup("Filters", x);

  hp_group(x) = pre_group(hgroup("[1] High Pass", x));
  hip = hp_group(1-checkbox("[0] Hipass [tooltip: When this is checked the Hipass filter has effect]"));
  HP = hp_group(nentry("[1] [unit:Hz]", 100, 0, 1000, 1));

  lp_group(x) = pre_group(hgroup("[2] Low Pass", x));
  lop = lp_group(1-checkbox("[0] Lowpass [tooltip: When this is checked the Lowpass filter has effect]"));
  LP = lp_group(nentry("[1] [unit:Hz]", 8000, 1000, 20000, 1));
};

studioeq = fi.low_shelf(LL,FL) : fi.peak_eq(LP1,FP1,BP1) : fi.peak_eq(LP2,FP2,BP2) : fi.high_shelf(LH,FH)
with{
  eq_group(x) = hgroup("[0] EQ",x);

  ls_group(x) = eq_group(vgroup("[1] Low Shelf",x));
	LL = ls_group(vslider("[0] Gain [unit:dB] [style:knob] [tooltip: Amount of low-frequency boost or cut in decibels]",0,-40,40,0.1));
	FL = ls_group(vslider("[1] Freq [unit:Hz] [style:knob] [scale:log] [tooltip: Transition-frequency from boost (cut) to unity gain]",200,1,5000,1));

	pq1_group(x) = eq_group(vgroup("[2] Band 1 [tooltip: Parametric Equalizer sections from filters.lib]",x));
	LP1 = pq1_group(vslider("[0] Gain 1 [unit:dB] [style:knob][tooltip: Amount of local boost or cut in decibels]",0,-40,40,0.1));
	FP1 = pq1_group(vslider("[1] Freq 1 [unit:PK] [style:knob] [tooltip: Peak Frequency in Piano Key (PK) units (A440 = 49PK)]",49,1,100,1)) : si.smooth(0.999) : ba.pianokey2hz;
	Q1  = pq1_group(vslider("[2] Q 1 [style:knob] [scale:log] [tooltip: Quality factor (Q) of the peak = center-frequency/bandwidth]",40,1,1000,0.1));

	BP1 = FP1/Q1;

  pq2_group(x) = eq_group(vgroup("[3] Band 2 [tooltip: Parametric Equalizer sections from filters.lib]",x));
	LP2 = pq2_group(vslider("[0] Gain 2 [unit:dB] [style:knob][tooltip: Amount of local boost or cut in decibels]",0,-40,40,0.1));
	FP2 = pq2_group(vslider("[1] Freq 2 [unit:PK] [style:knob] [tooltip: Peak Frequency in Piano Key (PK) units (A440 = 49PK)]",49,1,100,1)) : si.smooth(0.999) : ba.pianokey2hz;
	Q2  = pq2_group(vslider("[2] Q 2 [style:knob] [scale:log] [tooltip: Quality factor (Q) of the peak = center-frequency/bandwidth]",40,1,1000,0.1));

	BP2 = FP2/Q2;

	hs_group(x) = eq_group(vgroup("[4] High Shelf [tooltip: A high shelf provides a boost or cut above some frequency]",x));
	LH = hs_group(vslider("[0] Gain [unit:dB] [style:knob] [tooltip: Amount of high-frequency boost or cut in decibels]",0,-40,40,.1));
	FH = hs_group(vslider("[1] Freq [unit:Hz] [style:knob] [scale:log] [tooltip: Transition-frequency from boost (cut) to unity gain]",8000,20,10000,1));
};
