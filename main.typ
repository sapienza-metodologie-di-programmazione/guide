#let darkred = rgb(192, 0, 0)
#let background = rgb(251, 251, 251)

#set text(10pt, font: "Cascadia Code")
#set underline(offset: 3pt)
#set page(margin: 1.5cm)
#set figure(supplement: [Figura])


#show regex("JFrame|JButton|JPanel|JLabel"): set text(blue)
#show link: it => underline[#text(blue)[#it#h(3pt)#text(size: 7pt)[(doc)]]]
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

// #set raw(theme: "halcyon.tmTheme")
#show raw.where(block: true): view

#align(center, text(17pt)[ *Un approccio pratico a #text(darkred)[Java Swing] e #text(darkred)[MVC]* ])

\

#outline(title: [Sommario], indent: 1.5em)

#pagebreak()

= #text(darkred)[Java Swing]

L'obiettivo di _questa guida_ è dare, tramite esempi pratici, gli *strumenti fondamentali* per lo _sviluppo agevole_ di interfacce grafiche. 

// Questa è una guida molto *breve* e *semplificata*.
// sulle funzionalità principali serve solo come introduzione per semplificare il lavoro per eventuali progetti.

== Wireframe

Per sviluppare un'interfaccia grafica (per un sito web, un'applicazione, un gioco etc...) è utile disegnare un *wireframe* fatto di *rettangoli*, *testo* e *icone* come in @wireframe-1. 

Il *wireframe* serve perché è difficile progettare un'interfaccia *intuitiva* e *funzionale*. Una volta progettata l'interfaccia *scrivere il codice è semplice*, perché abbiamo un'idea chiara di quello che vogliamo, e dobbiamo solo disegnarlo.

\
#figure(
  image("assets/wireframe-1.png"),
  caption: [esempio di wireframe disegnato con #link("https://excalidraw.com")[excalidraw]],
)  <wireframe-1>
\

Proviamo ad implementare il *wireframe* in @wireframe-1

#v(1cm)

#pagebreak()

== Implementazione passo passo di un wireframe 

Il codice completo è *in fondo alla spiegazione*

=== Creare una finestra con #link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/JFrame.html")[JFrame]

```java
JFrame frame = new JFrame("Questo \u00E8 un titolo");
frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

try {
  frame.setIconImage(ImageIO.read(new File("icon.png")));
} catch (IOException e) { }

frame.setSize(600, 400);
frame.setLocationRelativeTo(null);
frame.setVisible(true);
```

- ```java new JFrame(String title)``` crea una finestra _invisibile_ con il titolo specificato

- ```java setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)``` termina il programma quando la finestra viene chiusa (di default la finestra viene _nascosta_)

- ```java setIconImage(Image image)``` imposta l'icona in alto a sinistra della finestra

#note[ 
  Non lasciate l'icona di default! Fate vedere un po' di attenzione ai dettagli :)
]

- ```java setSize(int width, int height)``` imposta la dimensione della finestra

#note[
  Esistono altre strategie per dimensionare la finestra:
  - ```java frame.pack()``` imposta larghezza e altezza al valore _minimo_ che rispetta il contenuto della finestra
  _Se la finestra non ha contenuto_, la larghezza e l'altezza vengono impostati a 0  
]

- ```java setLocationRelativeTo(null)``` posiziona la finestra al centro dello schermo

- ```java setVisible(true)``` rende la finestra _visibile_

==== Errori comuni 

Se la finestra *non rispetta la dimensione impostata* con ```java setSize(int width, int height)``` probabilmente state usando anche ```java pack()``` nel codice (non vanno usati entrambi).

Se usando ```java pack()``` *larghezza e altezza sono impostati a 0* è perché state usando ```java pack()``` _prima_ di aggiungere il contenuto alla finestra. 

#pagebreak()

=== Aggiungere contenuti a una finestra con #link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/JPanel.html")[JPanel]

```java
JPanel panel = new JPanel();
JLabel label = new JLabel("Questa \u00E8 una finestra!");

panel.add(label);
frame.add(panel);
```

Sia ```java JFrame``` sia ```java JPanel``` sono ```java java.awt.Container```, quindi possiamo aggiungere contenuto (testo, immagini, pulsanti etc...) al loro interno tramite ```java add(Component comp)```.

- ```java JPanel``` occuperà l'intero spazio disponibile nella finestra
- ```java JLabel``` serve a visualizzare testo (```java "Questa è una finstra"``` @wireframe-1)

==== Colori, font e personalizzare lo sfondo con ```java paintComponent(Graphics g)```

Ora l'obiettivo è quello di colorare lo sfondo e il testo come in @wireframe-1

#note[
  Normalmente un *wireframe* _non prevede_ colori o scelte stilistiche, ma nel caso di un progetto piccolo possiamo permetterci di usarlo come se fosse un design 
]

```java
JPanel panel = new JPanel() {
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
```

