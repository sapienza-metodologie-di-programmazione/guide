#import "logic.typ": *

#set page(margin: 1.65in)
#set par(leading: 0.55em, spacing: 0.85em, first-line-indent: 1.8em, justify: true)
#set text(font: "Cascadia Code", weight: "light", lang: "it", size: 9pt)
#set underline(offset: 3pt)

#show heading: set block(above: 1.4em, below: 1em)
#show link: it => underline[#text(navy)[#it]]
#show raw.where(block: true): block.with(inset: 1em, width: 100%, fill: luma(254), stroke: (left: 5pt + luma(245), rest: 1pt + luma(245)))
#show sym.emptyset : sym.diameter 
#show raw: set text(font:"Cascadia Code", lang: "en", weight: "light", size: 9pt)

#let reft(reft) = box(width: 8pt, place(dy: -8pt, 
  box(radius: 100%, width: 9pt, height: 9pt, inset: 1pt, stroke: .5pt, fill: black,
    align(center + horizon, text(white, font: "CaskaydiaCove NFM", weight: "bold", size: 8pt, repr(reft)))
  )
))

#show raw: r => { show regex("t(\d)"): it => { reft(int(repr(it).slice(2, -1))) }; r }

#let javadoc(url) = text(size: 0.7em)[#set underline(offset: 2pt);(#link(url)[Java API doc])]
#let note(body) = block(width: 100%, inset: 10pt, stroke: (left: 2pt + rgb("#0969da")))[#text(rgb("#0969da"))[ Nota] \ #body]
#let darkred = rgb(192, 0, 0)



#page(align(center + horizon)[
  #text(size: 1.5em)[*Un approccio pratico a #text(darkred)[Java Swing] e #text(darkred)[MVC]*] \ 
  by #link("https://github.com/CuriousCI")[Cicio Ionut]
])

#page(outline(title: "Sommario", indent: 1.5em))

#set page(numbering: "1")

= #text(darkred)[Java Swing]

L'obiettivo di questo capitolo è fornire, tramite esempi pratici, gli *strumenti fondamentali* per lo sviluppo _agevole_ di interfacce grafiche con Java Swing.

== Wireframe

Per sviluppare l'interfaccia grafica, che si tratti di un sito web, un'applicazione, un gioco etc... è utile disegnare un wireframe. 
Un wireframe è un *diagramma* fatto di rettangoli, testo, icone e frecce (come in @wireframe-1) che permette di *progettare rapidamente* un'interfaccia intuitiva e funzionale, semplificando il lavoro da fare durante la fase d'implementazione.

#figure(
  caption: [esempio di wireframe disegnato con #link("https://excalidraw.com")[excalidraw]; \ di seguito ne viene discussa l'implementazione],
  image("assets/wireframe-1.png"),
) <wireframe-1>

== Implementazione passo passo di un wireframe 

=== Creare una finestra con ```java JFrame``` #javadoc("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/JFrame.html") 

```java
JFrame frame = t1 new JFrame("Questo \u00E8 un titolo");
t2 frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

try {
  t3 frame.setIconImage(ImageIO.read(new File("icon.png"))); 
} catch (IOException e) { }

t4 frame.setSize(600, 400);
t5 frame.setLocationRelativeTo(null);
t6 frame.setVisible(true); 
```

Swing ha alcune impostazioni di *default particolari*:
- #reft(1) istanzia una finestra *invisibile*, per visualizzarla si usa #reft(6)
- la finestra, alla chiusura, viene *solo nascosta*: per fare in modo che l'intera applicazione venga terminata si usa #reft(2) 
- #reft(5) posiziona la finestra al centro dello schermo

Per ridimensionare una finestra, oltre a #reft(4), si può usare anche con il metodo ```java pack()``` che imposta le *dimensioni minime* per disegnare il contenuto della finestra. 

#note[```java pack()``` imposta le *dimensioni a 0* se la finestra non ha contenuto, per cui bisogna invocare ```java pack()``` *dopo* aver aggiunto componenti al ```java JFrame```.]

Il prossimo passo è quello di aggiungere il testo ```java "Questa è una finestra"```

#note[Si ricordi di *cambiare _sempre_ l'icona* #reft(3) di default :)]

// #pagebreak()

=== Aggiungere ```java Component``` a una finestra con ```java JPanel``` #javadoc("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/JPanel.html")

```java
JPanel panel = t1 new JPanel();
JLabel label = t2 new JLabel("Questa \u00E8 una finestra!");

panel.add(label);
frame.add(panel);
```

Sia #reft(1) sia #reft(2) sono ```java java.awt.Container``` per cui dispongono del metodo ```java add(Component)```. 
Swing mette a disposizione vari ```java Component``` già pronti:
- ```java JLabel``` per *testo* e *immagini*
- ```java JButton``` per *pulsanti*
- ```java JPanel``` per interfacce più complesse 
- ```java JTable```, ```java JSlider``` etc... per utilizzi più specifici

#note[```java java.awt.Container``` è un esempio di #link("https://refactoring.guru/design-patterns/composite")[Composite Pattern]]

=== Come vengono disegnati i componenti: ```java paint(Graphics g)```

Il passo successivo è quello di colorare lo sfondo e il testo come in @wireframe-1

// #note[Normalmente un *wireframe* _non prevede_ colori o scelte stilistiche, ma nel caso di un progetto piccolo possiamo permetterci di usarlo come se fosse un design]

```java
JPanel panel = new JPanel() {
  @Override
  t1 protected void paintComponent(Graphics g x2) {
    super.paintComponent(g);

    int density = 5;
    g.setColor(Color.decode("#ffec99"));
    for (int x = 0; x <= getWidth() + getHeight(); x += density)
      t3 g.drawLine(x, 0, 0, x);
  }
};
panel.setBackground(Color.WHITE);

JLabel label = new JLabel("Questa \u00E8 una finestra!");
label.setForeground(Color.decode("#f08c00"));
label.setFont(new Font("Cascadia Code", Font.PLAIN, 22));

panel.add(label);
frame.add(panel);
```

Il ```java JFrame``` invoca il metodo ```java paint(Graphics g)``` del ```jframe JPanel```. A sua volta ```java paint(Graphics g)``` invoca in ordine:
- ```java paintComponent(Graphics g)``` #reft(1)
- ```java paintBorder(Graphics g)```
- ```java paintChildren(Graphics g)```

Creando una *classe anonima* si possono sovrascrivere il comportamento di uno di questi metodi, in particolare quello di #reft(1) per disegnare lo sfondo con le linee oblique #reft(3) in @wireframe-1.

Questo approccio è molto flessibile, perché con ```java Graphics g``` #reft(2) si possono disegnare immagini, testo e figure *programmaticamente* (quindi eventualmente *animazioni*).

#note[Il font ```java "Cascadia Code"``` non è installato di default, si possono provare anche altri font]

#align(center, image("assets/gui-1.png"))

=== Centrare un componente con ```java GridBagLayout``` #javadoc("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/GridBagLayout.html")

```java
JPanel panel = t1 new JPanel(new GridBagLayout()x2);
```

Il costruttore #reft(1) permette di specificare una *strategia* per *posizionare* e *dimensionare* il contenuto del ```java JPanel``` in #text(darkred)[*automatico*]: 
- non bisogna calcolare a mano `x`, `y`, `width` e `height` dei componenti, lo fa il ```java LayoutManager``` #reft(2) specificato
- il layout persiste anche quando la *finestra viene ridimensionata*

#note([```java LayoutManager``` è un esempio di #link("https://refactoring.guru/design-patterns/strategy")[Strategy Pattern]])

Per *centrare un elemento* in un panel si usa il ```java GridBagLayout``` (la spiegazione è in seguito nella sezione sui ```java LayoutManager```)

\
#align(center, image("assets/gui-2.png"))

#pagebreak()

=== Implementazione completa

Di seguito l'implementazione completa dell'interfaccia in @wireframe-1.

```java
import javax.imageio.ImageIO;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.GridBagLayout;
import java.io.File;
import java.io.IOException;

public class App {
	public static void main(String[] args) {
		JFrame frame = new JFrame("Questo \u00E8 un titolo");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		try {
			frame.setIconImage(ImageIO.read(new File("icon.png")));
		} catch (IOException e) {
		}

		JPanel panel = new JPanel(new GridBagLayout()) {
			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);

				int density = 5;
				g.setColor(Color.decode("#ffec99"));
				for (int x = 0; x <= getWidth() + getHeight(); x += density)
					g.drawLine(x, 0, 0, x);
			}
		};
		panel.setBackground(Color.WHITE);

		JLabel label = new JLabel("Questa \u00E8 una finestra!");
		label.setForeground(Color.decode("#f08c00"));
		label.setFont(new Font("Cascadia Code", Font.PLAIN, 22));

		panel.add(label);
		frame.add(panel);

		frame.setSize(600, 400);
		frame.setLocationRelativeTo(null);
		frame.setVisible(true);
	}
}
```

#pagebreak()

== Interfacce con Swing senza variabili d'appoggio

Java mette a disposizione uno strumento che si chiama *instance initialization block*, un blocco di codice che viene eseguito dopo aver invocato il costruttore. È particolarmente comodo quando si istanziano *classi anonime*.

