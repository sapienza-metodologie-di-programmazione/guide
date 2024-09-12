#let darkred = rgb(192, 0, 0)
#let darkgreen = rgb(4, 128, 31)
#let darkblue = rgb(3, 50, 138)
#let darkpurple = rgb(102, 2, 122)
#let darkcyan = rgb(7, 116, 138)
#let background = rgb(251, 251, 251)

#set text(10pt, font: "Cascadia Code")
#set underline(offset: 3pt)
#set page(margin: 1.5cm)

#show link: it => underline[#text(navy)[#it]]
#show heading.where(level: 1): it => {
  text(size: 17pt)[#it.body]
  [ #v(10pt) ]
}
#show heading.where(level: 2): it => {
  text(size: 15pt)[#it.body]
  [ #v(10pt) ]
}
#show heading.where(level: 3): it => {
  text(size: 12pt)[#it.body]
  [ #v(10pt) ]
}

#show heading.where(level: 4): it => {
  it.body
  [ #v(10pt) ]
}

#let note(body) = [
  #block(
    fill: rgb(250, 250, 255),
    width: 100%,
    inset: 10pt,
    stroke: rgb(240, 240, 255),
    [
      #underline(text(blue)[ℹ Nota]) \
      #v(2pt)
      #body
    ]
  )
]

#let view(body) = [ 
  #block(
    fill: background,
    width: 100%,
    inset: 10pt,
    stroke: silver,
    body
  )
]


#let imageonleft(lefttext, rightimage, bottomtext: none, marginleft: 0em, margintop: 0em) = {
  set par(justify: true)
  grid(columns: 2, column-gutter: 2em, lefttext, rightimage)
  set par(justify: false)
  block(inset: (left: marginleft, top: -margintop))
}

#let imageonright(rightext, leftimage,bottomtext: none, marginleft: 0em, margintop: 0.5em)  = {
  set par(justify: true)
  grid(columns: 2, column-gutter: 0em, leftimage, rightext)
  set par(justify: false)
  block(inset: (left: marginleft, top: -margintop), bottomtext) }


#show raw.where(block: true): view

#align(center, text(17pt)[ *Un approccio pratico a #text(darkred)[Git]* ])

\

Questa guida si propone di fornire i concetti base per capire il funzionamento del software per il controllo di versione *Git* e facilitarne l'utilizzo durante la realizzazione di progetti in singolo o in gruppo, con esempi pratici e riferimenti alla piattaforma *GitHub*.

\

#outline(title: [Sommario], indent: 1.5em)


#pagebreak()


= Cos'è #text(darkred)[Git]?


Quante volte ti è capitato di cambiare il codice di una classe Java con l'intento di migliorarlo per poi finire solo col creare problemi alle funzionalità pre-esistenti? Con Git avresti potuto facilmente far finta di nulla e tornare velocemente alla versione precedente del progetto, senza dover cercare e correggere a mano tutte le linee di codice modificate.

\


#figure(
  image("assets/distributed.png", width: 40%),
  caption: [\
  Git è un #link("https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control")[VCS distribuito], ogni client ha l'intero backup di tutti i dati],
)  <distributed>
\

Git infatti è un #text(darkcyan)[VCS] (_Version Control System_), ovvero, in parole povere, un software in grado di tenere traccia delle modifiche eseguite su un insieme di file. Lavorando ad un progetto è quindi possibile mantentere nel tempo la storia delle sue versioni passate e, in caso di necessità, recuperarle.

\

Inoltre Git facilita la #text(darkcyan)[collaborazione] di più sviluppatori allo stesso progetto, offrendo meccanismi per sincronizzare le modifiche su file conservati in un server remoto condiviso. Poiché Git è un #text(darkcyan)[sistema distribuito] (@distributed), ogni collaboratore avrà una copia locale di tutte le versioni del progetto, riducendo il rischio di perdite di dati.

\

== Git vs #text(darkblue)[GitHub]


#imageonright(figure(
  image("assets/git-github.png", width: 80%, fit:"stretch"),

), text([Contrariamente a quanto spesso si pensa, Git e GitHub #underline("non") sono la stessa cosa. Come detto sopra, Git è un VCS, mentre #link("https://github.com/")[GitHub] è una piattaforma online che offre un'interfaccia grafica alle funzionalità di Git (non è l'unica ma sicuramente la più utilizzata).
  ]),   )

