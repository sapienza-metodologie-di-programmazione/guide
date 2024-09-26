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
  image("assets/Commit-1.drawio.png", width: 75%),
  caption: [\
  Ipotetico grafo _G_ di partenza, contenente i commit C1, C2, C3],
), figure(
  image("assets/Commit-2.drawio.png", width: 100%),
  caption: [\
  Grafo _G_ dopo l'aggiunta del commit C4 tramite l'operazione di _commit_]))


=== Branching

Git permette di creare diversi *rami di sviluppo* tramite un'operazione di #text(darkcyan)[branching], per facilitare ad esempio il lavoro su progetti di gruppo o l'implementazione di funzionalità in parallelo. Nella struttura a grafo, ciò corrisponde ad osservare un nodo con più figli, ciascuno su un ramo diverso. 

Ogni ramo è identificato da un *puntatore* con nome (ad esempio "_main_"): esso specifica l'ultimo commit del ramo, cioè il punto in cui aggiungere eventuali nuovi commits per il ramo stesso.

Per poter lavorare su un ramo in particolare bisogna assicurarsi che "_HEAD_" punti su di esso, eseguendo se necessario un'operazione di #text(darkcyan)[switch] dal ramo correntemente puntato a quello desiderato.


#imageonleft(
figure(
  image("assets/Branching-1.drawio.png", width: 80%),
  caption: [\
  Ipotetico grafo _G1_ di partenza, contenente i commit C1, C2, C3 sul ramo _main_],
), figure(
  image("assets/Branching-2.drawio.png", width: 80%),
  caption: [\
  Grafo _G2_ ottenuto dal grafo _G1_ dopo la creazione del ramo _nuovo Ramo_ tramite operazione di _branching_]))

  #imageonleft(
figure(
  image("assets/Branching-3.drawio.png", width: 100%),
  caption: [\
  Grafo _G3_ ottenuto dal grafo _G2_ dopo l'aggiunta del commit C4 tramite operazione di _commit_ (l'aggiunta avviene sul ramo _main_ perché puntato da _HEAD_ in _G2_)],
), figure(
  image("assets/Branching-4.drawio.png", width: 100%),
  caption: [\
  Grafo _G4_ ottenuto dal grafo _G3_ dopo lo _switch_ da _main_ a _nuovoRamo_ (si sposta il puntatore _HEAD_)]))

#figure(
  image("assets/Branching-5.drawio.png", width: 55%),
  caption: [\
  Grafo _G5_ ottenuto dal grafo _G4_ dopo l'aggiunta del commit C5 tramite operazione di _commit_ (l'aggiunta avviene sul ramo _nuovoRamo_ perché puntato da _HEAD_ in _G4_)],
) 

\

=== Merging

L'operazione di #text(darkcyan)[merging] può essere considerata quasi "inversa" a quella di _branching_, in quanto permette di fondere insieme rami diversi, unendo i cambiamenti da essi apportati ai file del progetto. Talvolta ciò dà origine a un nodo con più genitori nel grafo dei commits. Il _merge_ può essere utilizzato, ad esempio, per ritornare ad un unica linea di sviluppo dopo aver testato e messo insieme le funzionalità implementate in precedenza su rami paralleli.

Quando si vuole fondere un ramo _B_ in un ramo _A_ il cui ultimo commit si trova sul percorso a ritroso dall'ultimo commit di _B_ alla radice del grafo (cioè se il commit di _A_ è un antenato del commit di _B_), Git esegue il _merge_ semplicemente spostando il puntatore del ramo _A_ sull'ultimo commit di _B_ (questo procedimento è denominato "#text(darkcyan)[_fast-forward_]"):

#imageonleft(
figure(
  image("assets/Merging-1.drawio.png", width: 100%),
  caption: [\
 Ipotetico grafo di partenza _G_, con rami _A_, _B_ e _C_ (il ramo _A_ è correntemente selezionato)],
), figure(
  image("assets/Merging-2.drawio.png", width: 100%),
  caption: [\
  Grafo _G_ dopo il _merging_ di _B_ in _A_ tramite _fast-forward_: il puntatore del ramo _A_ viene spostato sul commit puntato dal ramo _B_]))