```java
class Persona {
  String nome;
}

class Main {
  public static void main(String[] args) {
    Persona rossi = new Persona() {
			t1 {
				nome = "Rossi";
			}
		};

		System.out.println(rossi.nome); /* Rossi */
  }
}
```

Si può sfruttare questa feature #reft(1) per riscrivere l'implementazione 

```java 
public class App extends JFrame {
	App() {
		super("Questo \u00E8 un titolo");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		try { setIconImage(ImageIO.read(new File("icon.png"))); } catch (IOException e) { }

		add(new JPanel(new GridBagLayout()) {
			{
				setBackground(Color.WHITE);
				add(new JLabel("Questa \u00E8 una finestra!") {
					{
						setForeground(Color.decode("#f08c00"));
						setFont(new Font("Cascadia Code", Font.PLAIN, 22));
					}
				});
			}

			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);
				int density = 5; g.setColor(Color.decode("#ffec99"));
				for (int x = 0; x <= getWidth() + getHeight(); x += density)
					g.drawLine(x, 0, 0, x);
			}
		});

		setSize(600, 400);
		setLocationRelativeTo(null);
		setVisible(true);
	}

	public static void main(String[] args) { new App(); }
}
```

#pagebreak()

== Modificare font e colori con ```java UIManager``` #javadoc("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/UIManager.html")

L'aspetto dei componenti e il loro comportamento in Java Swing viene gestito con #link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/LookAndFeel.html")[```java javax.swing.LookAndFeel```]. È possibile modificare *globalmente* l'aspetto del ```java LookAndFeel``` tramite ```java javax.swing.UIManager``` (sostanzialmente un'```java HashMap``` con diversi attributi per il tema). 

```java
UIManager.put("Label.font" t1, new Font("Cascadia Code", Font.PLAIN, 14));
```

Ad esempio, con la chiave #reft(1) si può impostare il ```java Font``` per tutti i ```java JLabel``` 

#note[```java UIManager``` è un esempio di #link("https://refactoring.guru/design-patterns/singleton")[Singleton Pattern]]

```java
import java.awt.Color;
import java.awt.Font;
import javax.swing.UIManager;

public class App {
  static {
    UIManager.put(
      "Label.font", 
      new Font("Cascadia Code", Font.PLAIN, 14)
    );
    UIManager.put("Label.foreground", Color.DARK_GRAY);
    UIManager.put("Label.background", Color.WHITE);

    UIManager.put("Button.font", new Font("Cascadia Code", Font.PLAIN, 14));
    UIManager.put("Button.foreground", new Color(224, 49, 49));
    UIManager.put("Button.background", new Color(255, 201, 201));

    UIManager.put("Button.highlight", Color.WHITE);
    UIManager.put("Button.select", Color.WHITE);
    UIManager.put("Button.focus", Color.WHITE);

    UIManager.put("Panel.background", new Color(233, 236, 239));
  }
}
```

=== Chiavi di ```java UIManager```

È possibile generare l'elenco di chiavi disponibili, o provare #link("https://github.com/sapienza-metodologie-di-programmazione/minesweeper/blob/main/keys.txt")[queste] 

```java
javax.swing.UIManager
  .getDefaults()
  .keys()
  .asIterator()
  .forEachRemaining(System.out::println);
```

#pagebreak()

== Layout Manager

Il costruttore ```java JPanel(LayoutManager layout)``` permette di specificare una *strategia* per *posizionare* e *dimensionare* il contenuto di un ```java JPanel``` in #text(darkred)[*automatico*]: 
- non bisogna calcolare a mano `x`, `y`, `width` e `height` dei componenti, lo fa il ```java LayoutManager``` specificato
- il layout persiste anche quando la *finestra viene ridimensionata*

#note([```java LayoutManager``` è un esempio di #link("https://refactoring.guru/design-patterns/strategy")[Strategy Pattern]])

=== ```java BorderLayout``` #javadoc("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/java/awt/BorderLayout.html")

Si supponga di voler implementare questo wireframe

#figure(
  image("assets/wireframe-2.png"),
  caption: [caso d'uso di un ```java BorderLayout```],
) <wireframe-2>

C'è una barra con le statistiche in alto e lo spazio rimanente è occupato da un rettangolo centrale con un pulsante. 

#pagebreak()

==== Barra delle statistiche e menu di gioco

```java
public class App extends JFrame {
  static { UIManager.put("Panel.background", Color.WHITE); }

  App() {
    super("JGioco");
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    try { setIconImage(ImageIO.read(new File("icon.png"))); } 
    catch (IOException e) { }

    add(new JPanel(new BorderLayout(10, 10) t1) { // Sfondo
      {
        t2 setBorder(
          BorderFactory.createEmptyBorder(20, 20, 20, 20)); 

        add(new JPanel() { // Barra in altro
          {
            t3 setBackground(new Color(255, 255, 255, 0)); 
            setBorder(BorderFactory.createCompoundBorder(
            BorderFactory.createLineBorder(Color.decode("#2f9e44")),
            BorderFactory.createEmptyBorder(10, 10, 10, 10)));
          }
        }, BorderLayout.NORTH t4);

        add(new JPanel() { // Blocco centrale
          {
            t3 setBackground(new Color(255, 255, 255, 0)); 
            setBorder(BorderFactory.createCompoundBorder(
              BorderFactory.createLineBorder(Color.decode("#2f9e44")),
              BorderFactory.createEmptyBorder(10, 10, 10, 10)));
          }
        }, BorderLayout.CENTER t5);
      }

      @Override
      protected void paintComponent(Graphics g) { // Sfondo linee oblique verdi
        super.paintComponent(g);
        int d = 5; g.setColor(Color.decode("#b2f2bb") t6);
        for (int x = 0; x <= getWidth() + getHeight(); x += d)
          g.drawLine(x, 0, 0, x);
      }
    });

    setSize(600, 400);
    setLocationRelativeTo(null);
    setVisible(true);
  }

  public static void main(String[] args) { new App(); }
}
```

Breve analisi del codice:
- #reft(1) crea un ```java BorderLayout``` specificando lo spazio da lasciare fra i componenti del ```java JPanel``` (```typst 10px``` in verticale e ```typst 10px``` in orizzontale).
- #reft(2) aggiunge un bordo trasparente al ```java JPanel``` (in modo che i componenti non siano attaccati al bordo della finestra).
- #reft(3) rende lo sfondo trasparente, perché il quarto parametro del costruttore di ```java Color``` indica il *canale alpha*, ovvero la trasparenza del colore.
- #reft(4) e #reft(5) sono delle costanti che il ```java BorderLayout``` usa per capire dove posizionare il componente (sono spiegate nella sezione sul funzionamento del ```java BorderLayout```).

#note[Uno dei modi per rappresentare i colori è il modello #link("https://en.wikipedia.org/wiki/RGBA_color_model")[RGBA], che include il *canale alpha*. Un altro modo è tramite la rappresentazione #link("https://en.wikipedia.org/wiki/Web_colors#Hex_triplet")[esadecimale] #reft(6).]

Quando aggiungo un elemento ad un container, posso specificare come deve essere trattato tramite il metodo ```java add(Component comp, Object constraints)```: in base al layout del container, ```java Object constraints``` avrà un significato diverso.

#note([```java BorderFactory``` #reft(2) è un esempio di #link("https://refactoring.guru/design-patterns/factory-method")[Factory Pattern]])

Risultato

#align(image("assets/borderlayout-1.png", width: 52%), center)

==== Implementazione

```java
public class App extends JFrame {
  static {
    UIManager.put(
      "Label.font", 
      new Font("Cascadia Code", Font.PLAIN, 17)
    );
    UIManager.put("Label.foreground", Color.decode("#2f9e44"));
    UIManager.put("Label.background", Color.WHITE);

    UIManager.put(
      "Button.font",
      new Font("Cascadia Code", Font.PLAIN, 17)
    );
    UIManager.put("Button.foreground", Color.decode("#2f9e44"));
    UIManager.put("Button.background", Color.WHITE);

    UIManager.put("Button.border", 
    BorderFactory.createCompoundBorder(
      BorderFactory.createLineBorder(Color.decode("#2f9e44")),
      BorderFactory.createEmptyBorder(5, 10, 5, 10)));

    UIManager.put("Button.highlight", Color.decode("#b2f2bb"));
    UIManager.put("Button.select", Color.decode("#b2f2bb"));
    UIManager.put("Button.focus", Color.WHITE);

    UIManager.put("Panel.background", Color.WHITE);
  }
```

```java
  App() {
    add(new JPanel(new BorderLayout(10, 10)) {
      {
        // ...
        add(new JPanel() {
          {
            // ...
            String[] labels = { "Pincopallino", "partite: 10", "vittorie: 2" };
            for (String label : labels)
              add(new JLabel(label) {
                {
                  setOpaque(true);
                  setBorder(BorderFactory.createCompoundBorder(
                    BorderFactory.createLineBorder(Color.decode("#2f9e44")),
                    BorderFactory.createEmptyBorder(5, 10, 5, 10)));
                }
              });
          }
        }, BorderLayout.NORTH);

        add(new JPanel() { { ...; add(new JButton("Gioca")); } }, BorderLayout.CENTER);
      }

      @Override
      protected void paintComponent(Graphics g) { ... }
    });
    // ...
  }

  public static void main(String[] args) { new App(); }
}
```

// #note[di default, lo sfondo di un ```java JLabel``` è trasparente, per renderlo visibile bisogna usare ```java setOpaque(true)```]

\
#align(image("assets/borderlayout-2.png"), center);

// #pagebreak()

==== Implementazione pt.2 

```java
public class App extends JFrame {
  static { /* Usate il blocco alla pagina 12 */ }

  Border simpleBorder(int horizontal, int vertical) {
    return BorderFactory.createCompoundBorder(
        BorderFactory.createLineBorder(Color.decode("#2f9e44")),
        BorderFactory.createEmptyBorder(horizontal, vertical, horizontal, vertical));
  }

  App() {
    super("JGioco");
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    setSize(600, 400);
    try { setIconImage(ImageIO.read(new File("icon.png"))); } catch (IOException e) { }

    add(new JPanel(new BorderLayout(10, 10)) {
      {
        setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
        add(new JPanel() {
          {
            setBackground(new Color(255, 255, 255, 0));

            setBorder(simpleBorder(10, 10));
            Stream.of(new String[] { "Pincopallino", "partite: 10", "vittorie: 2" })
                .map(label -> new JLabel(label) {
                  {
                    setOpaque(true);
                    setBorder(simpleBorder(5, 10));
                  }
                }).forEach(this::add);
          }
        }, BorderLayout.NORTH);

        add(new JPanel() {
          {
            setBackground(new Color(255, 255, 255, 0));
            setBorder(simpleBorder(10, 10));
            add(new JButton("Gioca"));
          }
        }, BorderLayout.CENTER);
      }

      @Override
      protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        int density = 5;
        g.setColor(Color.decode("#b2f2bb"));
        for (int x = 0; x <= getWidth() + getHeight(); x += density)
          g.drawLine(x, 0, 0, x);
      }
    });

    setLocationRelativeTo(null); setVisible(true);
  }

  public static void main(String[] args) { new App(); }
}
```

#pagebreak()

==== Funzionamento del ```java BorderLayout```

Il ```java BorderLayout``` permette di specificare la regione del ```java Container``` occupata da ciascun componente:
- il componente posizionanto in ```java CENTER``` occupa tutto lo spazio disponibile.
- i componenti a ```java NORTH``` e ```java SOUTH``` occupano la larghezza massima (indipendentemente dalla larghezza impostata) e occupano l'altezza minima, o, se impostata, l'altezza impostata.
- i componenti ```java WEST``` e ```java EAST``` occupano l'altezza massima (indipendentemente dall'altezza impostata) e occupano la larghezza minima, o, se impostata, la larghezza impostata.

