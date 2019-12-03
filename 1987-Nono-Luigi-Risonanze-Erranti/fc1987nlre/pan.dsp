declare name 		"panexplorer";
declare version 	"1.0";
declare author 		"SEAM";

//-------------------------------------------------
// Panner explorer: linear / quadratic / phase
//-------------------------------------------------

import("stdfaust.lib");

envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
vmeter(x) = attach(x, envelop(x) : vbargraph("[2][unit:dB]", -70, +5));
hmeter(x) = attach(x, envelop(x) : hbargraph("[2][unit:dB]", -70, +5));

k = vslider("panner [style:knob]", 0.5, 0, 1, 0.01);
process = _ : vgroup("input", hmeter) <: _* sqrt((1-k)), _ * sqrt(k) <: _ , _ , + , - : hmeter, hmeter, hmeter, hmeter;
