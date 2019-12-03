declare name "Michelangelo Lupone. Mobile Locale - 1991";
declare version "001";
declare author "Giuseppe Silvi";
declare copyright "Giuseppe Silvi 2019";
declare reference "giuseppesilvi.com";
declare description "Michelangelo Lupone, Mobile Locale - FLY30 Porting";

import("stdfaust.lib");

maingroup(x) = hgroup("[01] MAIN", x);

qaqf(x) = de.fdelayltv(1,writesize, poscil*(writesize), x) : *(gain) <: _,*(0),_,*(0)
  with{
    oscgroup(x) = maingroup(hgroup("[01] OSCILLATOR", x));
    poscil = oscgroup(os.oscsin(freq) : *(amp) : +(amp));
    freq = vslider("[01] QF [style:knob]", 0.1,0.1,320,0.01) : si.smoo;
    amp = vslider("[02] QA [style:knob]", 0.5,0.0,0.5,0.01) : si.smoo;
    writesize = ba.sec2samp(0.046);
    gain = oscgroup(vslider("[03] GAIN [style:knob]", 0,0,5,0.01) : si.smoo);
  };

er8comb = _ <:
  0.5*(fi.fb_comb(ma.SR, ba.sec2samp(0.087),.5,.5) + fi.fb_comb(ma.SR, ba.sec2samp(0.026),.5,.5)),
  0.5*(fi.fb_comb(ma.SR, ba.sec2samp(0.032),.5,.5) + fi.fb_comb(ma.SR, ba.sec2samp(0.053),.5,.5)),
  0.5*(fi.fb_comb(ma.SR, ba.sec2samp(0.074),.5,.5) + fi.fb_comb(ma.SR, ba.sec2samp(0.047),.5,.5)),
  0.5*(fi.fb_comb(ma.SR, ba.sec2samp(0.059),.5,.5) + fi.fb_comb(ma.SR, ba.sec2samp(0.022),.5,.5)) <:
  *(gain), *(gain), *(gain), *(gain),_,_,_,_
    with{
      gain = maingroup(hgroup("[02] ER COMB",vslider("[01] ER OUT [style:knob]", 0,0,1.5,0.01)) : si.smoo);
  };

waza = si.bus(4) :> *(0.25) <: wa, za <: _,_,_,_
  with{
    fdelgroup(x) = maingroup(hgroup("[03] FEEDBACK DELAY", x));
    tableSize = 96000; // 0.5 ma.SR at 192000
    delsize1 = ba.sec2samp(0.46) : int;
    // WA
    recIndex1 = (+(1) : %(delsize1)) ~ *(1);
    readIndex1 = 1.02246093/float(delsize1) : (+ : ma.decimal) ~ _ : *(float(delsize1)) : int;
    fdel1 = rwtable(tableSize,0.0,recIndex1,_,readIndex1);
    wa = *(wag) : ( ro.cross(2) : - : fdel1) ~ *(waf);
    // ZA
    delsize2 = ba.sec2samp(0.23) : int;
    recIndex2 = (+(1) : %(delsize2)) ~ *(1);
    readIndex2 = 0.99699327/float(delsize2) : (+ : ma.decimal) ~ _ : *(float(delsize2)) : int;
    fdel2 = rwtable(tableSize,0.0,recIndex2,_,readIndex2);
    za = *(zag) : ( ro.cross(2) : - : fdel2) ~ *(zaf);
    // WA&ZA INTERFACE
    waf = fdelgroup(vslider("[01] WA FEEDBACK [style:knob]", 0.,0.,1.0,0.01)) : si.smoo;
    wag = fdelgroup(vslider("[01] WA GAIN [style:knob]", 0.,0.,1.0,0.01)) : si.smoo;
    zaf = fdelgroup(vslider("[01] ZA FEEDBACK [style:knob]", 0.,0.,1.0,0.01)) : si.smoo;
    zag = fdelgroup(vslider("[01] ZA GAIN [style:knob]", 0.,0.,1.0,0.01)) : si.smoo;
};

input = *(ingain) : inmeter
  with{
    ingain = hslider("[00] INPUT GAIN", 0, -70, +12, 0.1) : ba.db2linear : si.smoo;
  };

lrmix = _,_; // only for writing, not for live

process = input <:
          qaqf, er8comb : si.bus(8), waza :>
          vgroup("[99] OUTPUT METERS", h1meter,h2meter,h3meter,h4meter) ; // :> lrmix ;

// METERS
envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
inmeter(x) = attach(x, envelop(x) : hbargraph("[01] INPUT METER [unit:dB]", -70, +5));
h1meter(x) = attach(x, envelop(x) : hbargraph("[01] CH 1[unit:dB]", -70, +5));
h2meter(x) = attach(x, envelop(x) : hbargraph("[02] CH 2[unit:dB]", -70, +5));
h3meter(x) = attach(x, envelop(x) : hbargraph("[03] CH 3[unit:dB]", -70, +5));
h4meter(x) = attach(x, envelop(x) : hbargraph("[04] CH 4[unit:dB]", -70, +5));