#align(image("assets/borderlayout-3.png"), center)

```java
class DecoratedPanel { ... } // Per esercizio definirla :)

public class App extends JFrame {
  App() {
    add(new JPanel(new BorderLayout()) { {
      add(new DecoratedPanel("Nord"), BorderLayout.NORTH);
      add(new DecoratedPanel("Sud"), BorderLayout.SOUTH);
      add(new DecoratedPanel("West") {
        { setPreferredSize(new Dimension(120, 0)); } // Larghezza custom
      }, BorderLayout.WEST);
      add(new DecoratedPanel("East"), BorderLayout.EAST);
      add(new DecoratedPanel("Center"), BorderLayout.CENTER);
    } });
  }

  public static void main(String[] args) { new App(); }
}
```

#pagebreak()

=== ```java CardLayout``` #javadoc("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/CardLayout.html")

==== Menu, impostazioni e partita _(cambiare schermata)_

Il ```java CardLayout``` è molto utile quando abbiamo più schermate (menu principale, impostazioni, partita etc...) e si vuole un modo *semplice* per passare da una schermata all'altra.

#figure(
  image("assets/wireframe-3.png"),
  caption: [caso d'uso di un ```java CardLayout``` e *frecce* nel *wireframe* per le transizioni],
) <wireframe-3>

#pagebreak()

==== L'implementazione più rozza

```java
public class App extends JFrame {
  App() {
    super("JGioco");
    // ...

    JPanel panel;

    add(panel = new JPanel(new CardLayout()) {
      {
        add(new MenuPanel() t1, "Menu" x2);
        add(new SettingsPanel() t1, "Settings" x2);
        add(new GamePanel() t1, "Game" x2);
      }
    });

    t3 ((CardLayout) panel.getLayout()).show(panel, "Menu");
    // ...
  }

  public static void main(String[] args) { new App(); }
}
```

Ad ogni schermata #reft(1) bisogna associare un *nome* #reft(2) quando viene aggiunta al ```java JPanel``` con il ```java CardLayout```. Per visualizzare la schermata scelta basta usare il metodo ```java show(Container parent, String name)``` del ```java CardLayout``` #reft(3)

Questo approccio ha 2 problemi:
- è facile *sbagliare il nome* della schermata, essendo una stringa
- non c'è un elenco esplicito delle schermate disponibili

==== Usando gli enum

Per ovviare a questi problemi, si può usare un ```java enum```

```java
enum Screen { Menu, Settings, Game }

public class App extends JFrame {
  App() {
    super("JGioco"); 
    JPanel panel;
    add(panel = new JPanel(new CardLayout()) {
      {
        add(new MenuPanel() t1, Screen.Menu.name());
        add(new SettingsPanel() t1, Screen.Settings.name());
        add(new GamePanel() t1, Screen.Game.name());
      }
    });

    ((CardLayout) panel.getLayout()).show(panel, Screen.Game.name());
  }
  public static void main(String[] args) { new App(); t2 }
}
```

Il problema è che, per poter *cambiare schermata*, bisogna passare ai vari componenti #reft(1) l'istanza di ```java App``` #reft(2) di cui si vuole cambiare la schermata, creando un groviglio di *spaghetti code*. Ma c'è una soluzione per ovviare anche a questo problema.

==== Singleton + Observer

```java
enum Screen { Menu, Settings, Game }

@SuppressWarnings("deprecation")
t1 class Navigator extends Observable {
  private static Navigator instance;

  private Navigator() { }

  public static Navigator getInstance() {
    if (instance == null)
      instance = new Navigator();
    return instance;
  }

  public void navigate(Screen screen) {
    setChanged();
    notifyObservers(screen);
  }
}

@SuppressWarnings("deprecation")
t2 public class App extends JFrame implements Observer {
  JPanel panel;

  App() { 
    /* ... */
    t3 Navigator.getInstance().addObserver(this);

    add(panel = new JPanel(new CardLayout()) {
      {
        add(new MenuPanel(), Screen.Menu.name());
        add(new SettingsPanel(), Screen.Settings.name());
        add(new GamePanel(), Screen.Game.name());
      }
    }); 
    /* ... */
  }

  @Override
  t4 public void update(Observable o, Object arg) {
    if (o instanceof Navigator && arg instanceof Screen)
      t5 ((CardLayout) panel.getLayout()).show(panel, ((Screen) arg).name());
  }

  public static void main(String[] args) {
    new App();
    t6 Navigator.getInstance().navigate(Screen.Settings);
  }
}
```

- ```java Navigator``` #reft(1) è la classe che permette di cambiare schermata 
  - usa il pattern *Singleton* perché deve avere una sola istanza globale
  - usa il pattern *Observer* per segnalare alla vista il cambiamento di schermata 
  - per cambiare schermata, basta usare #reft(6) 
- ```java App``` #reft(2)
  - è un *Observer* perché deve ricevere le segnalazioni da ```java Navigator``` #reft(1)
  - usa #reft(3) per osservare l'unica istanza di ```java Navigator``` #reft(1)
  - nel metodo #reft(4) cambia la schermata usando ```java CardLayout::show``` #reft(5)

#note[
  L'utilizzo del *Singleton Pattern* in questo caso è un po' esagerato. Si potrebbe benissimo crare un'istanza di ```java Navigator``` e passarla ai vari componenti, come nel progetto #link("https://github.com/sapienza-metodologie-di-programmazione/minesweeper/blob/main/src/main/java/minesweeper/view/Navigator.java")[Minesweeper] (permettendo di avere più ```java Navigator``` diversi). 

  Il lettore è incoraggiato a valutare l'opzione che ritenete più adatta al suo progetto, o di crearne un'altra :) 
]

#pagebreak()

=== ```java GridLayout``` #javadoc("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/java/awt/GridLayout.html")

Non è un layout particolarmente complesso: permette di specificare il numero di righe, il numero di colonne, e lo spazio fra le righe e le colonne.  

```java
frame.add(new JPanel(new GridLayout(4, 3, 10, 10)) {
  {
    setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));

    for (int digit = 0; digit <= 9; digit++)
      add(new JButton(String.valueOf(digit)));
    add(new JButton("+"));
    add(new JButton("="));
  }
});
```

\
#align(image("assets/gridlayout-1.png"), center)

==== Implementazione

