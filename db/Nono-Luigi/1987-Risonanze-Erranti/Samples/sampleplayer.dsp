import("stdfaust.lib");

gate = button("[1] Hold me down to play sound");

inc = 1;

play(i) = i, _ ~ (*(gate) : + (inc * gate)); // play i'th soundfile

sampsel = nentry("[0] Sample Selector
                    [style:menu{
                    'BONGOS DITA':0;
                    'BONGOS FELTRO-MARIMBA':1;
                    'BONGOS FELTRO':2;
                    'BONGOS GOMMA-DURA':3;
                    'BONGOS LEGNO':4;
                    'BONGOS PALMI':5;
                    'BONGOS POLPASTRELLI':6;
                    'BONGOS RATTAN-SLAP':7;
                    'BONGOS UNGHIE':8;
                    'CSG FELTRO':9;
                    'CSG LEGNO CORPO':10;
                    'CSG LEGNO PUNTA':11;
                    'CSG LEGNO STRUSCIATO':12;
                    'CSP FELTRO':13;
                    'CSP LEGNO CORPO':14;
                    'CSP LEGNO PUNTA':15;
                    'CSP LEGNO STRUSCIATO':16}]", 0, 0, 17, 1) : int;

process = play(sampsel) : soundfile("Sounds[url:{'BONGOS-DITA.wav';
                                                 'BONGOS-FELTRO-MARIMBA.wav';
                                                 'BONGOS-FELTRO.wav';
                                                 'BONGOS-GOMMA-DURA.wav';
                                                 'BONGOS-LEGNO.wav';
                                                 'BONGOS-PALMI.wav';
                                                 'BONGOS-POLPASTRELLI.wav';
                                                 'BONGOS-RATTAN-SLAP.wav';
                                                 'BONGOS-UNGHIE.wav';
                                                 'CSG-FELTRO.wav';
                                                 'CSG-LEGNO-CORPO.wav';
                                                 'CSG-LEGNO-PUNTA.wav';
                                                 'CSG-LEGNO-STRUSCIATO.wav';
                                                 'CSP-FELTRO.wav';
                                                 'CSP-LEGNO-CORPO.wav';
                                                 'CSP-LEGNO-PUNTA.wav';
                                                 'CSP-LEGNO-STRUSCIATO.wav'}]",2) : !,!,_,_;


// or soundfile("label[url:{'path1';'path2';'path3'}]", n);