Se invece si desidera fondere due rami i cui ultimi commits sono su linee di sviluppo divergenti (cioè se nessuno dei due commit è antenato dell'altro), Git esegue una fusione dei due commits e del loro antenato comune più recente, generando un nuovo commit che avrà come genitori i commits puntati dai rami fusi.

Se però si tenta di fondere due rami divergenti in cui è stata modificata la stessa parte di uno stesso file del progetto in modi diversi, Git non potrà eseguire la fusione automaticamente e chiederà all'utente di risolvere manualmente i conflitti generati (#text(darkcyan)[_merge conflicts_]), scegliendo quali modifiche mantenere e quali eliminare.

#imageonleft(
figure(
  image("assets/Merging-3.drawio.png", width: 80%),
  caption: [\
 Ipotetico grafo di partenza _G_, con rami _A_ e _B_ (il ramo _A_ è correntemente selezionato)],
), figure(
  image("assets/Merging-4.drawio.png", width: 100%),
  caption: [\
  Grafo _G_ dopo il _merging_ di _B_ in _A_ e la generazione del _merge commit_ C6 tramite la fusione di C3, C4 e C5]))

=== Rebasing

Un'operazione alternativa al _merging_ è il #text(darkcyan)[rebasing], che consiste nel replicare i cambiamenti apportati al progetto da un ramo di sviluppo _A_ a partire dall'ultimo commit di un ramo _B_, "spostando" il ramo _A_ in modo tale da accodarsi a _B_:

#imageonleft(
figure(
  image("assets/Merging-3.drawio.png", width: 80%),
  caption: [\
 Ipotetico grafo di partenza _G_, con rami _A_ e _B_ (il ramo _A_ è correntemente selezionato)],
), figure(
  image("assets/Rebasing.drawio.png", width: 100%),
  caption: [\
  Grafo _G_ dopo il _rebasing_ di _A_ su _B_ e la generazione del _commit_ C4' tramite la fusione di C3, C4 e C5]))

  
Il commit finale risultante dal _rebasing_ include una fusione del contenuto del primo antenato comune tra i rami _A_ e _B_ e dei loro rispettivi ultimi commits, quindi il risultato è lo stesso che si otterrebbe con un _merge_. Ciò che cambia è la forma del grafo, cioè della *storia delle versioni* del progetto: nel _merge_ appare un commit di fusione come un nodo con più genitori, nel _rebase_ la storia è lineare e ordinata, facendo apparire le modifiche come se fossero avvenute in modo sequenziale, nonostante siano state in realtà introdotte in parallelo.

\

= Comandi #text(darkred)[git]

Di seguito vengono illustrati alcuni comandi per usare Git da terminale ed eseguire, tra le varie azioni, anche le operazioni presentate nella sezione precedente.

Per inziare, installare Git (#link("https://git-scm.com/downloads")[pagina download]) e verificare da linea di comando (su un terminale di sistema) che l'installazione sia andata a buon fine, usando il comando #text(darkred)[`git --version`] per visualizzare la versione di Git presente sul proprio computer.



#(
  image("assets/Screenshot-git-v.png", width: 70%)
) 

\
Per ottenere informazioni sui comandi Git esistenti è sempre possibile usare #text(darkred)[`git --help`], mentre #text(darkred)[`git help`] `nome_comando` fornisce la documentazione per il comando `nome_comando`.

== Creare un repository

Un #text(darkcyan)[repository] Git è un deposito in memoria per gli oggetti e i riferimenti Git (spiegati nel capitolo precedente) del proprio progetto.


Si può creare un repository a partire da una *cartella sul filesystem locale* e abilitare così il controllo di versione Git su di essa: posizionarsi nella cartella scelta ed eseguire il comando #text(darkred)[`git init`]. 


#(
  image("assets/Screenshot-git-init.png", width: 90%)
) 

Ciò genera una nuova sotto-cartella nascosta, denominata "*.git*", contenente i file necessari per mantenere il nuovo repository.

In alternativa è possibile ottenere un repository locale clonando un *repository pre-esistente*, ad esempio da GitHub, ma di questo si parla in una apposita sezione successiva.

\


== Fare un commit

Una volta creato un repository, si può scegliere di memorizzare nella storia delle versioni del progetto i cambiamenti apportati ad uno o più file nella cartella considerata. Git, infatti, mette a disposizione una #text(darkcyan)[staging area] (@staging), cioè una zona di memoria temporanea per selezionare i file che si desidera includere nel prossimo commit. 

#figure(
  image("assets/git_staging_area.png", width: 70%),
  caption: [\
  Rappresentazione delle tre #link("https://git-scm.com/book/en/v2/Getting-Started-What-is-Git%3F#")[sezioni principali di un progetto Git]: la cartella di lavoro del progetto (_working directory_), la _staging area_, dove è possibile selezionare alcuni file dalla working directory ("_stage fixes_") e la cartella .git (il _repository_), dove vengono salvati i file presenti nella staging area al momento del _commit_]
) <staging>

\


In generale, un file di un progetto con controllo di versione viene definito "*_untracked_*" ("non tracciato") se non fa parte dell'ultimo snapshot del progetto e non è incluso nella staging area, "*_tracked_*"" altrimenti.

Un file _tracked_ può trovarsi negli stati:

- "*_modified_*": il file è stato modificato ma i cambiamenti non sono ancora stati salvati nel repository Git;

- "*_staged_*": il file è stato modificato e incluso nella _staging area_ (ovvero è tra i file pronti per essere salvati nel repository con il prossimo commit);

- "*_unmodified_*" o "*_committed_*": il file è al sicuro, salvato nel repository.

\

#figure(
  image("assets/file-status.png", width: 80%),
  caption: [\
  Rappresentazione degli #link("https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository")[stati di un file] in un repository Git]
) 

\

Il comando #text(darkred)[`git status`] permette di visualizzare lo stato della cartella di lavoro (cioè gli stati dei file in essa contenuti) e il contenuto della staging area. Di seguito un esempio con un repository ancora senza commit e una cartella di lavoro contenente tre nuovi file di testo ("testoA.txt", "testoB.txt", "testoC.txt") non inclusi nella staging area (quindi in stato _untracked_):

#(
  image("assets/git-status-1.png", width: 90%)
) 