```java
public class App extends JFrame {
  static {
    Color YELLOW = Color.decode("#f08c00");

    UIManager.put("Button.font", new Font("Cascadia Code", Font.PLAIN, 30));
    UIManager.put("Button.foreground", YELLOW);
    UIManager.put("Button.background", Color.WHITE);

    UIManager.put("Button.border", 
        BorderFactory.createCompoundBorder(
          BorderFactory.createLineBorder(YELLOW),
          BorderFactory.createEmptyBorder(10, 15, 10, 15)));
    UIManager.put("Button.highlight", Color.decode("#ffec99"));
    UIManager.put("Button.select", Color.decode("#ffec99"));
    UIManager.put("Button.focus", YELLOW);
    UIManager.put("Panel.background", Color.WHITE);
  }

  App() {
    super("Calcolatrice");
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    try {
      setIconImage(ImageIO.read(new File("icon.png")));
    } catch (IOException e) {
    }

    add(new JPanel(new GridLayout(4, 3, 10, 10)) {
      {
        setBorder(
          BorderFactory.createEmptyBorder(20, 20, 20, 20));
        for (int digit = 0; digit <= 9; digit++)
          add(new JButton(String.valueOf(digit)));
        add(new JButton("+"));
        add(new JButton("="));
      }

      @Override
      protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        int d = 5;
        g.setColor(Color.decode("#ffec99"));
        for (int x = 0; x <= getWidth() + getHeight(); x += d)
          g.drawLine(x, 0, 0, x);
      }
    });

    setSize(300, 350);
    setLocationRelativeTo(null);
    setVisible(true);
  }

  public static void main(String[] args) { new App(); }
}
```

#pagebreak()

=== ```java GridBagLayout``` #javadoc("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/GridBagLayout.html")

==== Il layout #text(darkred)[più flessibile]

Il ```java GridBagLayout``` divide il panel in una griglia dinamica e permette di controllare la *posizione* dei componenti *all'interno di ogni singola cella*:
- una cella può essere *posizionata* in qualunque ```java x``` e ```java y``` della griglia
- la *dimensione* di una cella può essere definita in due modi:
  - specificando numero di *righe* e numero di *colonne* da occupare
  - specificando *regole dinamiche* per ridimensionare larghezza e altezza

La particolarità (rispetto agli altri layout) è che i componenti all'interno delle celle *non vengono ridimensionati* e si possono *posizionare liberamente* (non occupano tutto lo spazio della cella).

Ad esempio, nella cella a sinistra si può vedere che il label ```java "testo"``` è posizionato a ```java NORTH_EAST```.

#figure(
	image("assets/wireframe-4.png"),
	caption: [caso d'uso di un ```java GridBagLayout```],
) <wireframe-4>

#pagebreak()

==== Implementazione

```java
public class App extends JFrame {
  static Color TRANSPARENT = new Color(0, 0, 0, 0);

  static {
    UIManager.put("Label.font", new Font("Cascadia Code", Font.PLAIN, 14));
    UIManager.put("Panel.background", Color.WHITE);
  }

  App() {
    super("JGioco");
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    try {
      setIconImage(ImageIO.read(new File("icon.png")));
    } catch (IOException e) {
    }

    JFrame frame = this;
    setSize(600, 400);

    add(new JPanel(new GridLayout(1, 1)) {
      {
        setBorder(BorderFactory.createEmptyBorder(50, 30, 50, 30));

        add(new JPanel(new GridBagLayout()) {
          {
            setBackground(TRANSPARENT);
            setBorder(
                BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(Color.DARK_GRAY),
                BorderFactory.createEmptyBorder(30, 30, 30, 30)));

            GridBagConstraints c = new GridBagConstraints();

            c.weightx = 1;
            c.weighty = 1;

            c.anchor = GridBagConstraints.NORTHEAST;
            c.gridx = 0;
            c.gridy = 0;
            c.gridwidth = 1;
            c.gridheight = 3;

            add(new JLabel("testo"), c);

            c.anchor = GridBagConstraints.CENTER;
            c.gridx = 1;
            c.gridy = 0;
            c.gridwidth = GridBagConstraints.REMAINDER;
            c.gridheight = 2;

            add(new JLabel(
              "x: 1,\n y: 0, w: spaz. rim., h: 2 righe"), c);

            c.gridx = 1;
            c.gridy = 2;
            c.gridwidth = GridBagConstraints.REMAINDER;
            c.gridheight = 1;

            add(new JLabel(
              "x: 1, y: 2, w: spaz. rim., h: 1 riga"), c);
          }

          @Override
          protected void paintComponent(Graphics g) {
            setPreferredSize(
              new Dimension(frame.getWidth() - 80, 
              frame.getHeight() - 80));
            super.paintComponent(g);
          }
        });
      }

      @Override
      protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        int d = 5;
        g.setColor(Color.decode("#e9ecef"));
        for (int x = 0; x <= getWidth() + getHeight(); x += d)
          g.drawLine(x, 0, 0, x);
      }
    });

    setLocationRelativeTo(null);
    setVisible(true);
  }

  public static void main(String[] args) { new App(); }
}
```

#align(image("assets/gridbaglayout-1.png"), center) \

```java GridBagConstraints``` ha anche *altri attributi* estremamente utili come ```java ipdax```, ```java ipady``` e ```java insets``` che sono discussi nella #link("https://docs.oracle.com/javase%2Ftutorial%2Fuiswing%2F%2F/layout/gridbag.html#gridbagConstraints")[guida ufficiale]

#pagebreak()

=== In conclusione (sui Layout)

Con questi strumenti è possibile coprire la maggior parte delle necessità che riguardano l'implementazione di un *wireframe*, in modo semplice e pulito.

#figure(
	image("assets/wireframe-5.png"),
	caption: [esempio di wireframe per il gioco "Minesweeper"],
) <wireframe-5>
\

I layout visti in questa guida #link("https://docs.oracle.com/javase%2Ftutorial%2Fuiswing%2F%2F/layout/visual.html")[non sono gli unici] (e non ne sono state coperte tutte le funzionalità), ma, capiti i concetti chiave, si può consultare la #link("https://docs.oracle.com/en/java/javase/21/docs/api/index.html")[documentazione].

#pagebreak()

== Pulsanti e Functional Interfaces

Non c'è molto da dire sui pulsanti: sono dei componenti che invocano un metodo quando vengono premuti. Una delle funzionalità che molti non usano nel contesto dei pulsanti è quella delle *SAM* _(Single Abstract Method)_ *Functional Interfaces*. 

```java
JButton button = new JButton("Pulsante");
button.addActionListener(t1 new ActionListener() {
  @Override
  t2 public void actionPerformed(ActionEvent e) {
    System.out.println("Pulsante premuto!");
  }
});

panel.add(button);
```

Per eseguire del codice quando viene premuto il pulsante bisogna aggiungerli un ```java ActionListener``` #reft(1), in cui si sovrascrive il metodo ```java actionPerformed``` #reft(2).

```java
package java.awt.event;

import java.util.EventListener;

public interface ActionListener extends EventListener {
   t1 void actionPerformed(ActionEvent var1);
}
```
Analizzando l'implementazione di ```java ActionListener``` notiamo che si tratta di un'interfaccia con *un solo metodo astratto* #reft(1), quindi è possibile semplificare il codice sopra in questo modo:

```java
JButton button = new JButton("Pulsante");
button.addActionListener(e -> System.out.println("Pulsante premuto!"));

panel.add(button);
```

Se si vogliono usare gli *instance initialization block*, è possibile scrivere direttamente:

```java
panel.add(new JButton("Pulsante") {{
  addActionListener(e -> System.out.println("Pulsante premuto!"));
}});
```

#pagebreak()


== Disegnare programmaticamente con le trasformazioni 

=== Semplificare il codice con ```java .translate(int x, int y)```

Si supponga di voler disegnare dei quadrati posizionandoli in diagonale partendo da ```java (0, 0)```, il codice non è particolarmente complesso:

```java
class Panel extends JPanel {
  Panel() {
    super();
    setPreferredSize(new Dimension(200, 300));
  }

  @Override
  public void paint(Graphics g) {
    super.paint(g);

    g.setColor(Color.CYAN);
    g.fillRect(0, 0, 200, 300);

    // Disegna una diagonale in posizione (0, 0)
    for (int position = 0; position < 10; position++) {
      g.setColor(Color.YELLOW);
      g.fillRect(position * 10, position * 10, 10, 10);

      g.setColor(Color.RED);
      g.drawRect(position * 10, position * 10, 10, 10);
    }
  }
}
```

Si supponga di voler disegnare questa diagonale in una posizione arbitraria, ad esempio ```java (60, 110)```, è possibile modificare il codice aggiungendo gli offset: #reft(1)

```java
class Panel extends JPanel {
  Panel() { super(); setPreferredSize(new Dimension(200, 300)); }

  @Override
  public void paint(Graphics g) {
    super.paint(g);

    g.setColor(Color.CYAN);
    g.fillRect(0, 0, 200, 300);

    t1 int offsetX = 60, offsetY = 110;

    // Disegna una diagonale in posizione (60, 110)
    for (int position = 0; position < 10; position++) {
      g.setColor(Color.YELLOW);
      g.fillRect(offsetX t1 + position * 10, offsetY x1 + position * 10, 10, 10);

      g.setColor(Color.RED);
      g.drawRect(offsetX t1 + position * 10, offsetY x1 + position * 10, 10, 10);
    }
  }
}
```

O, peggio ancora, si potrebbero inserire gli offset a mano. Ma c'è uno strumento molto più comodo per semplificare il lavoro: ```java Graphics::translate``` #reft(1).

