#set text(10pt, font: "Cascadia Code")
#show link: it => underline[#text(blue)[#it#h(3pt)#text(size: 7pt)[(doc)]]]
#set underline(offset: 3pt)
#set page(margin: 1.5cm)

#let darkred = rgb(192, 0, 0)
#let background = rgb(251, 251, 251)
#show regex("JFrame|JButton|JPanel|JLabel"): set text(blue)
#show heading.where(level: 1): it => {
  it.body
  [ #v(10pt) ]
}
#show heading.where(level: 2): it => {
  it.body
  [ #v(10pt) ]
}
#show heading.where(level: 3): it => {
  it.body
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
    // stroke: rgb(240, 240, 255),
    [
      #underline(text(blue)[ℹ Nota]) \
      #v(2pt)
      #body
    ]
  )
]

// #set raw(theme: "halcyon.tmTheme")

#show raw.where(block: true): it => block(
	fill: background,
	width: 100%,
	inset: 10pt,
	stroke: silver,
	it
)
#set figure(supplement: [Figura])

#let code(code) = [ 
  #block(
    fill: background,
    width: 100%,
    inset: 10pt,
    stroke: silver,
    code
  )
]


#align(center, text(17pt)[ *Un approccio pratico a #text(darkred)[Java Swing] e #text(darkred)[MVC]* ])

\

#outline(title: [Sommario], indent: 1.5em)

#pagebreak()

= Java Swing

Questa è una guida molto breve e semplificata, non copre tutto su #text(darkred)[Java Swing], serve solo come introduzione per semplificare il lavoro per eventuali progetti.

== Wireframe

Per sviluppare un'interfaccia grafica (per un sito web, un'applicazione, un gioco etc...) è utile disegnare un *wireframe* fatto di *rettangoli*, *testo* e *icone* come quello in @wireframe-1. 

Il *wireframe* serve perché è difficile progettare un'interfaccia *intuitiva* e *funzionale*. Una volta progettata l'interfaccia *scrivere il #text(darkred)[codice] è #text(darkred)[semplice]*.

\

Proviamo a implementare un esempio

#figure(
	image("assets/wireframe-1.png"),
	caption: [esempio di wireframe disegnato con #link("https://excalidraw.com")[excalidraw]],
) <wireframe-1>

#v(1cm)

#pagebreak()

== Implementare un wireframe 

Il codice completo che implementa il wireframe in @wireframe-1 è *in fondo alla spiegazione*


=== Creare la finestra con #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/javax/swing/JFrame.html")[JFrame]

```java
JFrame frame = new JFrame("Questo \u00E8 un titolo");
frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

frame.setSize(640, 400);
frame.setVisible(true);
```

Il costruttore ```java JFrame(String title)``` imposta il titolo della finestra 

- ```java setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)``` termina il programma quando la finestra viene chiusa

- ```java setVisible(true)``` rende la finestra visibile

=== Aggiungere contenuti alla finestra con #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/javax/swing/JPanel.html")[JPanel]

```java
JPanel panel = new JPanel();
JLabel label = new JLabel("Questa \u00E8 una finestra!");

panel.add(label);
frame.add(panel);
```

Sia ```java JFrame``` sia ```java JPanel``` sono ```java java.awt.Container```, quindi possiamo aggiungere contenuto (testo, immagini, pulsanti etc...) al loro interno tramite ```java add(Component comp)```.

- il ```java JPanel``` aggiunto al frame occuperà l'intero spazio
- il contenuto viene aggiunto al ```java JPanel``` 
- ```java JLabel``` serve a visualizzare testo (```java "Questa è una finstra"``` @wireframe-1)

#v(0.5cm)

#align(image("assets/gui-1.png"), center)

#v(0.5cm)

Mancano ancora un po' di cose: il testo non è centrato, non ci sono i colori etc...

#pagebreak()

=== #text(darkred)[Centrare un elemento] in un JPanel con #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/javax/swing/JPanel.html")[GridBagLayout]


```java
JPanel panel = new JPanel(new GridBagLayout());
```