#text(darkcyan)[GitHub] è di fatto un sito su cui creare account, creare e conservare progetti, gestire le modifiche su di essi e le collaborazioni con altri utenti; spesso funge da "magazzino" in cui trovare software da scaricare.
 
 Lavorando in gruppo, il progetto condiviso sarà ospitato da GitHub, su cui ognuno potrà sincronizzare, tramite specifiche operazioni Git, le modifiche realizzate prima sulla propria copia locale.

 \


= Struttura dati di Git

Per poter capire veramente Git (e usarlo più facilmente) è necessario conoscere il #text(darkcyan)[modello a grafo] (non ti spaventare, è abbastanza intuitivo) da esso utilizzato per mantenere i dati.

\

== Oggetti Git e DAG

Git memorizza la storia delle versioni di un insieme di file e cartelle come una sequenza di "#text(darkcyan)[snapshots]" (o  "istantanee") della cartella principale (alla radice del progetto) al momento corrente. I file vengono denominati #text(darkcyan)[_blob_] mentre le cartelle sono chiamate #text(darkcyan)[_tree_]. Esse mappano i nomi di file e cartelle da loro contenute ai corrispondenti blobs e trees (@datamodel).

#figure(
  image("assets/data-model-1.png", width: 50%),
  caption: [Illustrazione concettuale del #link("https://git-scm.com/book/en/v2/Git-Internals-Git-Objects")[modello dei dati] di Git: la cartella top-level contiene due file ("README" e "Rakefile") e una sotto-cartella "lib", che a sua volta contiene un file "simplegit.rb"],
)  <datamodel>

\


I vari snapshots del progetto sono rappresentati da oggetti chiamati #text(darkcyan)[_commits_] e vengono organizzati in un #text(darkcyan)[_DAG_] (grafo diretto e aciclico, @datamodel2) che semplicemente associa con una freccia ogni commit ai suoi "genitori", cioè i commits immediatamente precedenti (il commit può avere più di un genitore perché, ad esempio, come sarà spiegato più avanti, è possibile fondere due rami paralleli di sviluppo tramite un'operazione di _merge_). 

\

Commits, blobs e trees formano gli oggetti (#text(darkcyan)[_objects_]) principali utilizzati da Git nel suo modello dati.

\

#figure(
  image("assets/data-model-2.png", width: 70%),
  caption: [\
  Illustrazione del #link("https://learn.microsoft.com/en-us/archive/msdn-magazine/2017/june/devops-git-internals-for-visual-studio-developers")[DAG] di Git: i commits sono i nodi (o vertici) del grafo, mentre gli archi legano i commit ai propri genitori. Un commit con più figli è legato a un'azione di _branching_, mentre un commit con più genitori corrisponde ad un'azione di _merging_],
)  <datamodel2>

\

I commit sono #underline("immutabili"): non si possono modificare. Quando si cambia qualcosa nei file di un progetto si possono creare nuovi commit da aggiungere al DAG, ma senza interferire con quelli pre-esistenti. Oltre al riferimento ad una specifica versione del progetto (sotto forma di tree), un commit contiene meta-dati come il suo autore e un messaggio descrittivo. Se volessimo rappresentarlo con una classe Java, scriveremmo qualcosa tipo: 

```java
class Commit {
  List<Commit> genitori;
  String autore;
  String messaggio;
  Tree snapshot;
  ...
} 
```
\
Il #text(darkcyan)[_tag_] è un ulteriore tipo di oggetto Git. Esso contiene il riferimento ad un commit e viene utilizzato per annotarlo con un nome ed eventualmente un messaggio (ad esempio si usa spesso taggare i commit con nomi di versione come "_v1.0_", "_v2.0_", ecc.).

\

== Riferimenti
Per utilizzare un oggetto Git non si richiede ogni volta l'intera copia del suo contenuto in memoria ma si sfrutta il #text(darkcyan)[riferimento] all'unica copia presente nello _store_ generale degli oggetti di Git (@objectstore), identificata dal suo *hash SHA-1* (una stringa esadecimale di dimensione fissa ottenuta dall'applicazione di una funzione, detta _funzione di hash_, sull'oggetto stesso).

\

Poiché per noi umani è difficile leggere e ricordare lunghe stringhe di caratteri esadecimali, Git fornisce la possibilità di usare stringhe con nomi semplici per riferirsi a particolari oggetti nello store (ad esempio di solito si usa il nome "#text(darkcyan)[_main_]" per riferirsi all'ultimo commit del ramo principale di sviluppo del proprio progetto).

In pratica si crea una mappa da stringhe con contenuto comprensibile all'uomo a stringhe esadecimali che rappresentano gli identificativi degli oggetti (@referencestore).

Questo tipo di riferimento è #underline("mutabile"): si può riassegnare un nome semplice ad un nuovo valore esadecimale.


#figure(
  image("assets/gitdatabase.png", width: 40%),
  caption: [\
  Rappresentazione dell'#link("https://github.blog/open-source/git/gits-database-internals-i-packed-object-store/#:~:text=pack%2D9f9258a8ffe4187f08a93bcba47784e07985d999.pack-,The%20.,ID%20and%20the%20object%20content.")[object store] di Git: una tabella di oggetti dove le chiavi sono i rispettivi hash],
)  <objectstore>


#figure(
  image("assets/gitdatabase2.png", width: 80%),
  caption: [\
  Rappresentazione della tabella di riferimenti che mappa stringhe con nomi semplici a identificativi di oggetti Git],
)  <referencestore>
\

Esiste un riferimento speciale per indicare il commit corrente (quello che diventerebbe il genitore di un eventuale nuovo commit), indicato come "#text(darkcyan)[_HEAD_]": esso punta alla posizione attuale all'interno del grafo dei commits.

\

== Operazioni

La struttura a grafo di Git appena discussa può essere modificata con le *operazioni concettuali* presentate di seguito, di cui si forniranno i comandi per l'esecuzione nella sezione successiva.

\

=== Commit

L'operazione più semplice è il #text(darkcyan)[commit]: si aggiunge uno snapshot dei contenuti attuali del progetto al grafo con i commits precedenti, creando un nuovo nodo che avrà come genitore il commit puntato dal riferimento _HEAD_ al momento della creazione. Dopo l'aggiunta del nuovo commit, _HEAD_ si sposterà automaticamente su di esso: 

#imageonleft(
figure(
  image("assets/Commit-1.drawio.svg", width: 75%),
  caption: [\
  Ipotetico grafo _G_ di partenza, contenente i commit C1, C2, C3],
), figure(
  image("assets/Commit-2.drawio.svg", width: 100%),
  caption: [\
  Grafo _G_ dopo l'aggiunta del commit C4 tramite l'operazione di _commit_]))