```java
class Panel extends JPanel {
  Panel() {
    super();
    setPreferredSize(new Dimension(200, 300));
  }

  @Override
  public void paint(Graphics g) {
    super.paint(g);

    g.setColor(Color.CYAN);
    g.fillRect(0, 0, 200, 300);

    g.translate(60, 110); t1

    // Disegna una diagonale in posizione (0, 0)
    for (int position = 0; position < 10; position++) {
      g.setColor(Color.YELLOW);
      g.fillRect(position * 10, position * 10, 10, 10);

      g.setColor(Color.RED);
      g.drawRect(position * 10, position * 10, 10, 10);
    }

    g.translate(-60, -110); t2
  }
}
```

Con ```java translate``` #reft(1) è possibile spostare l'origine da cui disegnare. Quindi si può usare il codice relativo a ```java (0, 0)``` e traslarlo alla posizione ```java (60, 110)```. Questa tecnica è molto comoda quando bisogna disegnare oggetti più complessi. 

Dopo aver disegnato la diagonale si usa ```java g.translate(-60, -100)``` #reft(2) per riportare l'origine a ```java (0, 0)``` per il resto del codice.

=== Transformazioni affini 

Castando ```java Graphics g``` a ```java Graphics2D``` si hanno anche più opzioni a disposizione per controllare la grafica:
- traslazione
- scala #reft(2)
- rotazione #reft(3)
- taglio

Con ```java AffineTransform``` c'è anche un modo più comodo per resettare la grafica #reft(1). 

```java
class Panel extends JPanel {
  Panel() {
    super();
    setPreferredSize(new Dimension(200, 300));
  }

  @Override
  public void paint(Graphics g) {
    super.paint(g);

    Graphics2D g2d = (Graphics2D) g;
    AffineTransform defaultTransform = g2d.getTransform() t1;

    g2d.setColor(Color.ORANGE);
    g2d.fillRect(0, 0, 200, 300);

    g2d.scale(2, 2) t2;
    g2d.rotate(0.1) t3;

    for (int position = 0; position < 10; position++) {
      g2d.setColor(Color.YELLOW);
      g2d.fillRect(position * 10, position * 10, 10, 10);

      g2d.setColor(Color.RED);
      g2d.drawRect(position * 10, position * 10, 10, 10);
    }

    g2d.setTransform(defaultTransform) t1;

    for (int position = 0; position < 10; position++) {
      g2d.setColor(Color.YELLOW);
      g2d.fillRect(position * 10, position * 10, 10, 10);

      g2d.setColor(Color.RED);
      g2d.drawRect(position * 10, position * 10, 10, 10);
    }
  }
}
```

Con questi strumenti si può scalare molto facilmente la parte grafica del progetto in base alla dimensione del ```java JFrame``` o in base alle impostazioni dell'utente. Inoltre, ```java scale()``` e ```java rotate()``` sono molto comodi per fare semplici animazioni.

#pagebreak();

== Timer

// https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/Timer.html
// https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/Timer.html
// https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/TimerTask.html

#note[Questa sezione la devo ultimare 😅. Probabilmente, quando sarà completa, sarà molto semplice, con giusto un paio d'esempi e una piccola spiegazione teorica sulle differenze fra i vari ```java Timer```]

Nello sviluppo di un gioco ci sono alcune cose che voremmo fare:
- ritardare un'azione 
- animazioni
- impostare un timer globale (frameRate)
  - per sincronizzare le animazioni
  - per fare i calcoli  
  - etc...

// TODO: link a esempio Minesweeper con timer / gioco impiccato

=== Diversi tipi di ```java Timer``` paragonati


- ```java java.util.Timer``` 
- ```java java.swing.Timer```
- ```java java.util.concurrent.ScheduledExecutorService```

java.util.Timer solo un thread
java.util.conc... etc... schedula le varie cose in modo da evitare quello che si chiama *head of line block*

#note[Un esempio di ```java ScheduledExecutorService``` #link("https://github.com/sapienza-metodologie-di-programmazione/minesweeper/blob/806ff480243753eec70403f74abe555e4ff1114e/src/main/java/minesweeper/controller/Controller.java#L25")[qui]]

=== Ritardare azioni

=== Animazioni

=== Framerate del gioco

#pagebreak()

== In conclusione su Java Swing

Sono state discusse solo *alcune* delle funzionalità di Swing (quelle che ho notato servano più spesso nei progetti). In questa guida non è stato approfondito (in particolare dal punto di vista teorico) come si comporta Swing e cos'è in grado di fare.

Suggerisco di consultare l'API docs di Java https://docs.oracle.com/en/java/javase/21/docs/api/index.html per altre informazioni.

Tutto quello che è stato discusso in questa prima parte del progetto riguarda *solamente* la *View*, ci sono altre due componenti importanti da vedere nel pattern architetturale *MVC* che verranno discusse nella sezione successiva.

#note[Si invita il lettore a reinterpretare il codice presentato e adattarlo al proprio progetto e *stile* :)]

#pagebreak()

= #text(darkred)[MVC]

#align(center, image("assets/mvc.png", width: 100%))

*MVC* è un *pattern architetturale* per sviluppare diversi tipi di applicazioni: web app, interfacce grafiche, TUI (Terminal User Interface) etc... L'idea è quella di *separare* la logica del programma dall'interfaccia. In questo modo la logica è *definita in modo chiaro e pulito*, ed è *riusabile* (più interfacce diverse possono condividere la stessa logica)

Ad esempio, è possibile definire la logica del gioco Solitario una volta sola, e usarla per costruire un sito web, un'applicazione per Windows, un'API REST etc... Il *Model* è condiviso da più *View*.

=== Model

Il *Model* contiene *esclusivamente la logica* del programma: le *entità*, come queste *interagiscono* fra di loro e quali sono gli *stati validi* del programma.

=== View

Nella sezione su *Java Swing* si è visto solo come progettare e implementare una *View*, ora l'obiettivo è quello di progettare e implemenatre un'applicazione completa, mostrando un possibile modo di strutturare il codice per far interagire il Model con l'interfaccia grafica. 

=== Controller

Il *Controller* è il collante fra l'interfaccia e il Model. Ci sono diverse strategie per implementarlo, in questa guida ne sarà discussa una particolarmente semplice.

#pagebreak()

== Minesweeper _(prato fiorito)_

Per mostrare come progettare Model e Controller verrà discussa l'analisi e l'implementazione di un semplice progetto: *Minesweeper* (il cui codice si trova #link("https://github.com/sapienza-metodologie-di-programmazione/minesweeper")[su GitHub])

=== UML e modello

L'analisi inizia con la raccolta dei *requisiti* e la *realizzazione di un modello* del problema (in questo esempio i requisiti sono le regole e le funzionalità del gioco *Minesweeper*). Di seguito un possibile modello per il gioco: 

#align(center, image("assets/uml.png"))

#note[
  #text(darkred)[*ATTENZIONE!*] Questo *NON è il tipo di UML che avete visto a lezione*.
  Questo è un modello più formale (legato all #link("https://en.wikipedia.org/wiki/First-order_logic")[logica di primo ordine]). Si vede in corsi come *Basi di Dati 2*. È più semplice ed astrae i dettagli implementativi del progetto, ma comunque abbastanza potente da permettere di ragionare sulle funzionalità che si vogliono implementare.
]

Questo modello rappresenta i seguenti requisiti:
- vogliamo gestire le partite (Game)
	- ogni partita ha 100 caselle (Tile) 
		- sono disposte in una griglia 10t10
		- c'è un numero variabile di mine da 0 a 100
	- una partita può essere finita (Ended) 
		- caso in cui va segnata la durata
		- può avere uno di tre esiti
			- sconfitta (Loss)
			- vittoria (Victory)
			- terminata dall'utente (Terminated)
	- di ogni partita si devono poter calcolare il numero di mine e il numero di bandiere
- ogni casella (Tile)
	- può essere di uno dei due tipi
		- vuota (Empty)
		- con una mina (Mine)
	- può trovarsi in uno dei tre stati
		- nascosta (Hidden)
		- con una bandiera (Flagged)
		- scoperta (Revealed)
	- di ogni casella si devono poter calcolare le caselle adiacenti
	- di ogni casella vuota si deve conoscere il numero di mine vicine
	
=== Vincoli del modello

Il modello definito sopra è *incompleto*: permette *alcuni stati invalidi*:
- una partita potrebbe essere vinta anche con una mina scoperta 
- una partita potrebbe essere vinta con tutte le caselle nascoste 

Servono dei vincoli (qui scritti in _logica di primo ordine_) per *limitare* i possibili stati del modello. Di seguito due esempi di vincolo.

#note[
Di seguito sono riportati alcuni vincoli, #link("https://github.com/sapienza-metodologie-di-programmazione/minesweeper/blob/main/docs/main.pdf")[qui è possibile consultare il documento completo]
]