\

Con #text(darkred)[`git add`] `"nome_file"` si può aggiungere il file con nome _nome_file_ all'area di staging.

#(
  image("assets/git-add-1.png", width: 80%)
) 

\

Scrivendo #text(darkred)[`git add`] `.`, invece, si selezionano automaticamente tutti i file della cartella di lavoro per l'inclusione nella staging area.

#(
  image("assets/git-add-2.png", width: 80%)
) 

\

Tramite il comando #text(darkred)[`git commit`] `-m "messaggio"` si genera un commit contenente le versioni correnti dei file nella staging area. Esso avrà descrizione testuale _messaggio_ e un hash esadecimale identificativo. Il commit corrisponde a un nodo nel grafo della struttura dati Git, posizionato sul ramo selezionato (nell'esempio seguente il ramo "_master_", l'unico presente):

#(
  image("assets/git-commit.png", width: 90%)
)

\

Per visualizzare la storia delle versioni del progetto come un grafo di commits si può usare #text(darkred)[`git log --graph`]. Per l'esempio è stato usato un repository con 3 commits sullo stesso ramo (_master_), quindi vengono visualizzati in un'unica sequenza verticale, dal più recente (puntato da _HEAD_) al più vecchio:

#(
  image("assets/git-log-1.png", width: 90%)
)

\

== Recuperare le versioni precedenti del progetto

Mettiamo caso di aver eseguito diverse operazioni di commit sul repository Git del nostro progetto e di renderci conto ad un certo punto di voler "annullare" le ultime modifiche e tornare ad una versione passata. Come si fa?

