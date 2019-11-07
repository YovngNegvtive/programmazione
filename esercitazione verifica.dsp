import("stdfaust.lib");

envelop  = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
panpot = hslider ("[01] Panpot [style:knob]", 0.5, 0 , 1 , 0.1 );
fader = vslider ("[02] Gain [style:knob]", -70. , -70. , +12. , 0.1 ): ba.db2linear : si.smoo ;
vmeter(x) = attach(x, envelop(x) : vbargraph("[2][unit:dB]", -70, +12));
process = _  <: * (1-panpot) , * (panpot)  : hgroup ("[02]" , *(fader) , * (fader)  : vmeter, vmeter) ;