Il costruttore ```java JPanel(LayoutManager layout)``` permette di specificare una *strategia* per *posizionare* e *dimensionare* il contenuto di un ```java JPanel``` in #text(darkred)[*automatico*]: 
- non bisogna calcolare a mano `x`, `y`, `width` e `height` dei componenti, lo fa il ```java LayoutManager```
- funziona anche quando la *finestra viene ridimensionata*

#note([```java LayoutManager``` è un esempio di #link("https://refactoring.guru/design-patterns/strategy")[Strategy Pattern]])

Per *centrare un elemento* in un panel si usa un ```java GridBagLayout```

#v(0.5cm)

#align(image("assets/gui-2.png"), center)

#v(0.5cm)

=== Colori, font e icone

```java
frame.setIconImage(new BufferedImage(1, 1, BufferedImage.TYPE_INT_ARGB));

JPanel panel = new JPanel(new GridBagLayout());
panel.setBackground(new Color(255, 240, 240));

JLabel label = new JLabel("Questa \u00E8 una finestra!");
label.setForeground(new Color(190, 0, 0));
label.setFont(new Font("Cascadia Code", Font.PLAIN, 24));
```

Nel *wireframe* in @wireframe-1 non c'era nessun'icona in alto a sinistra: per "levarla" ho creato un'immagine vuota di *1px* per *1px*

```java 
new BufferedImage(1, 1, BufferedImage.TYPE_INT_ARGB)
```

#note[Il font ```java "Cascadia Code"``` non è installato di default, provate anche con altri font]

Ora abbiamo una finestra che rispetta il *wireframe* in @wireframe-1

#v(0.5cm)

#align(image("assets/gui-3.png", width: 70%), center)

#v(0.5cm)

=== Codice finale


```java
import java.awt.Color;
import java.awt.Font;
import java.awt.GridBagLayout;
import java.awt.image.BufferedImage;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class App {
    public static void main(String[] args) {
        JFrame frame = new JFrame("Questo \u00E8 un titolo");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setIconImage(new BufferedImage(1, 1, BufferedImage.TYPE_INT_ARGB));

        JPanel panel = new JPanel(new GridBagLayout());
        panel.setBackground(new Color(255, 240, 240));

        JLabel label = new JLabel("Questa \u00E8 una finestra!");
        label.setForeground(new Color(190, 0, 0));
        label.setFont(new Font("Cascadia Code", Font.PLAIN, 24));

        panel.add(label);
        frame.add(panel);

        frame.setSize(640, 400);
        frame.setVisible(true);
    }
}
```

#pagebreak()

== #text(darkred)[Interfacce con Swing senza variabili d'appoggio]

#text(darkred)[*Java*] mette a disposizione uno strumento che si chiama *instance initialization block*, un blocco di codice che viene eseguito dopo aver invocato il costruttore. È specialmente comodo quando si istanziano *classi anonime*.

```java
class Persona {
  String nome;

  public Persona(String nome)  {
    this.nome = nome;
  }
}

class Main {
  public static void main(String[] args) {
    Persona dottorRossi = new Persona("Rossi") {
      {
        nome = "Dr. " + nome;
      }
    };

    System.out.println(dottorRossi.nome); // Dr. Rossi
  }
}
```

#v(0.5cm)

Possiamo sfruttare questa strategia per riscrivere il codice di prima senza variabili. 

```java 
import java.awt.Color;
import java.awt.Font;
import java.awt.GridBagLayout;
import java.awt.image.BufferedImage;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class App {
    public static void main(String[] args) {
        new JFrame("Questo \u00E8 un titolo") {
            {
                setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                setIconImage(new BufferedImage(1, 1, BufferedImage.TYPE_INT_ARGB));

                add(new JPanel(new GridBagLayout()) {
                    {
                        setBackground(new Color(255, 240, 240));

                        add(new JLabel("Questa \u00E8 una finestra!") {
                            {
                                setForeground(new Color(190, 0, 0));
                                setFont(new Font("Cascadia Code", Font.PLAIN, 24));
                            }
                        });
                    }
                });

                setSize(640, 400);
                setVisible(true);
            }
        };
    }
}
```

