import("stdfaust.lib");


vmeter(x) = attach(x, envelop(x) : vbargraph("[99] [unit:dB]", -70, +5))

with {
    envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
};

fader =  (vslider("[03] VOL", -70., -70., +12., 0.1)) : ba.db2linear : si.smoo;
panpot =  ((vslider("[02] PAN [style:knob]", 0.0, -90.0, 90.0, 0.1))+90)/180 : si.smoo; 

pmode = (nentry("[01] PAN MODE [style:menu{'Linear':0; 'exponential':1}]", 0, 0, 1, 1)) : int;

channel(c) = hgroup ("[01] CH%c",_ <: 
             * (1-panpot), * (sqrt(1-panpot)), 
             * (panpot), * (sqrt(panpot)) : 
             ba.selectn(2,pmode), 
             ba.selectn(2,pmode) : 
             * (fader), * (fader) : vmeter, vmeter);
process = hgroup ("MIXER", par(i , 8 , channel (i) )) :> _,_;

