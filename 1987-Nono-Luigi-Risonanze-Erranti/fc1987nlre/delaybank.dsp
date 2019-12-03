import("stdfaust.lib");

fbgroup(x) = hgroup("Feedback", x);

fbgain1 = fbgroup(vslider("Feedback 1", 0.,0.,1.,0.1) : si.smoo);
fbgain2 = fbgroup(vslider("Feedback 3", 0.,0.,1.,0.1) : si.smoo);
fbgain3 = fbgroup(vslider("Feedback 5", 0.,0.,1.,0.1) : si.smoo);
fbgain4 = fbgroup(vslider("Feedback 7", 0.,0.,1.,0.1) : si.smoo);

process = _ <: (_+_ <: de.delay(ba.sec2samp(5.0),ba.sec2samp(5.0)), de.delay(ba.sec2samp(5.5),ba.sec2samp(5.5)))~*(fbgain1),
               (_+_ <: de.delay(ba.sec2samp(6.2),ba.sec2samp(6.2)), de.delay(ba.sec2samp(6.6),ba.sec2samp(6.6)))~*(fbgain2),
               (_+_ <: de.delay(ba.sec2samp(7.3),ba.sec2samp(7.3)), de.delay(ba.sec2samp(7.7),ba.sec2samp(7.7)))~*(fbgain3),
               (_+_ <: de.delay(ba.sec2samp(8.2),ba.sec2samp(8.2)), de.delay(ba.sec2samp(9.1),ba.sec2samp(9.1)))~*(fbgain4):
               _, ro.cross(2), _, _, ro.cross(3) : si.bus(5), ro.cross(2), _; // route the delayed signal to 1 3 2 4 5 7 8 6
