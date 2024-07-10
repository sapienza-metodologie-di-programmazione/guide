#let signature(name, type: [], args: []) = [
  ==== #emph(name)\(#args)#if type != [] [: #type]

  #v(10pt)
]

#let operation(name, type: [], args: [], pre: [], post: []) = [

  #emph(name)\(#args)#if type != [] [: #type]

  #if pre != [] or post != [] [
    #if pre != [] or post != [] [ 
      #h(10pt) #text(weight: "bold")[pre-conditions]
      #if pre != [] [
        #block( inset: ("left": 20pt), [#pre]) 
      ]
    ]

    #if post != [] [ 
      #h(10pt) #text(weight: "bold")[post-conditions]
      #block(inset: ("left": 20pt), [#post]) 
    ]

    #v(10pt)
  ]

]

#let constraint(name, constraint) = [
  [*V.#name*]

  #block(inset: ("left": 10pt))[#constraint]

  #v(10pt)
]

#let extension(new-objects: [], removed-objects: [], new-ennuples: [], removed-ennuples: []) = [
  #text(weight: "bold")[changes to extensional level]

  #block(inset: ("left": 10pt))[
    #if new-objects != [] [
      #text(weight: "bold")[new objects] #new-objects
    ]

    #if removed-objects != [] [
      #text(weight: "bold")[removed objects] #removed-objects
    ]

    #if new-ennuples != [] [
      #text(weight: "bold")[new tuples] 
      #block(inset: ("left": 10pt))[#new-ennuples]
    ]

    #if removed-ennuples != [] [
      #text(weight: "bold")[removed tuples] 
      #block(inset: ("left": 10pt))[#removed-ennuples]
    ]
  ]

  #text(weight: "bold")[]
]

#let trigger(name, operations, function, invocation: [after]) = [
  ==== [V.#name]

  #v(5pt)

  #block(inset: ("left": 10pt))[
    #text(weight: "bold")[operazioni intercettate] #operations

    #text(weight: "bold")[invocazione] #invocation

    #text(weight: "bold")[funzione]\(old, new)

    #block(inset: ("left": 10pt))[#function]
  ]

  #v(10pt)
]

// Modifica del Livello Estensionale dei Dati: Il livello estensionale dei dati al termine
// dell’esecuzione della funzione differisce da quello di partenza come segue:
// Nuovi elementi del dominio di interpretazione : α.
// Elementi del dominio di interpretazione che non esistono più : nessuno
// Nuove ennuple di predicati:
// ▶ Alla relazione che interpreta il pred. Studente/1 viene aggiunto α
// ▶ Alla relazione che interpreta il pred. nome/2 viene aggiunta (α, n)
// ▶ Alla relazione che interpreta il pred. cognome/2 viene aggiunta (α, c)
// ▶ Alla relazione che interpreta il pred. matricola/2 viene aggiunta (α, m)
// Ennuple di predicati che non esistono più: nessuna
// Valore di Ritorno: result = α.

#let tab = math.class("normal", [#h(1cm)])
#let t = [#h(1cm)]
#let enspace = math.class("normal", [#h(2.5pt)])