```jframe JPanel``` viene visualizzato invocando il metodo ```java paint(Graphics g)``` tramite ```java repaint()```. A sua volta ```java paint(Graphics g)``` invoca in ordine:
- ```java paintComponent(Graphics g)```
- ```java paintBorder(Graphics g)```
- ```java paintChildren(Graphics g)```

Creando una *classe anonima* possiamo sovrascrivere il comportamento di uno di questi metodi. Nel nostro esempio, sovrascriviamo ```java paintComponent(Graphics g)``` per disegnare lo sfondo con le linee oblique in @wireframe-1.

Questo approccio è molto flessibile, perché con ```java Graphics g``` possiamo disegnare immagini, testo e figure programmaticamente (quindi eventualmente *animazioni*).

#note[Il font ```java "Cascadia Code"``` non è installato di default, provate anche con altri font]

#pagebreak()

Risultato

\
#align(image("assets/gui-1.png", width: 65%), center)
\

=== Centrare un elemento con #link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/GridBagLayout.html")[GridBagLayout]


```java
JPanel panel = new JPanel(new GridBagLayout());
```

Il costruttore ```java JPanel(LayoutManager layout)``` permette di specificare una *strategia* per *posizionare* e *dimensionare* il contenuto di un ```java JPanel``` in #text(darkred)[*automatico*]: 
- non bisogna calcolare a mano `x`, `y`, `width` e `height` dei componenti, lo fa il ```java LayoutManager```
- funziona anche quando la *finestra viene ridimensionata*

#note([```java LayoutManager``` è un esempio di #link("https://refactoring.guru/design-patterns/strategy")[Strategy Pattern]])

Per *centrare un elemento* in un panel si usa un ```java GridBagLayout```

\
#align(image("assets/gui-2.png", width: 65%), center)

=== Implementazione 

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

#text(darkred)[*Java*] mette a disposizione uno strumento che si chiama *instance initialization block*, un blocco di codice che viene eseguito dopo aver invocato il costruttore. È specialmente comodo quando si istanziano *classi anonime*.

```java
class Persona {
  String nome;
}

class Main {
  public static void main(String[] args) {
    Persona rossi = new Persona() {
			{
				nome = "Rossi";
			}
		};
		System.out.println(rossi.nome); // Rossi
  }
}
```

#v(0.5cm)

Possiamo sfruttare questa strategia per riscrivere il codice di prima senza variabili. 

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

				int density = 5;
				g.setColor(Color.decode("#ffec99"));
				for (int x = 0; x <= getWidth() + getHeight(); x += density)
					g.drawLine(x, 0, 0, x);
			}
		});

		setSize(600, 400);
		setLocationRelativeTo(null);
		setVisible(true);
	}

	public static void main(String[] args) {
		new App();
	}
}
```

#pagebreak()

== Modificare l'aspetto dell'interfaccia con #link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/UIManager.html")[UIManager]

Per gestire l'aspetto dei componenti e il loro comportamento in Java Swing viene usata la classe #link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/LookAndFeel.html")[LookAndFeel]. È possibile modificare *globalmente* l'aspetto del ```java LookAndFeel``` impostato tramite la classe ```java UIManager```. 

Ad esempio, per impostare il ```java Font``` di default di tutti i ```java JLabel``` a ```java "Cascadia Code"```

```java
UIManager.put("Label.font", new Font("Cascadia Code", Font.PLAIN, 14));
```


#note[ ```java UIManager``` è un esempio di #link("https://refactoring.guru/design-patterns/singleton")[Singleton Pattern]]

```java
import java.awt.Color;
import java.awt.Font;

import javax.swing.UIManager;