Il comando #text(darkred)[`git checkout`] `id_commit` permette di selezionare un commit dalla storia delle versioni del progetto tramite il suo codice esadecimale identificativo `id_commit` (che può essere visualizzato con `git log`), muovendo il riferimento _HEAD_ su di esso. Nell'esempio viene scelto il secondo di una serie di tre commits sullo stesso ramo:

#(
  image("assets/git-checkout-commit.png", width: 100%)
)

\

Se il commit selezionato non è l'ultimo commit di un ramo di sviluppo, l'operazione appena descritta genera una situazione segnalata da Git come #text(darkcyan)[ _detached HEAD state_] (@detached-head), in cui eventuali nuovi commits non verrebbero associati a nessun ramo e sarebbero perciò difficili da trovare in futuro (si dovrebbero ricordare a memoria i loro codici hash).

#figure(
  image("assets/git-detached-head.png", width: 90%),
  caption: [\
  Esempio di #link("https://inmachineswetrust.com/posts/git-deep-dive-checkout/")[detached HEAD state]: è stato selezionato un commit (C1) che non è posizionato alla fine di alcun ramo di sviluppo]
) <detached-head>

\

Per uscire dallo stato di _detached head_:

- se si desidera continuare a lavorare sul commit corrente, si può creare un nuovo ramo, in modo che i commits seguenti siano associati ad esso;

- se si vuole abbandonare il commit corrente senza modifiche, si può tornare ad un ramo pre-esistente.

\

La creazione e gestione dei rami di sviluppo è spiegata nella sezione seguente.

\

== Creare e unire rami di sviluppo
Il comando  #text(darkred)[`git branch`] permette di visualizzare i rami presenti nel proprio progetto Git. 

#(
  image("assets/git-branch.png", width: 70%)
)

\

Uno dei modi per creare un nuovo ramo è utilizzare #text(darkred)[`git branch`] `nome_ramo`. Per poter lavorare su di esso (cioè far sì che i commits seguenti ne facciano parte) sarà necessario selezionarlo con #text(darkred)[`git checkout`] `nome_ramo`, facendo sì che il riferimento _HEAD_ venga spostato su di esso.

#(
  image("assets/git-branch-2.png", width: 80%)
)

Un'alternativa è #text(darkred)[`git checkout`] `-b nome_ramo`, che crea un nuovo ramo e lo seleziona in un unico passaggio.

#(
  image("assets/git-branch-3.png", width: 80%)
)

\

Nel momento in cui si decide di unire due rami di sviluppo con un'operazione di _merging_, è possibile selezionare un ramo "_target_" tramite `git checkout` e usare il comando #text(darkred)[`git merge`] `nome_ramo`, dove `nome_ramo` identifica un ramo "_source_" da fondere in _target_: sarà il riferimento del ramo _target_ ad essere aggiornato dopo il _merge_ per includere i dati provenienti da entrambi i rami.

Nell'esempio, il ramo _ramoA_ viene scelto come target in cui fondere il ramo _ramoB_.

#(
  image("assets/git-merge.png", width: 95%)
)

\


Se invece si opta per l'unione dei rami tramite _rebasing_, ci si può posizionare sul ramo che si desidera "spostare" (nell'esempio, il ramo _ramoB_) tramite `git checkout`, e digitare #text(darkred)[`git rebase`] `nome_ramo`, dove `nome_ramo` è il ramo a cui "appendere" il risultato del _rebase_ (nell'esempio, il ramo _ramoA_).

#(
  image("assets/git-rebase.png", width: 85%)
)

=== Risolvere merge conflicts
Quando si tenta di unire (con _merge_ o _rebase_) rami che hanno apportato *modifiche diverse* nella stessa riga in uno *stesso file* del progetto, si incorre in dei _merge conflicts_. Se si esegue #text(darkred)[`git status`], viene segnalata la presenza dei conflitti e vengono indicati i file interessati. 

Nell'esempio seguente, si prova a fondere un ramo _ramoB_ in un ramo _ramoA_, ma entrambi hanno cambiato la prima riga di un file di testo "_testoA.txt_":

#(
  image("assets/git-merge-conflict-1.png", width: 100%)
)