#[
  #show sym.space.nobreak : h(20pt)
  #set terms(hanging-indent: 20pt, separator: [#linebreak()])

  #constraint(
    "Game", "victory_condition",
    description: [
      Una partita è vinta in uno di due casi:
      - tutte e sole le caselle con una mina hanno una bandiera
      - tutte le caselle vuote sono scoperte
    ]
  )[
    $forall$ game *Victory*(game) $<==>$ \
    ~ $forall$ tile _mine_game_(tile, game) $==>$ *Flagged*(tile) $and$ \
    ~ $not$ $exists$ tile \
    ~~ _tile_game_(tile, game) $and$ \
    ~~ *Empty*(tile) $and$ \
    ~~ *Flagged*(tile) \
    ~ $or$ \
    ~ $forall$ tile \
    ~~ (_tile_game_(tile, game) $and$ *Empty*(tile) \
    ~~~ $==>$ *Revealed*(tile)) \
  ]

  \

  #constraint(
    "Game", "loss condition",
    description: "Una partita è una sconfitta se e solo se c'è una mina scoperta"
  )[
    $forall$ game \
    ~ *Loss*(game) \
    ~ $<==>$ \
    ~ $exists$ mine _mine_game_(mine, game) $and$ *Revealed*(mine)
  ]
]

\

#note[ In Java questi vincoli sono spesso implementabili con gli ```java Stream``` ]

// #pagebreak()

=== Operazioni sul modello

Bisogna definire un insieme di *operazioni* che un *utente* (o un altro sistema!) deve poter effettuare sul modello. Queste operazioni sono l'interfaccia (l'API) che il Model dovrà fornire a chi lo vuole usare.

- #operation("start_game", type: [*Game*])
- #operation("terminate_game", args: [game: *Game*], type: [*Terminated*]) 
- #operation("reveal", args: [tile: *Hidden*], type: [*Revealed*])
- #operation("flag", args: [tile: *Hidden*], type: [*Flagged*])
- #operation("remove_flag", args: [tile: *Flagged*], type: [*Hidden*])
- #operation("games_played", type: [*Integer* >= 0])
- #operation("games_won", type: [*Integer* >= 0])
- #operation("time", type: [*Duration*])
- #operation("mines", type: [(0..100)])
- #operation("flags", type: [(0..100)])

=== Wireframe

A questo punto rimane solo da progettare l'interfaccia dell'applicazione con un *wireframe* (garantendo le operazioni definite sopra)

#align(center, image("assets/wireframe.png"))

#pagebreak()

== Codice

Nel #link("https://github.com/CuriousCI/minesweeper/tree/main/src/main/java/minesweeper")[codice] del progetto ho deciso di creare un *package* principale chiamato *minesweeper* e di suddividerlo a sua volta in 3 *package* per *model*, *view* e *controller*. Il progetto è piccolo, quindi bastano questi tre. I *package* sono lo strumento più importante per l'*encapsulation*.

=== Model

Di seguito una breve analisi dele classi del model.

```java
package minesweeper.model;

import static minesweeper.model.Tile.Visibility.*;
import java.util.Observable;
import java.util.Optional;

@SuppressWarnings("deprecation")
public class Tile extends Observable t1 {
	t2 public enum Visibility { Hidden, Flagged, Revealed }

	public final int x, y t3;
	public final boolean isMine;
	private Visibility visibility = Hidden;
	t4 Optional<Integer> adjacentMines = Optional.empty();

	t5 Tile(int x, int y, boolean isMine) {
		this.x = x;
		this.y = y;
		this.isMine = isMine;
	}

	public Visibility visibility() { return visibility; }

	t4 public Optional<Integer> adjacentMines() { return adjacentMines; }

	public void reveal() {
		if (visibility != Hidden)
			return;

		t9 setChanged();
		notifyObservers(t6 visibility = Revealed);
	}

	t7 public void flag() {
		t9 setChanged();
		notifyObservers(t6 visibility = x8 switch (visibility) {
			case Hidden -> Flagged;
			case Flagged -> Hidden;
			case Revealed -> {
				clearChanged();
				yield Revealed;
			}
		});
	}
}
```

==== Encapsulation con ```java public final```

Un modo alternativo per ottenere *encapsulation* è quello di segnare un *attributo* come ```java public final``` #reft(3), e di lasciare al *costruttore* la *visibilità di default* #reft(5). In questo modo:
- ```java model.Tile``` può essere istanziata solo con valori validi all'interno del package 
- questi valori possono essere letti ma non modificati

==== Tipizzazione con ```java enum```

I tipi di visibilità delle ```java Tile``` (```java Hidden```, ```java Flagged``` e ```java Revealed```)  sono definiti tramite ```java enum``` #reft(2). Il tipo ```java Visibility``` è definito *internamente* alla classe ```java Tile``` per poter usare la notazione ```java Tile.Visibility``` che trovo più leggibile. Inoltre non serve creare un altro file per questo ```java enum```, facilitando la *navigabilità del codice*.

==== Valori indefiniti: ```java null``` vs ```java Optional<T>```

