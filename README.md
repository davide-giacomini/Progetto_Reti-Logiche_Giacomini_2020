# Progetto_Reti-Logiche_Giacomini_2020
Scopo del progetto è quello di implementare un componente hardware descritto in VHDL in grado di risolvere un problema che consiste nel decodificare un indirizzo a partire da un insieme di working-zone. L'utilità di questo metodo può essere approfondita leggendo l'articolo originale:  [E. Musoll, T. Lang and J. Cortadella, "Working-zone encoding for reducing the energy in microprocessor address buses," in IEEE Transactions on Very Large Scale Integration (VLSI) Systems, vol. 6, no. 4, pp. 568-572, Dec. 1998.](https://ieeexplore.ieee.org/abstract/document/736129?casa_token=J8ltMoMG2WQAAAAA:GFnsfTBQhZY8IlAZtM3jDNuCrixBVRiANbrbyG1-LlqTuzeL0OurT67-3cvO0KXuptiQM4obtw).

## Definizione del Problema
Viene dato un insieme di intervalli (detti appunto working-zone), e un indirizzo da trasmettere. Bisogna confrontare l'indirizzo con le working-zone e decidere successivamente come decodificarlo. Maggiori dettagli definiti nelle [specifiche complete](https://github.com/davide-giacomini/Progetto_Reti-Logiche_Giacomini_2020/blob/main/specifications.pdf)

## Implementazione
L'[implementazione](https://github.com/davide-giacomini/Progetto_Reti-Logiche_Giacomini_2020/blob/main/src/project_giacomini.vhd) del componente consiste principalmete nella realizzazione di una macchina a stati in grado di determinare per ciascuno degli indirizzi l'appartenenza o meno alla working-zone.

La valutazione dell'appartenenza viene valutata ciclicamente attraverso un algoritmo sequenziale, come spiegato ed illustrato nella dedicata [documentazione](https://github.com/davide-giacomini/Progetto_Reti-Logiche_Giacomini_2020/blob/main/documentation.pdf).

## Test Bench
L'insieme di test utilizzato per la realizzazione del componente è contenuto all'interno della directory __[test benches](https://github.com/davide-giacomini/Progetto_Reti-Logiche_Giacomini_2020/tree/main/src/test_benches),__ in cui ciascun caso è individuato da un nome caratteristico.

L'insieme di test è stato realizzato a partire da quello della specifica andando a identificare i casi che spingono l'esecuzione verso condizioni critiche così da verificare la completa correttezza del sistema, non essendo a disposizione dei test privati utilizzati per la valutazione.

I test per sforzare il componente in situazioni particolari sono:
  * [tb_in_wz.vhd](https://github.com/davide-giacomini/Progetto_Reti-Logiche_Giacomini_2020/blob/main/src/test_benches/tb_in_wz.vhd): utile a verificare l'appartenenza ad una working-zone qualsiasi
  * [tb_no_wz.vhd](https://github.com/davide-giacomini/Progetto_Reti-Logiche_Giacomini_2020/blob/main/src/test_benches/tb_no_wz.vhd): utile a verificare la non appartenenza ad alcuna working-zone
  * [tb_rst_asincrono.vhd](https://github.com/davide-giacomini/Progetto_Reti-Logiche_Giacomini_2020/blob/main/src/test_benches/tb_rst_asincrono.vhd): utile a verificare la risposta al sistema a fronte di reset asincroni
  
Infine per poter garantire una maggiore robustezza sono stati utilizzati anche numerosi test randomici andando a leggere da file, in modo tale da cercare di coprire tutti i possibili cammini di esecuzione della macchina a stati.
I file sono disponibili nella directory [15_to_1.5M_cases](https://github.com/davide-giacomini/Progetto_Reti-Logiche_Giacomini_2020/tree/main/src/test_benches/15_to_1.5M_cases) e per essere utilizzati viene utilizzato il test bench [tb_auto.vhd](https://github.com/davide-giacomini/Progetto_Reti-Logiche_Giacomini_2020/blob/main/src/test_benches/tb_auto.vhd). Per utilizzare correttamente questo test bench, sono stati commentate tre righe all'interno del file *.vhd*, in cui viene indicato dove modificare il path per poter leggere e scrivere da file. Tutto ciò che è scritto tra parentesi quadre deve essere modificato. I casi passati e non passati verranno poi stampati all'interno di *15_to_1.5M_cases/out* e denominati *non_passati.txt* e *passati.txt*. 

## Sviluppatore
[Davide Giacomini](https://github.com/davide-giacomini)