=== Branching

Git permette di creare diversi *rami di sviluppo* tramite un'operazione di #text(darkcyan)[branching], per facilitare ad esempio il lavoro su progetti di gruppo o l'implementazione di funzionalità parallele. Nella struttura a grafo, ciò corrisponde ad osservare un nodo con più figli, ciascuno su un ramo diverso. 

Ogni ramo è identificato da un *puntatore* con nome (ad esempio "_main_"): esso specifica l'ultimo commit del ramo, cioè il punto in cui aggiungere eventuali nuovi commits per il ramo stesso.

Per poter lavorare su un ramo in particolare bisogna assicurarsi che "_HEAD_" punti su di esso, eseguendo se necessario un'operazione di #text(darkcyan)[switch] dal ramo correntemente puntato a quello desiderato.


#imageonleft(
figure(
  image("assets/Branching-1.drawio.svg", width: 80%),
  caption: [\
  Ipotetico grafo _G1_ di partenza, contenente i commit C1, C2, C3 sul ramo _main_],
), figure(
  image("assets/Branching-2.drawio.svg", width: 80%),
  caption: [\
  Grafo _G2_ ottenuto dal grafo _G1_ dopo la creazione del ramo _nuovo Ramo_ tramite operazione di _branching_]))

  #imageonleft(
figure(
  image("assets/Branching-3a.drawio.svg", width: 100%),
  caption: [\
  Grafo _G3_ ottenuto dal grafo _G2_ dopo l'aggiunta del commit C4 tramite operazione di _commit_ (l'aggiunta avviene sul ramo _main_ perché puntato da _HEAD_ in _G2_)],
), figure(
  image("assets/Branching-3b.drawio.svg", width: 100%),
  caption: [\
  Grafo _G4_ ottenuto dal grafo _G3_ dopo lo _switch_ da _main_ a _nuovoRamo_ (si sposta il puntatore _HEAD_)]))

#figure(
  image("assets/Branching-3c.drawio.svg", width: 55%),
  caption: [\
  Grafo _G5_ ottenuto dal grafo _G4_ dopo l'aggiunta del commit C5 tramite operazione di _commit_ (l'aggiunta avviene sul ramo _nuovoRamo_ perché puntato da _HEAD_ in _G4_)],
) 

\

=== Merging

=== Rebase



= Comandi #text(darkred)[git]

== Come creare un repository
== Come fare un commit
== Come recuperare le versioni precedenti del progetto
== Come connettersi a un repository remoto

= Lavorare in gruppo
== Fare branching e merge

= Usare Git e GitHub da #text(darkpurple)[Eclipse]
= Link utili