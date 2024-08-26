#let darkred = rgb(192, 0, 0)
#let darkgreen = rgb(4, 128, 31)
#let darkblue = rgb(3, 50, 138)
#let darkpurple = rgb(102, 2, 122)
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
  caption: [Git è un #link("https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control")[VCS distribuito], ogni client ha l'intero backup di tutti i dati],
)  <distributed>
\

Git infatti è un *VCS* (Version Control System), ovvero, in parole povere, un software in grado di tenere traccia delle modifiche eseguite su un insieme di file. Lavorando ad un progetto è quindi possibile mantentere nel tempo la storia delle sue versioni passate e, in caso di necessità, recuperarle.

\

Inoltre Git facilita la *collaborazione* di più sviluppatori allo stesso progetto, offrendo meccanismi per sincronizzare le modifiche su file conservati in un server remoto condiviso. Poiché Git è un sistema distribuito (@distributed), ogni collaboratore avrà una copia locale di tutte le versioni del progetto, riducendo il rischio di perdite di dati.

\

== Git vs #text(darkblue)[GitHub]


#imageonleft(text([Contrariamente a quanto spesso si pensa, Git e GitHub #underline("non") sono la stessa cosa. Come detto sopra, Git è un VCS, mentre #link("https://github.com/")[GitHub] è una piattaforma online che offre un'interfaccia grafica alle funzionalità di Git (non è l'unica ma sicuramente la più utilizzata).
  ]), figure(
  image("assets/git-github.png", width: 80%, fit:"stretch"),

)  )

*GitHub* è di fatto un sito su cui creare account, creare e conservare progetti (_repository_), gestire le modifiche su di essi e le collaborazioni con altri utenti; spesso funge da "magazzino" in cui trovare software da scaricare.
 
 Lavorando in gruppo, il progetto condiviso sarà ospitato da GitHub, su cui ognuno potrà sincronizzare, tramite specifiche operazioni Git, le modifiche realizzate prima sulla propria copia locale.

 \


= Operazioni sulla struttura dati di Git

Per poter capire veramente Git (e usarlo più facilmente) è necessario conoscere il *modello a grafo* (non ti spaventare, è abbastanza intuitivo) da esso utilizzato per mantenere i dati.

\

== Oggetti Git e DAG

Git memorizza la storia delle versioni di un insieme di file e cartelle come una sequenza di "snapshots" (o  "istantanee") della cartella principale (alla radice del progetto) al momento corrente. I file vengono denominati *_blob_* mentre le cartelle sono chiamate *_tree_*. Esse mappano i nomi di file e cartelle da loro contenute ai corrispondenti blobs e trees (@datamodel).

#figure(
  image("assets/data-model-1.png", width: 50%),
  caption: [Illustrazione concettuale del #link("https://git-scm.com/book/en/v2/Git-Internals-Git-Objects")[modello dei dati] di Git: una cartella contiene 2 file ("README" e "Rakefile") e una sotto-cartella "lib", che a sua volta contiene un file "simplegit.rb"],
)  <datamodel>

\


I vari snapshots del progetto sono rappresentati dai *_commits_* e vengono organizzati in un *_DAG_* (grafo aciclico diretto, @datamodel2) che semplicemente associa con una freccia ogni commit ai suoi "genitori", cioè i commit immediatamente precedenti (il commit può avere più di un genitore perché ad esempio, come sarà spiegato più avanti, è possibile fondere due rami paralleli di sviluppo tramite un'operazione di _merge_). Commits, blobs e trees formano gli oggetti (*_objects_*) principali utilizzati da Git nel suo modello dati.

\

#figure(
  image("assets/data-model-2.png", width: 70%),
  caption: [\
  Illustrazione del #link("https://learn.microsoft.com/en-us/archive/msdn-magazine/2017/june/devops-git-internals-for-visual-studio-developers")[DAG] di Git: i commits sono i nodi (o vertici) del grafo, mentre gli archi legano i commit ai propri genitori. Un commit con più figli è legato a un'azione di _branch_, mentre un commit con più genitori corrisponde ad un'azione di _merge_],
)  <datamodel2>

\

I commit sono #underline("immutabili"): non si possono modificare. Quando si cambia qualcosa nei file di un progetto si possono creare nuovi commit da aggiungere al DAG, senza interferire con quelli pre-esistenti. Oltre al riferimento ad una specifica versione del progetto (sotto forma di tree), un commit contiene meta-dati come il suo autore e un messaggio descrittivo. Se volessimo rappresentarlo con una classe Java, scriveremmo qualcosa tipo: 

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

== Riferimenti


= Comandi #text(darkred)[git]

== Come creare un repository
== Come fare un commit
== Come recuperare le versioni precedenti del progetto
== Come connettersi a un repository remoto

= Lavorare in gruppo
== Fare branching e merge

= Usare Git e GitHub da #text(darkpurple)[Eclipse]
= Link utili