In alcuni casi *ha senso ed è utile* avere attributi che potrebbero essere *indefiniti* (```java adjacentMines``` #reft(4) non è definito se la ```java Tile``` è una mina).

Usare ```java null``` è scomodo: chi usa la libreria *deve scoprire*, tramite la documentazione, che quell'attributo potrebbe non essere definito. 

Con ```java Optional<T>``` si *dichiara esplicitamente nel codice* che l'attributo potrebbe essere indefinito (```java Optional.empty()```), e chi usa l'attributo *deve gestire* il caso in cui il valore non c'è.

==== Le ```java switch``` expression (```java switch``` con steroidi)

In Java 14 sono state uficializzate le ```java switch``` expression #reft(8) che possono restituire un valore e non necessitano dell'utilizzo di ```java break;``` (vedere il metodo ```java flag()``` #reft(7)). 

==== Gli assegnamenti come espressioni

In Java gli assegnamenti alle variabili sono espressioni: ad esempio, ```java y = (x = 5)``` assegna ```java 5``` a ```java x```, e ritorna ```java 5``` per assegnarlo a ```java y``` #reft(6).

==== Observer Pattern

Per la casella ho deciso di usare l'*Observer Pattern* #reft(1) per due motivi:
- notificare la View (per ridisegnare la casella)
- notificare le altre classi del Model (la classe ```java Game``` deve sapere quando una ```java Tile``` cambia stato, per decidere se terminare la partita o rivelare le caselle adiacenti)

#note[Per notificare gli Observer, bisognare usare ```java setChanged``` #reft(9) prima di inviare la notifica.]

#pagebreak()

```java
@SuppressWarnings("deprecation")
public class Game extends Observable implements Observer {

	// ...

	final Tile[] tiles = new Tile[100];
	public final int mines;
	int flags = 0;
	Duration time = Duration.ofSeconds(0);

	public Game() {
		Random random = new Random(); t1

		for (int y = 0; y < 10; y++)
			for (int x = 0; x < 10; x++)
				tiles[y * 10 + x] = new Tile(x, y, random.nextInt(100) >= 15 ? Empty : Mine);

		for (Tile tile : tiles) {
			tile.addObserver(this);

			int adjacentMines = (int) t2 adjacent(tile.x, tile.y)
					.filter(t -> t.kind == Mine)
					.count();

			if (tile.kind == Empty && adjacentMines > 0)
				tile.adjacentMines = Optional.of(adjacentMines);
		}

		mines = (int) t2 Stream.of(tiles)
				.filter(t -> t.kind == Mine)
				.count();
	}

	public void updateTime() {
		time = time.plusSeconds(1);
		setChanged();
		notifyObservers(Message.Timer);
	}

	// ...

```

Un errore che ho visto in vari progetti è quello di creare un attributo per ogni variabile. Ad esempio: alcuni hanno creato un attributo ```java Random random``` #reft(1) per la classe ```java Game```, nonostante questo venga usato solo nel costruttore #reft(1). *NON* c'è bisogno di *creare un attributo per ogni variabile*.

==== Alcuni esempi di ```java Stream```

Nella classe ```java model.Game``` ci sono alcuni esempi di ```java Stream``` #reft(2).

==== Gestione del timer

Il *Model* non dovrebbe gestire l'eventuale *timer*, quello è un compito del *Controller*. Mettendo il *timer* fuori dal *Model* diventa più facile mettere in *pausa* il gioco.

Il *Model* dovrebbe semplicemente avere un metodo ```java update()``` (nel mio caso ```java updateTime()```) che deve essere invocato dal *Controller* quando scatta il *timer*.

#pagebreak()

==== Il metodo ```java update(Observable o, Object arg)``` e ```java instanceof```

```java
@Override
public void update(Observable o, Object arg) {
	if (!(o instanceof Tile tile t1 && arg instanceof Visibility visibility x1))
		return;

	setChanged();

	switch (visibility) {
		case Flagged -> flags++;
		case Hidden -> flags--;
		case Revealed -> {
			if (tile.isMine t2) {
				notifyObservers(Loss);
				deleteObservers();
				return;
			}

			if (tile.adjacentMines().isEmpty())
				adjacent(tile).forEach(Tile::reveal);

			boolean allEmptyRevealed = t3 Stream.of(tiles)
					.allMatch(t -> t.isMine || t.visibility() == Revealed);

			boolean allMinesFlagged =  t3 Stream.of(tiles)
					.allMatch(t -> !(t.isMine ^ t.visibility() == Flagged));

			if (allEmptyRevealed || allMinesFlagged) {
				notifyObservers(Victory);
				deleteObservers();
			}
		}
	}

	notifyObservers(tile);
}
```

Le versioni più recenti di Java hanno introdotto la sintassi ```java o instanceof Tile tile``` #reft(1) per il casting:
- se ```java Object o``` non è un'istanza di ```java Tile``` ritorna ```java false```
- se ```java Object o``` è un'istanza di ```java Tile``` ritorna ```java true``` e genera ```java Tile tile = (Tile)o```

In questo esempio si può vedere anche l'implementazione dei vincoli [Constraint.*Game*.loss_condition] #reft(2) e [Constraint.*Game*.victory_condition] con gli ```java Stream``` #reft(3).

#note[La ```java switch``` expression permette anche di fare casting per #link("https://www.baeldung.com/java-switch-pattern-matching#1-type-pattern")[casi in cui si devono gestire più tipi].]

#pagebreak()

=== Controller

Il *Controller*, in questa scelta d'implementazione, ha il compito di *definire gli eventi* #reft(2) generati dalla View, specificando le interazioni #reft(3) con il Model e assegnando gli Observer #reft(1). Inoltre, è il Controller a gestire il ```java timer``` #reft(4). 


```java
public class Controller {
    private Optional<ScheduledFuture<?>> timer;
    private ScheduledExecutorService scheduler;
    private Optional<Game> game;

    public Controller(Minesweeper model, View view) {
        scheduler = Executors.newScheduledThreadPool(1);
        t1 model.addObserver(view.menu());
        model.load();

        view.menu().play().addActionListener(t2 e -> {
            Game game = new Game();

            t1 game.addObserver(model);
            t1 game.addObserver(view.play());
            t1 game.addObserver(view.play().canvas());
            t3 game.start();

            this.game = Optional.of(game);
            t4 timer = Optional.of(
              scheduler.scheduleAtFixedRate(
                () -> x3 game.update(), 1, 1, TimeUnit.SECONDS));
        });

        view.play().end().addActionListener(t2 e -> {
            t4 timer.ifPresent(t -> t.cancel(true));
            t3 game.ifPresent(Game::end);
        });

        view.play().canvas().addMouseListener(
          t2 new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                game.ifPresent(game -> {
                    Canvas canvas = view.play().canvas();

                    int x = (e.getX() - canvas.getWidth() / 2 + 
                            5 * Canvas.SCALE) / 30;
                    int y = (e.getY() - canvas.getHeight() / 2 + 
                            5 * Canvas.SCALE) / 30;

                    switch (e.getButton()) {
                        case MouseEvent.BUTTON1 -> 
                          t3 game.tiles[y * 10 + x].reveal();
                        case MouseEvent.BUTTON3 -> 
                          t3 game.tiles[y * 10 + x].flag();
                        default -> {}
                    }
                });
            }
        });
    }

}
```

#note[Esistono altre strategie per implementare il Controller, ma questo è una delle più semplici. Una *strategia più comoda* potrebbe essere quella di definire un'*interfaccia* per elencare le possibili interazioni che il Controller deve definire, e fare in modo che la View implementi tale interfaccia.]

=== View

La parte di *View* è stata largamente discussa nella prima parte di questa guida. Il lettore è invitato a #link("https://github.com/sapienza-metodologie-di-programmazione/minesweeper/tree/main/src/main/java/minesweeper/view")[consultare il codice del progetto] per eventali dubbi.

== In conclusione su MVC

L'obiettivo di questa sezione è stato quello di fornire un semplice esempio di progetto realizzato con il pattern architetturale MVC, e alcuni consigli pratici e trucchi per scrivere il codice del Model. 

Gli strumenti forniti fino a questo punto dovrebbero bastare per *lavorare serenamente al progetto*. Il capitolo successivo serve per chi vuole chiudere il progetto con la _"ciliegina sulla torta"_ (o anche solo per curiosità) usando gli strumenti che si usano tipicamente in *produzione* nei progetti reali.

#pagebreak()

// == Lavorare in gruppo

// === Merge conflict

= #text(darkred)[Integrare il progetto con GitHub]

Prima di procedere con l'utilizzo di *GitHub* è fondamentale aver compreso bene il funzionamento di #link("https://github.com/sapienza-metodologie-di-programmazione/guide/releases/tag/latest")[```bash git``` (guida scritta per il corso)]. GitHub è un forge per repository git che offre una vasta serie di funzionalità per supportare gli sviluppatori.

#note[Prima di procedere con questa parte è fondamentale aver capito la differenza fra git e GitHub e come vengono usati: trovate tutte le informazioni utili in #link("https://github.com/sapienza-metodologie-di-programmazione/guide/releases/tag/latest")[questa guida].]

== Usare una project manager _(Maven)_

Gestire un progetto Java crudo è abbastanza complicato: si presentano tutta una serie di problemi:
- se si vuole aggiungere una libreria bisogna scaricarla e configurarla manualmente
- la struttura del progetto dipende dall'editor, tanto che passare il progetto su un altro editor o su una versione vecchia dello stesso editor è estremamente difficile (e richiede molta configurazione manuale)
- è più complicato eseguire il progetto su un server (Ex. GitHub Action) se si è legati ad un'editor
- serve un risultato consistente
- serve poter automatizzare alcune azioni / poter usare script etc...

Uno dei package manager più famosi per Java (e dei più semplici da usare) è *Maven* (ce ne sono altri come Gradle etc... ad esempio, per progetti Android bisogna usare Gradle etc...)

Maven può essere usato in tutti gli editor: VSCode, Eclipse, Intellij, anche da terminale (è molto comodo da terminale, personalmente lo uso con Neovim)! E risolve tutti i problemi sopra elencati. 

#note[
  per ogni linguaggio di programmazione "mainstream" esiste un qualche tipo di project manager / package manager: 
  - ```bash npm``` per JavaScript
  - ```bash cargo``` per Rust
  - ```bash pip``` per Python
  - etc...
]


// - cos'è un package manager (per Java e in generale)
// - è comodo quando più persone lavorano sullo stesso progetto, ognuno può usare l'editor che vuole, e il risultato sarà lo stesso
// - perché consiglio Maven: è un po' più semplice da usare rispetto a Gradle (nel contesto del progetto)
  // - es: non devo ricordare il comando per generare l'eseguibile, lo fa un plugin 
- come scaricare Maven
  - Windows: https://maven.apache.org/download.cgi
  - Ubuntu/Debian: ```bash sudo apt-get install maven```
- come creare un progetto maven
```bash
mvn archetype:generate -DgroupId=<package-principale> -DartifactId=<nome-del-progetto> -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

- sostituite al posto di ```bash <package-principale>``` il nome del package principale del progetto
- sostituite al posto di ```bash <nome-del-progetto>``` il nome della cartella in cui generare il progetto
- ```bash -DarchetypeArtifactId=maven-archetype-quickstart``` serve a specificare quale "template" usare per inizializzare il progetto
- ```bash -DinteractiveMode=false``` disabilita il prompti interattivo per le altre impostazioni (mettetelo ```bash =true``` se volete vedere le altre impostaizoni)

ora si può scrivere il codice

Molto facile da usare dai vari editor, ci sono comandi come 
- mvn install 
- mvn exec:java 
- mvn javadoc:javadoc 
- mvn test
- mvn clean

== GitHub Pages

#link("https://pages.github.com/")[GitHub Pages] è uno strumento che permette di pubblicare (gratuitamente) siti web *statici* tramite GitHub (come può essere il caso di *javadoc*).

== Releases

Le #link("https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases")[Releases] permettono di pubblicare file scaricabili: eseguibili di programmi, documenti, asset etc...

== GitHub Actions

Le #link("https://github.com/features/actions")[GitHub Action] sono uno strumento che permette di *automatizzare* tutti i processi legati alla produzione del software: testing, generazione di documentazione, generazione di eseguibili, deploy su server, pubblicazione di librerie etc... 

Le GitHub Action si possono usare insiemea a GitHub Pages per *generare la documentazione* del progetto e *pubblicarla online*.

Si possono usare anche insieme a GitHub Releases per *generare l'eseguibile* del progetto e pubblicarne la versione scaricabile.

Di seguito si vedono due GitHub Action che automatizzano proprio queste due funzionalità.  

#pagebreak()

=== Anatomia di una GitHub Action

Per creare un'Action basta creare una cartella `.github/workflows/` all'interno del progetto e aggiungervi un file con estensione `.yml` (#link("https://yaml.org/")[YAML]) in cui descrivere i compiti dell'Action (ad esempio `progetto/.github/workflows/javadoc.yml`).

```yaml
name: Publish Docs t1

on: [push t2, workflow_dispatch x3] 

permissions: t4
  contents: read
  pages: write
  id-token: write

jobs: t5
  build:
    runs-on: ubuntu-latest t6
    steps:
      - uses: actions/checkout@v4 t7

      # ... steps ... t8

      - run: mvn install javadoc:javadoc t9

      # ... steps ...t8
