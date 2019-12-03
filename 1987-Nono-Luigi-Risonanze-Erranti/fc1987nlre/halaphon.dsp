import("stdfaust.lib");

envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
vmeter(x) = attach(x, envelop(x) : vbargraph("[03][unit:dB]", -70, +5));
hmeter(x) = attach(x, envelop(x) : hbargraph("[03][unit:dB]", -70, +5));

ramp = os.lf_sawpos(1.0/(hslider("[01] time", 3.0, 0.1, 23.0, 0.01)));
distance = hslider("[02] distance", 1, 0, 1, 0.01);

gain = vslider("[1]", 0, -70, +0, 0.1) : ba.db2linear : si.smoo;

voice(v) = vgroup("Ch %v", hgroup("[2]", *(gain) : vmeter));

mixer = hgroup("mixer", par(i, 4, voice(i)));

process = _ : sp.spat(4, ramp, distance) : mixer;