public class App {
  static {
    UIManager.put("Label.font", new Font("Cascadia Code", Font.PLAIN, 14));
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

#note[
  Un elenco delle #link("https://github.com/CuriousCI/minesweeper/blob/main/keys.txt")[possibili chiavi]
]

Per stampare l'elenco di chiavi disponibili:

```java
javax.swing.UIManager.getDefaults().keys().asIterator().forEachRemaining(System.out::println);
```

== Pulsanti

== Immagini

== Animazioni

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
\

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

==== Funzionamento del ```java BorderLayout```

// ```java
// new JPanel(new BorderLayout()) {
//   {
//     add(new JPanel(), BorderLayout.CENTER);
//     add(new JPanel(), BorderLayout.NORTH);
//     add(new JPanel(), BorderLayout.SOUTH);
//     add(new JPanel(), BorderLayout.WEST);
//     add(new JPanel(), BorderLayout.EAST);
//   }
// }
// ```

Il ```java BorderLayout``` permette di specificare in quale posizione mettere un componente, secondo certe regole:
- il componente ```java CENTER``` occuperà tutto lo spazio possibile 
- i componenti ```java NORTH``` e ```java SOUTH```  avranno larghezza massima (indipendentemente dalla larghezza impostata) e avranno altezza minima, o, se impostata, l'altezza impostata
- i componenti ```java WEST``` e ```java EAST```  avranno altezza massima (indipendentemente dall'altezza impostata) e avranno larghezza minima, o, se impostata, la larghezza impostata

Il costruttore ```java BorderLayout(int vgap, int hgap)``` imposta uno "spazio" verticale e orizzontale fra due componenti.

#align(image("assets/borderlayout-3.png"), center)

#pagebreak()

=== #link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/CardLayout.html")[CardLayout]

==== Menu, impostazioni e partita _(cambiare schermata con Sigleton e Observer)_

Il ```java CardLayout``` è molto utile quando abbiamo più schermate (menu principale, impostazioni, partita etc...)

#figure(
  image("assets/wireframe-3.png"),
  caption: [caso d'uso di un ```java CardLayout```],
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
				add(new MenuPanel(), "Menu");
				add(new SettingsPanel(), "Settings");
				add(new GamePanel(), "Game");
			}
		});

		((CardLayout) panel.getLayout()).show(panel, "Menu");
    // ...
	}

	public static void main(String[] args) { new App(); }
}
```

Ad ogni schermata bisogna associare un *nome* quando viene aggiunta al ```java JPanel``` con il ```java CardLayout```. Per visualizzare la schermata che vogliamo basta usare il metodo 
- ```java show(Container parent, String name)``` del ```java CardLayout```

```java
((CardLayout) panel.getLayout()).show(panel, "Menu");
```

Questo approccio ha 2 problemi:
- è facile sbagliare il nome della schermata, essendo una stringa
- non c'è un elenco esplicito delle schermate disponibili

==== Usando gli enum

Per ovviare a questi problemi, si può usare un ```java enum```

```java
enum Screen { Menu, Settings, Game }

public class App extends JFrame {
	App() {
		super("JGioco"); // ...
		JPanel panel;

		add(panel = new JPanel(new CardLayout()) {
			{
				add(new MenuPanel(), Screen.Menu.name());
				add(new SettingsPanel(), Screen.Settings.name());
				add(new GamePanel(), Screen.Game.name());
			}
		});

		((CardLayout) panel.getLayout()).show(panel, Screen.Game.name());
	}

	public static void main(String[] args) { new App(); }
}
```

Il problema è che per poter *cambiare schermata*, bisogna passare ai vari componenti l'istanza di ```java App``` di cui vogliamo cambiare la schermata, creando un groviglio di *spaghetti code*. Ma c'è una soluzione per ovviare anche a questo problema.

#pagebreak()

==== Singleton + Observer

```java
enum Screen { Menu, Settings, Game }

@SuppressWarnings("deprecation")
class Navigator extends Observable {
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
public class App extends JFrame implements Observer {
	JPanel panel;

	App() {
    // ...

		Navigator.getInstance().addObserver(this);

		add(panel = new JPanel(new CardLayout()) {
			{
			  add(new MenuPanel(), Screen.Menu.name());
			  add(new SettingsPanel(), Screen.Settings.name());
			  add(new GamePanel(), Screen.Game.name());
			}
		});

    // ...
	}

	@Override
	public void update(Observable o, Object arg) {
		if (o instanceof Navigator && arg instanceof Screen)
			((CardLayout) panel.getLayout()).show(panel, ((Screen) arg).name());
	}

	public static void main(String[] args) {
		new App();
		Navigator.getInstance().navigate(Screen.Settings);
	}
}
```

- ```java Navigator``` è la classe che permette di cambiare schermata 
  - usa il pattern *Singleton* perché deve avere una sola istanza globale
  - usa il pattern *Observer* per notificare gli ```java Observer``` dei cambiamenti di schermata 
  - per cambiare schermata, _da qualsiasi parte del codice_, basta usare ```java Navigator.getInstance().navigate(Screen.Schermata);```
- ```java App``` 
  - è un *Observer* per poter essere notificato tramite ```java update(Observable o, Object arg)``` dei cambiamenti di schermata
  - usa ```java Navigator.getInstance().addObserver(this);``` per osservare l'unica istanza di ```java Navigator```

#pagebreak()

=== #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/java/awt/GridLayout.html")[GridLayout]

Non è un layout particolarmente complesso: permette di specificare il numero di righe, il numero di colonne, e lo spazio fra due componenti.  


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

		UIManager.put("Button.border", BorderFactory.createCompoundBorder(
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
				setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));
				for (int digit = 0; digit <= 9; digit++)
					add(new JButton(String.valueOf(digit)));
				add(new JButton("+"));
				add(new JButton("="));
			}

			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);

				int density = 5;
				g.setColor(Color.decode("#ffec99"));
				for (int x = 0; x <= getWidth() + getHeight(); x += density)
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

= #text(darkred)[MVC]

== Minesweeper _(prato fiorito)_

== Model

== Controller

== View

// == boh, qualche esempio?


= #text(darkred)[git]

== Lavorare in gruppo

=== Merge conflict

== GitHub Actions

=== Generare la documentazione in automatico

=== Generare l'eseguibile in automatico