```

Analisi della GitHub Action:
- #reft(1) imposta il nome dell'Action
- ```yaml on:``` serve a specificare quando deve essere eseguita l'Action, in particolare:
  - #reft(2) specifica che l'Action va eseguita quando c'è un ```bash push``` nel repository
  - #reft(3) permette di invocare l'Action manualmente (dal sito di GitHub, nella sezione "Actions" del repository)
- se l'Action deve eseguire alcune azioni particolari (ad esempio pubblicare su GitHub Pages) ha bisogo dei permessi #reft(4) per poterlo fare (permessi che bisogna specificare esplicitamente per motivi di sicurezza) 
- #reft(5) l'Action deve eseguire uno o più compiti in sequenza
- per poter essere eseguita, l'Action ha bisogno di una macchina virtuale su cui girare, e bisogna specificarne il Sistema Operativo #reft(6)
- spesso si usano _"ricette"_ già pronte #reft(7), ad esempio, ```yaml actions/checkout``` carica il repository all'interno della VM per poterci lavorare sopra
- #reft(8) naturalmente, nei vari step si possono usare anche i comandi messi a disposizione dal Sistema Operativo scelto per far girare l'Action:
  - si possono anche scaricare pacchetti
  - la macchina ha accesso a internet 
- in particolare, per generare la documentazione del progetto, avendo usato Maven, basta eseguire il i comandi  ```bash mvn install``` e ```bash mvn javadoc:javadoc``` #reft(9)

#pagebreak()

=== Generare e pubblicare la documentazione in automatico

File `.github/workflows/javadoc.yml`

#note[Nel progetto #link("https://github.com/sapienza-metodologie-di-programmazione/minesweeper")[Minesweeper] sono presenti entrambe le GitHub Action discusse in questa sezione]

Oltre ai comandi del Sistema Operativo (che si possono invocare con ```yaml - run: comando```) è possibile usare delle ricette "già pronte" e configurabili, ad esempio: `actions/checkout`, `actions/setup-java`, `actions/configure-pages`, `actions-upload-pages-artifact`, `actions/deploy-pages` etc...

Queste "ricette" semplificano il lavoro di configurare gli strumenti necessari e permettono di interagire con API (come quello di GitHub Pages, per pubblicare la documentazione generata).

```yaml
name: Publish Docs

on: [push, workflow_dispatch]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
      - run: mvn install javadoc:javadoc
      - uses: actions/configure-pages@v5
      - uses: actions/upload-pages-artifact@v3
        with:
          path: target/reports/apidocs
  deploy:
      environment:
        name: github-pages
        url: ${{ steps.deployment.outputs.page_url }}
      runs-on: ubuntu-latest
      needs: build
      steps:
        - uses: actions/deploy-pages@v4
```

#pagebreak()

=== Generare l'eseguibile in automatico

File `.github/workflows/jar.yml`

```yaml
name: Build JAR
on: [push, workflow_dispatch]

permissions:
  contents: write
  id-token: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
      - run: mvn clean compile assembly:single
      - name:
        uses: marvinpinto/action-automatic-releases@latest
        with:
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          automatic_release_tag: 'latest'
          prerelease: false
          files: target/*.jar         
      - uses: dev-drprasad/delete-older-releases@v0.3.3
        with:
          keep_latest: 1
          delete_tags: true
          delete_tag_pattern: latest 
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#note[Un altro esempio di GitHub Action è quella usata per generare #link("https://github.com/sapienza-metodologie-di-programmazione/guide/blob/main/.github/workflows/release.yml")[questo stesso .pdf] :)]


#pagebreak()

= #text(darkred)[Tips & tricks]

== Compressione di immagini e audio 

=== Cosa fare se lo ```bash .zip``` pesa troppo per la consegna 

Per i progetti web una delle metriche più importanti è quella della "velocità di caricamento" del sito, avendo tutta una serie di conseguenze sulla performance del sito. Per ottimizzare questa metrica quello che si fa è provare a minimizzare il peso degli asset (immagini, video, audio, etc...) e del codice. 

Questo generalmente non avviene per i giochi (ci sono giochi che pesano anche 100GB+). Però, nel costensto specifico del progetto, per poter consegnare, potrebbe essere utile risparmiare un po' di spazio.

=== Compressione lossy vs loseless

Generalmente esistono due modi di comprimere gli asset: 
- *loseless*: la qualità dell'asset non cambia, e si risparmia un po' di spazio 
- *lossy*: la qualità dell'asset è inferiore, ma si risparmia molto più spazio

=== Esempio di compressione

Quanto va ad impattare realmente la compressione? Consideriamo l'esempio di un'immagine 1920 #sym.times 1080. Per rappresentare ogni pixel sono necessari 4 byte (#link("https://en.wikipedia.org/wiki/RGBA_color_model")[RGBA]), quindi, un'immagine 1920 #sym.times 1080 dovrebbe pesare 
- 1920 #sym.times 1080 #sym.times 4 byte #sym.tilde.eq 8100 KB. 

#figure(
  image("assets/example.png"),
  caption: [immagine ```bash .png``` 1920 #sym.times 1080 pixel],
) <compression>


Consideriamo l'immagine in @compression: nonostante i nostri calcoli, il formato ```bash .png``` con compressione *loseless* la porta a circa 885 KB (un risparmio del 90%!), ma si può fare meglio? Su Windows è possibile ridimensionare l'immagine direttamente dal programma di preview di default (@windows-compression), e usando la compressione *lossy* ```bash .jpg```, con perdità di qualità del 50% si arriva a 417 KB, e spesso la perdita di qualità non si percepisce neanche. 

#figure(
  image("assets/resize.png"),
  caption: [su Windows è possibile ridimensionare e comprimere le immagini]
) <windows-compression>

#note[Il peso finale dopo la compressione dipende molto anche dal contenuto dell'immagine: un'immagine 1920 #sym.times 1080 interamente nera si può comprimere in maniera molto più efficace rispetto ad un'immagine ricca di dettagli]

=== Compressione audio

Lo stesso discorso sulla compressione loseless e lossy si può applicare per gli audio (che ho notato essere più problematici): consiglio di usare un formato di compressoine lossy come ```bash .mp3```, e di provare a tagliare dove possibile (usando audio più brevi, o di qualità inferiore).

#pagebreak()

== LSP + Formattazione automatica del codice

Nel 2016 la Microsoft ha sviluppato il protocollo #link("https://microsoft.github.io/language-server-protocol/")[LSP] (Language Server Protocol), che ha permesso di sviluppare i Language Server: programmi che offrono funzionalità di *supporto per lo sviluppo di codice*: suggerimenti, autocompletamento, formattazione del codice, diagnostica, linting etc...

La maggior parte degli *editor moderni* (fra cui anche Eclipse) non fanno altro che offrire un'interfaccia grafica per i Language Server (con shortcut, syntax highlighting, configurazione etc...).

Uno dei Language Server più usati per Java è proprio quello di #link("https://github.com/eclipse-jdtls/eclipse.jdt.ls")[Eclipse]. Una delle funzionalità più importanti che offre è la *formattazione del codice*, che permette di mantenere il codice *consistente* e *pulito*, specialmente quando si lavora in un team. Eclipse (come tanti altri editor) permette di invocare questa funzionalità automaticamente ogni volta che il codice viene salvato:

#align(image("assets/format-on-save.png" ), center)

== Shortcut per gli editor

Nella maggior parte degli editor è possibile commentare velocemente il codice (anche più righe alla volta) usando la shortcut `Ctrl + /` 


// #let tag(tag) = box(
//   height: 1em, clip: true, baseline: 0.2em,
//   circle(
//     fill: black, inset: 0.1em,
//     align(center + horizon, text(white, size: 0.7em)[*#tag*])
//   )
// )

// #set page(margin: 1.5cm)
// #set page(margin: 1in)

// #set text(font: "Cascadia Code", weight: "light", lang: "it")

// #set text(font: "New Computer Modern", lang: "en", weight: "light", size: 11pt)
// #set page(margin: 1.75in)
// #set par(leading: 0.55em, spacing: 0.85em, first-line-indent: 1.8em, justify: true)
// #set heading(numbering: "1.1")
// #set math.equation(numbering: "(1)")


// #show figure: set block(breakable: true)
// #show figure.caption: set align(center)
// #show outline.entry.where(level: 1): it => { show repeat : none; v(1.1em, weak: true); text(size: 1em, strong(it)) }
// #show figure.where(kind: raw): it => { set align(left); it }



// #show link: it => underline[#text(navy)[#it]]
// #show raw.where(block: true): it => block(fill: luma(250), inset: 2em, width: 100%, stroke: (left: 2pt + luma(230)), it)
// #show raw: r => {
//   let re = regex("x(\d)")
//   show re: it => { 
//     let tag = it.text.match(re).captures.at(0)
//     box(
//       baseline: 0.2em, 
//       circle(
//         fill: black, inset: 0.1em, 
//         align(center + horizon, text(white, size: 0.8em)[*#tag*])
//       )
//     )
//   }
//
//   r
// }
// #let tag(reft) = box(width: 8pt, place(dy: -8pt, 
//   box(radius: 100%, width: 9pt, height: 9pt, inset: 1pt, stroke: .5pt, // fill: black,
//     align(center + horizon, text(font: "CaskaydiaCove NFM", size: 7pt, repr(reft)))
//   )
// ))

// Di seguito l'implementazione del wireframe in @wireframe-1 
// Proviamo ad implementare il *wireframe* in @wireframe-1
// #pagebreak()
