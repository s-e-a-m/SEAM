# FIR

L'approccio fondamentale alla creazione di un processore spettrale si basa sulla combinazione di un segnale con versioni ritardate del segnale. Come base per processori più complessi, vengono inizialmente considerati un filtro passa-basso e un filtro passa-alto di base. Il design di base utilizza un'unica linea di ritardo parallela con un ritardo di un campione. Quindi, la complessità del filtro di base può essere aumentata esplorando altri processori spettrali.

Un filtro passa-basso \(LPF\) è un processore spettrale che attenua l'ampiezza delle alte frequenze lasciando passare le basse frequenze. Nella Figura 12.3 è mostrato un esempio di LPF. Qui, il segnale di ingresso non elaborato viene aggiunto insieme a un segnale di ingresso che è stato ritardato di un campione.