\

Per risolvere un merge conflict su un file `nome_file` si può:

- forzare il _merge_ a mantenere solo le modifiche apportate dal ramo selezionato (nell'esempio _ramoA_) usando #text(darkred)[`git checkout`] `--ours nome_file`, #text(darkred)[`git add`] `nome_file` e #text(darkred)[`git commit`] `-m "messaggio"`;

- forzare il _merge_ a mantenere solo le modifiche apportate dal ramo che si sta fondendo (nell'esempio _ramoB_), usando #text(darkred)[`git checkout`] `--theirs nome_file`, #text(darkred)[`git add`] `nome_file` e #text(darkred)[`git commit`] `-m "messaggio"`;

- modificare manualmente il contenuto del file `nome_file`, in modo da poter integrare i cambiamenti dai due rami. Quando si verifica un merge conflict, il contenuto dei file interessati include entrambe le versioni dei rami coinvolti dal merging: Git delimita con "<<<<<<<" e "======="" la versione del ramo selezionato e con "=======" e ">>>>>>>" quella del ramo che si sta fondendo. Una volta scelte le modiche da tenere ed eliminati i delimitatori, si può procedere con #text(darkred)[`git add`] `nome_file` e #text(darkred)[`git commit`] `-m "messaggio"` per completare il _merge_.

\

Nell'esempio, si risolve un merge conflict modificando manualmente il contenuto del file "_testoA.txt_":

#imageonleft(
figure(
  image("assets/file-merge-conflict-1.png", width: 65%),
  caption: [\
  Contenuto del file "_testoA.txt_" dopo il tentativo di _merging_ del ramo _ramoB_ nel ramo _ramoA_ (puntato da _HEAD_) ],
), figure(
  image("assets/file-merge-conflict-2.png", width: 80%),
  caption: [\
  Contenuto del file "_testoA.txt_" dopo una modifica manuale arbitraria eseguita per risolvere il _merge conflict_]))

#(
  image("assets/git-merge-conflict-2.png", width: 100%)
)

\

== Lavorare in gruppo
I comandi finora discussi permettono di lavorare su un progetto in *locale*, cioè esclusivamente sul proprio computer. Tuttavia, a volte si desidera salvare una copia dei dati su un server per maggiore sicurezza, oppure si vuole collaborare con altre persone e condividere i file del progetto ponendoli su un repository *remoto*. Come fare?

\

=== Connettersi a un repository remoto

Si definisce #text(darkcyan)[_remote repository_] qualsiasi copia del progetto che, rispetto a quella correntemente considerata, sia ospitata in un "luogo" diverso, che può essere una zona di internet, come nel caso di un repository su GitHub, ma anche un'altra cartella del filesystem locale.

\

Il comando #text(darkred)[`git remote`] `-v` permette di visualizzare i repository remoti (un nome breve e l'URL corrispondente) salvati per il progetto. 

Per salvare esplicitamente il riferimento ad un repository remoto (che può essere _read-only_ o _read/write_ in base ai propri permessi su di esso) si può eseguire #text(darkred)[`git remote add`] `nome  url`: in questo modo si aggiunge il repository identificato dall'URL indicato e in seguito ci si potrà riferire ad esso semplicemente con il nome fornito.
#(
  image("assets/git-remote-1.png", width: 100%)
)

\

Per rimuovere un riferimento che non si intende più usare si può invece eseguire #text(darkred)[`git remote remove`] `nome`, dove `nome` è  il nome con cui si era salvato il repository remoto interessato. 

\

Spesso si usa lavorare su una copia locale di un *repository remoto pre-esistente*: il comando #text(darkred)[`git clone`] `url` *clona* il repository presente all'indirizzo `url` in una cartella nel proprio computer creata automaticamente con il nome del repository (alternativamente si può specificare la cartella dove posizionare la copia del repository usando #text(darkred)[`git clone`] `url  cartella`). Git salverà implicitamente il riferimento al repository remoto originale, denominandolo "_origin_".
#(
  image("assets/git-clone.png", width: 95%)
)

\
\
\