#pagebreak()

== Layout Manager

Il costruttore ```java JPanel(LayoutManager layout)``` permette di specificare una *strategia* per *posizionare* e *dimensionare* il contenuto di un ```java JPanel``` in #text(darkred)[*automatico*]: 
- non bisogna calcolare a mano `x`, `y`, `width` e `height` dei componenti, lo fa il ```java LayoutManager```
- funziona anche quando la *finestra viene ridimensionata*

#note([```java LayoutManager``` è un esempio di #link("https://refactoring.guru/design-patterns/strategy")[Strategy Pattern]])

=== #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/java/awt/BorderLayout.html")[BorderLayout]

Supponiamo di voler implementare questo wireframe

#figure(
	image("assets/wireframe-2.png"),
	caption: [caso d'uso di un ```java BorderLayout```],
) <wireframe-2>

#v(0.5cm)

Abbiamo un rettangolo con le statistiche in alto, e il restante spazio è occupato da un rettangolo centrale con un pulsante. 

#pagebreak()

==== Barra delle statistiche e menu di gioco

```java
frame.add(new JPanel(new BorderLayout(10, 10)) {
    {
        setBackground(new Color(240, 255, 240)); // verdignolo
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        add(
          new JPanel() {{ setBackground(new Color(220, 220, 255)); }},  // bluastro
          BorderLayout.NORTH
        );

        add(
          new JPanel() {{ setBackground(new Color(220, 220, 255)); }}, 
          BorderLayout.CENTER
        );
    }
});
```

Il costruttore ```java BorderLayout(int vgap, int hgap)``` imposta uno "spazio" verticale e orizzontale fra due componenti.

Con ```java setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10))``` impostiamo un bordo trasparente (per lasciare uno spazio dal bordo della finestra)

Quando aggiungo un elemento ad un container, posso specificare come deve essere trattato tramite il metodo ```java add(Component comp, Object constraints)```: in base al layout del container, ```java Object constraints``` avrà un significato diverso.

#note([```java BorderFactory``` è un esempio di #link("https://refactoring.guru/design-patterns/factory-method")[Factory Pattern]])

// #v(0.5cm);


#align(image("assets/borderlayout-1.png"), center)

#v(0.5cm);

#pagebreak()

==== Aggiungere uno sfondo ai ```java JLabel```

```java
frame.add(new JPanel(new BorderLayout(10, 10)) {
    {
        setBackground(new Color(240, 255, 240));
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        add(new JPanel() {
            {
                setBackground(new Color(220, 220, 255));

                String[] labels = {"Pincopallino", "partite giocate: 10", "partite vinte: 2"};

                for (String label : labels)
                    add(new JLabel(label) {
                        {
                            setForeground(Color.BLUE);
                            setBackground(Color.WHITE);
                            setOpaque(true);
                            setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
                        }
                    });
            }
        }, BorderLayout.NORTH);

        add(new JPanel() {
            {
                setBackground(new Color(220, 220, 255));
                add(new JButton("Gioca") {{ setBackground(new Color(220, 255, 220)); }});
            }
        }, BorderLayout.CENTER);
    }
});
```

Nota interessante: di default, lo sfondo di un ```java JLabel``` è trasparente, per renderlo visibile bisogna usare ```java setOpaque(true)```


#v(0.5cm);

#align(image("assets/borderlayout-2.png"), center);

#v(0.5cm);

#pagebreak()

==== Come funziona il ```java BorderLayout``` in generale?

```java
new JPanel(new BorderLayout()) {
  {
    add(new JPanel(), BorderLayout.CENTER);
    add(new JPanel(), BorderLayout.NORTH);
    add(new JPanel(), BorderLayout.SOUTH);
    add(new JPanel(), BorderLayout.WEST);
    add(new JPanel(), BorderLayout.EAST);
  }
}
```

