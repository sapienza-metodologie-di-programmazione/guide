#let signature(name, type: [], args: []) = [
  ==== #text(weight: "light")[#emph(name)\(#args)#if type != [] [: #type]]

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

#let space(body) = block(inset: (x: 20pt), spacing: 0pt, [#body])

#let constraint(class, title, description: "", body) = [
  === #text(weight: "light")[[Constraint.*#class*.#title.replace(" ", "_")]]

  #space[
    #if description == "" [ #body ] else [
      / description: #description
      / constraint: #body
    ]
  ]
]