=== Fare pull e push

#imageonleft(figure(
  image("assets/git-push-pull.png", width: 55%, fit:"stretch"),

), text([Per sincronizzare la *copia locale* di un progetto con le modifiche eseguite sulla sua *versione in remoto* o, viceversa, propagare i cambiamenti eseguiti in locale sulla copia remota, si possono eseguire le azioni opposte di #text(darkcyan)[_pull_] ("tirare", cioè portare anche in locale l'ultima versione remota del progetto) e  #text(darkcyan)[_push_] ("spingere", cioè mandare anche in remoto l'ultima versione locale del progetto).
  ]),   )


#imageonright(figure(
  image("assets/git-pull-vs-git-fetch.png", width: 70%, fit:"stretch"),

), text([In aggiunta, esiste l'operazione di #text(darkcyan)[_fetch_] ("prendere"), che permette di visualizzare in locale le modifiche effettuate sulla versione remota del progetto, senza però sovrascrivere o interagire con i file della cartella locale di lavoro. Si può procedere così in modo cauto, decidendo solo dopo aver controllato le nuove modifiche se unirle o meno alla copia locale del progetto con un _merge_. Il _pull_, invece, esegue automaticamente la fusione delle modifiche importate dalla versione remota.
  ]))

\

#figure(
  image("assets/git-fetch-pull-push.png", width: 80%),
  caption: [\
  Illustrazione del funzionamento dei comandi #link("https://medium.com/@mehulgala77/github-fundamentals-clone-fetch-push-pull-fork-16d79bb16b79")[push, fetch e pull]: _push_ sincronizza i cambiamenti del repository locale (realizzati tramite commits) sul repository remoto; _fetch_ prende i cambiamenti del repository remoto e li mette a disposizione nel repository locale, senza interagire con la cartella di lavoro ("_workspace_"); _pull_ fonde direttamente i cambiamenti del repository remoto con la cartella di lavoro locale])

\

Il comando #text(darkred)[`git push`] `nome_repository_remoto  nome_ramo_locale` esegue il push del ramo locale `nome_ramo_locale` del progetto (nell'esempio "_ramoA_") sul repository remoto salvato con il riferimento `nome_repository_remoto` (nell'esempio "_esempio_").

#(
  image("assets/git-push.png", width: 85%)
)

Si può anche digitare #text(darkred)[`git push`] `--all  nome_repository_remoto` per fare il push di tutti i rami locali del progetto sul repository remoto.

\

Il comando #text(darkred)[`git fetch`] `nome_repository_remoto` esegue il fetch di tutti i rami del repository remoto con il nome fornito (alternativamente si può specificare un solo ramo da includere con #text(darkred)[`git fetch`] `nome_repository_remoto  nome_ramo_remoto`). Tali rami potranno essere visualizzati con #text(darkred)[`git branch`] `-r` ed eventualmente essere uniti ai file locali di lavoro tramite merging. Nell'esempio seguente, il ramo "_nuova-feature_" del repository remoto "_esempio_" viene fuso nel ramo "_master_" locale:

#(
  image("assets/git-fetch-1.png", width: 100%)
)


#(
  image("assets/git-fetch-2.png", width: 90%)
)

\

Il comando #text(darkred)[`git pull`] `nome_repository_remoto` incorpora automaticamente i cambiamenti eseguiti nel repository remoto `nome_repository_remoto` all'interno del ramo locale correntemente selezionato, eseguendo un fetch seguito da un merge automatico. Richiede quindi attenzione, in quanto si potrebbero sovrascrivere involontariamente alcune modifiche locali. Si può usare anche #text(darkred)[`git pull`] `nome_repository_remoto  nome_ramo_remoto` per includere solo le modifiche eseguite in remoto sul ramo `nome_ramo_remoto` (nell'esempio "_ramoA_").

#(
  image("assets/git-pull.png", width: 90%)
)

\

= Gestire un progetto con Git e #text(darkblue)[GitHub]
//fork
//pull requests
== Usare Git e GitHub da #text(darkpurple)[Eclipse]
= Link utili