Il ```java BorderLayout``` permette di specificare in quale posizione mettere un componente, secondo certe regole:
- il componente ```java CENTER``` occuperà tutto lo spazio possibile 
- i componenti ```java NORTH``` e ```java SOUTH```  avranno larghezza massima (indipendentemente dalla larghezza impostata) e avranno altezza minima, o, se impostata, l'altezza impostata
- i componenti ```java WEST``` e ```java EAST```  avranno altezza massima (indipendentemente dall'altezza impostata) e avranno larghezza minima, o, se impostata, la larghezza impostata

Il costruttore ```java BorderLayout(int vgap, int hgap)``` imposta uno "spazio" verticale e orizzontale fra due componenti.

#align(image("assets/borderlayout-3.png"), center)

#pagebreak()

=== #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/java/awt/CardLayout.html")[CardLayout]

==== Menu, impostazioni e partita #text(darkred)[(come cambiare da una vista all'altra)]

Il ```java CardLayout``` è molto utile quando abbiamo più viste (menu principale, impostazioni, selezione partita etc...)

#figure(
	image("assets/wireframe-3.png"),
	caption: [caso d'uso di un ```java CardLayout```],
) <wireframe-3>

#pagebreak()

```java
enum Screens {
  Menu, Settings, Game
}

// etc...

frame.add(new JPanel(new CardLayout()) {
  {
    add(new JPanel(), Screens.Menu.name());
    add(new JPanel(), Screens.Settings.name());
    add(new JPanel(), Screens.Game.name());
  }
});
```

L'idea sarebbe quella di associare ad ogni componente una ```java String``` che lo identifica. In questo caso usiamo un ```java enum``` per non sbagliare a scrivere il nome del componente. 

In questo esempio, verrà visualizzato solo il ```java JPanel``` associato a ```java "Menu"```, vediamo come poter cambiare da un ```java JPanel``` all'altro.

```java
enum Screens {
    Menu, Settings, Game;

    static void show(JPanel panel, Screens screen) {
        CardLayout layout = (CardLayout) panel.getLayout();
        layout.show(panel, screen.name());
    }

}
frame.add(new JPanel(new CardLayout()) {
  {
    JPanel panel = this;

    add(new JPanel() {
      {
        add(new JLabel("Menu principale"));
        add(new JButton("Gioca") {{ 
          addActionListener(e -> Screens.show(panel, Screens.Game)); 
        }});
        add(new JButton("Impostazioni") {{ 
          addActionListener(e -> Screens.show(panel, Screens.Settings));
        }});
      }
    }, Screens.Menu.name());

    add(new JPanel() {
      {
        add(new JLabel("Impostazioni"));
        add(new JButton("torna indietro") {{ 
          addActionListener(e -> Screens.show(panel, Screens.Menu)); 
        }});
      }
    }, Screens.Settings.name());

    add(new JPanel() {
        {
          add(new JLabel("Gioco"));
          add(new JButton("termina partita") {{ 
            addActionListener(e -> Screens.show(panel, Screens.Menu)); 
          }});
        }
    }, Screens.Game.name());
  }
});
```

#pagebreak()


=== #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/java/awt/GridLayout.html")[GridLayout]

Non è un layout particolarmente complesso: permette di specificare il numero di righe, il numero di colonne, e lo spazio fra due componenti.  


```java
frame.add(new JPanel(new GridLayout(4, 3, 10, 10)) {
  {
    setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

    for (int digit = 0; digit <= 9; digit++)
        add(new JButton(String.valueOf(digit)));
    add(new JButton("+"));
    add(new JButton("="));
  }
});
```

#v(0.5cm)

#align(image("assets/gridlayout-1.png"), center)

#v(0.5cm)

#pagebreak()

=== #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/java/awt/GridBagLayout.html")[GridBagLayout]


==== Il layout #text(darkred)[più flessibile]

#figure(
	image("assets/wireframe-4.png"),
	caption: [esempio di wireframe per il gioco "Minesweeper"],
) <wireframe-4>

// === #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/javax/swing/BoxLayout.html")[BoxLayout]

// === #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/java/awt/FlowLayout.html")[FlowLayout]

#pagebreak()

// == Graphics

// == Ritardare azioni con il Timer

// == Animazioni

// == Bug Strani
// === .pack() e panel vuoto

// == Style

// == Graphics

= MVC

// == boh, qualche esempio?

