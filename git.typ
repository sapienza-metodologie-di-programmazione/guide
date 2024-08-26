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
  grid(columns: 2, column-gutter: 0em, lefttext, rightimage)
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

\
//#pagebreak()


= Cos'è #text(darkred)[Git]?


Quante volte ti è capitato di cambiare il codice di una classe Java con l'intento di migliorarlo per poi finire solo col creare problemi alle funzionalità pre-esistenti? Con Git avresti potuto facilmente far finta di nulla e tornare velocemente alla versione precedente del progetto, senza dover cercare e correggere a mano tutte le linee di codice modificate.

\


#figure(
  image("assets/distributed.png", width: 35%),
  caption: [Git è un #link("https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control")[VCS distribuito], ogni client ha l'intero backup di tutti i dati],
)  <distributed>
\

Git infatti è un *VCS* (Version Control System), ovvero, in parole povere, un software in grado di tenere traccia delle modifiche eseguite su un insieme di file. Lavorando ad un progetto è quindi possibile mantentere nel tempo la storia delle sue versioni passate e, in caso di necessità, recuperarle.

Inoltre Git facilita la *collaborazione* di più sviluppatori allo stesso progetto, offrendo meccanismi per sincronizzare le modifiche su file conservati in un server remoto condiviso. Poiché Git è un sistema distribuito (@distributed), ogni collaboratore avrà una copia locale di tutte le versioni del progetto, riducendo il rischio di perdite di dati.


== Git vs #text(darkblue)[GitHub]

Contrariamente a quanto spesso si pensa, Git e GitHub #underline("non") sono la stessa cosa. Come detto sopra, Git è un VCS, mentre #link("https://github.com/")[GitHub] è una piattaforma online che offre un'interfaccia grafica alle funzionalità di Git (non è l'unica ma sicuramente la più utilizzata).

\

#imageonleft(text([*GitHub* è di fatto un sito su cui creare account, creare e conservare progetti (_repository_), gestire le modifiche su di essi e le collaborazioni con altri utenti; spesso funge da "magazzino" in cui trovare software da scaricare. Lavorando in gruppo, il progetto condiviso sarà ospitato da GitHub, su cui ognuno potrà sincronizzare, tramite specifiche operazioni Git, le modifiche realizzate prima sulla propria copia locale. ]), figure(image("assets/git-github.png", width: 50%)))


*GitHub* è di fatto un sito su cui creare account, creare e conservare progetti (_repository_), gestire le modifiche su di essi e le collaborazioni con altri utenti; spesso funge da "magazzino" in cui trovare software da scaricare. Lavorando in gruppo, il progetto condiviso sarà ospitato da GitHub, su cui ognuno potrà sincronizzare, tramite specifiche operazioni Git, le modifiche realizzate prima sulla propria copia locale. 

= Operazioni sulla struttura dati di Git

= Comandi #text(darkred)[git]

== Come creare un repository
== Come fare un commit
== Come recuperare le versioni precedenti del progetto
== Come connettersi a un repository remoto

= Lavorare in gruppo
== Fare branching e merge

= Usare Git e GitHub da #text(darkpurple)[Eclipse]
= Link utili