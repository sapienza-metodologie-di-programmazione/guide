#import "logic.typ": *

#let darkred = rgb(192, 0, 0)
#let background = rgb(251, 251, 251)

#set text(10pt, font: "Cascadia Code")
#set underline(offset: 3pt)
#set page(margin: 1.5cm)
#set figure(supplement: [Figura])


// #show regex("[[:^alpha:]]\d+"): set text(rgb("#4caf50"))
// #show regex("[()\[\]:,\.\{\}|]"): set text(rgb("#4caf50"))
// #show regex("[a-zA-Zàèìù]+\("): set text(blue)
#show regex("this|result|auth|adesso|old|new"): set text(blue)
#show regex("True"): set text(rgb("#4caf50"))

// #show regex("JFrame|JButton|JPanel|JLabel"): set text(blue)
// #show link: it => underline[#text(navy)[#it#h(3pt)#text(size: 7pt)[(doc)]]]
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

// #set raw(theme: "halcyon.tmTheme")
#show raw.where(block: true): view

#align(center, text(17pt)[ *Un approccio pratico a #text(darkred)[Java Swing] e #text(darkred)[MVC]* ])

\

#outline(title: [Sommario], indent: 1.5em)

#pagebreak()

= #text(darkred)[Java Swing]

L'obiettivo di questa sezione è fornire, tramite esempi pratici, gli *strumenti fondamentali* per lo *sviluppo agevole* di interfacce grafiche con #text(darkred)[Java Swing].

// TODO: successivamente in MVC come progettare un'applicazione completa + come collaborare a automatizzare con git

// L'obiettivo di questa guida è fornire, tramite esempi pratici, gli *strumenti fondamentali* per lo *sviluppo agevole* di interfacce grafiche con #text(darkred)[Java Swing]

// Questa è una guida molto *breve* e *semplificata*.
// sulle funzionalità principali serve solo come introduzione per semplificare il lavoro per eventuali progetti.

// Il *wireframe* serve perché è difficile progettare un'interfaccia *intuitiva* e *funzionale*. Una volta progettata l'interfaccia *scrivere il codice è semplice*, perché abbiamo un'idea chiara di quello che vogliamo, e dobbiamo solo implementarlo.

// Il *wireframe* permette di disegnare rapidamente un'interfaccia *intuitiva* e *funzionale*, riducendo il tempo passato a scrivere codice.
// , perché abbiamo un'idea chiara e dobbiamo solo implementarla.

== Wireframe

Per sviluppare l'interfaccia grafica di un sito web, un'applicazione, un gioco etc... è utile disegnare un *wireframe*. 

Un *wireframe* è un diagramma fatto di *rettangoli*, *testo*, *icone* e *frecce* (come in @wireframe-1) che permette di progettare *rapidamente* un'interfaccia *intuitiva* e *funzionale*, riducendo il tempo passato a scrivere codice.
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

=== Creare una finestra (#link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/JFrame.html")[JFrame])

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

#text(darkred)[Java Swing] ha alcuni *default particolari*:
- ```java new JFrame(...)``` istanzia una finestra *invisibile*, per questo si usa ```java setVisible(true)```
- la finestra, alla chiusura, viene *solo nascosta*, per questo si usa ```java setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)```
- ```java setLocationRelativeTo(null)``` posiziona la finestra al centro dello schermo

Oltre a ```java setSize(int width, int height)```, una finestra si può dimensionare anche con il metodo ```java pack()``` che imposta le *dimensioni minime* per disegnare il contenuto della finestra. 

#note[```java pack()``` imposta le *dimensioni a 0* se la finestra non ha contenuto, per cui ricordatevi di invocare ```java pack()``` *dopo* aver aggiunto componenti al ```java JFrame```.]

#note[Ricordatevi di *cambiare l'icona* di default :)]

// Alcuni componenti di  hanno *comportamenti di default* particolari:
// - alla chiusura della finestra il ```java JFrame``` viene *solo nascosto*, per questo si usa ```java setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)```
// -  ```java setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)``` serve a terminare il programma alla chiusura

// ```java setSize(int width, int height)``` imposta la dimensione della finestra

// #note[ ]

// Se usando ```java pack()``` *larghezza e altezza sono impostati a 0* è perché state usando ```java pack()``` _prima_ di aggiungere il contenuto alla finestra. 

// Se la finestra *non rispetta la dimensione impostata* con ```java setSize(int width, int height)``` probabilmente state usando anche ```java pack()``` nel codice (non vanno usati entrambi).


// Oltre a ```java setSize(int w, int h)``` c'è un altro modo per ridimensionare la finestra:
  // - ```java frame.pack()``` imposta larghezza e altezza al valore _minimo_ che rispetta il contenuto della finestra
  // _Se la finestra non ha contenuto_, la larghezza e l'altezza vengono impostati a 0  
// #note[// ]

//  termina il programma quando la finestra viene chiusa (di default la finestra viene *solo nascosta*)

// - ```java setIconImage(Image image)``` imposta l'icona in alto a sinistra della finestra

  // Non lasciate l'icona di default! 
	// Fate vedere un po' di attenzione ai dettagli :)



// - ```java setVisible(true)``` rende la finestra *visibile*

// ==== Errori comuni 



#pagebreak()

=== Aggiungere ```java Component``` a una finestra (#link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/JPanel.html")[JPanel])

```java
JPanel panel = new JPanel();
JLabel label = new JLabel("Questa \u00E8 una finestra!");

panel.add(label);
frame.add(panel);
```

Sia ```java JFrame``` sia ```java JPanel``` sono ```java java.awt.Container```, quindi dispongono del metodo ```java add(Component comp)```.  #text(darkred)[Java Swing] mette a disposizione vari ```java Component```
- ```java JLabel``` per testo e immagini
- ```java JButton``` per pulsanti
- ```java JPanel``` per interfacce più complesse 
- ```java JTable```, ```java JSlider``` etc...

// per aggiungere compoenti (testo, immagini, pulsanti etc...)

//  possiamo aggiungere contenuto (testo, immagini, pulsanti etc...) al loro interno tramite .

#note[
	```java java.awt.Container``` è un esempio di #link("https://refactoring.guru/design-patterns/composite")[Composite Pattern]
]

// - ```java JPanel``` occupa l'intero spazio a disposizione 
// - ```java JLabel``` serve a visualizzare testo (```java "Questa è una finstra"``` @wireframe-1)

// ==== Colori, font e personalizzare lo sfondo con ```java paintComponent(Graphics g)```
=== Colori, font e sfondo (```java paintComponent(Graphics g)```)

Ora l'obiettivo è quello di colorare lo sfondo e il testo come in @wireframe-1

// #note[
//   Normalmente un *wireframe* _non prevede_ colori o scelte stilistiche, ma nel caso di un progetto piccolo possiamo permetterci di usarlo come se fosse un design 
// ]

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

Il ```java JFrame``` invoca il metodo ```java paint(Graphics g)``` del ```jframe JPanel```. A sua volta ```java paint(Graphics g)``` invoca in ordine:
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

=== Centrare un componente (#link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/GridBagLayout.html")[GridBagLayout])


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

== Modificare font e colori globalmente (#link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/UIManager.html")[UIManager])

L'aspetto dei componenti e il loro comportamento in #text(darkred)[Java Swing] viene gestito con #link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/LookAndFeel.html")[```java javax.swing.LookAndFeel```]. È possibile modificare *globalmente* l'aspetto del ```java LookAndFeel``` tramite ```java javax.swing.UIManager``` (sostanzialmente un'```java HashMap```). 

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

=== Chiavi di ```java UIManager```

#note[
  Un elenco delle #link("https://github.com/CuriousCI/minesweeper/blob/main/keys.txt")[possibili chiavi]
]

Per stampare l'elenco di chiavi disponibili:

```java
javax.swing.UIManager.getDefaults().keys().asIterator().forEachRemaining(System.out::println);
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
\

Abbiamo un rettangolo con le statistiche in alto, e il restante spazio è occupato da un rettangolo centrale con un pulsante. 

#pagebreak()

==== Barra delle statistiche e menu di gioco

```java
public class App extends JFrame {
	static { UIManager.put("Panel.background", Color.WHITE); }

	App() {
		super("JGioco");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		try { setIconImage(ImageIO.read(new File("icon.png"))); } catch (IOException e) { }

		add(new JPanel(new BorderLayout(10, 10)) { // Sfondo
			{
				setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20)); // Spazio dal bordo della finesta

				add(new JPanel() { // Barra in altro
					{
						setBackground(new Color(255, 255, 255, 0)); // Trasparente
						setBorder(BorderFactory.createCompoundBorder(
              BorderFactory.createLineBorder(Color.decode("#2f9e44")),
              BorderFactory.createEmptyBorder(10, 10, 10, 10)));
					}
				}, BorderLayout.NORTH); // Posizionata a NORD

				add(new JPanel() { // Blocco centrale
					{
						setBackground(new Color(255, 255, 255, 0)); // Trasparente
						setBorder(BorderFactory.createCompoundBorder(
              BorderFactory.createLineBorder(Color.decode("#2f9e44")),
              BorderFactory.createEmptyBorder(10, 10, 10, 10)));
					}
				}, BorderLayout.CENTER); // Posizionato al CENTRO
			}

			@Override
			protected void paintComponent(Graphics g) { // Sfondo linee oblique verdi
				super.paintComponent(g);
				int density = 5;
				g.setColor(Color.decode("#b2f2bb"));
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

- ```java BorderLayout(int vgap, int hgap)``` imposta uno "spazio" verticale e orizzontale fra due componenti.

- con ```java setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20))``` impostiamo un bordo trasparente (per lasciare uno spazio dal bordo della finestra)

Quando aggiungo un elemento ad un container, posso specificare come deve essere trattato tramite il metodo ```java add(Component comp, Object constraints)```: in base al layout del container, ```java Object constraints``` avrà un significato diverso.

#note([```java BorderFactory``` è un esempio di #link("https://refactoring.guru/design-patterns/factory-method")[Factory Pattern]])

Risultato

\
#align(image("assets/borderlayout-1.png"), center)
\

==== Implementazione

#note[di default, lo sfondo di un ```java JLabel``` è trasparente, per renderlo visibile bisogna usare ```java setOpaque(true)```]

```java
public class App extends JFrame {

	static {
		UIManager.put("Label.font", new Font("Cascadia Code", Font.PLAIN, 17));
		UIManager.put("Label.foreground", Color.decode("#2f9e44"));
		UIManager.put("Label.background", Color.WHITE);

		UIManager.put("Button.font", new Font("Cascadia Code", Font.PLAIN, 17));
		UIManager.put("Button.foreground", Color.decode("#2f9e44"));
		UIManager.put("Button.background", Color.WHITE);
		UIManager.put("Button.border", BorderFactory.createCompoundBorder(
      BorderFactory.createLineBorder(Color.decode("#2f9e44")),
      BorderFactory.createEmptyBorder(5, 10, 5, 10)));
		UIManager.put("Button.highlight", Color.decode("#b2f2bb"));
		UIManager.put("Button.select", Color.decode("#b2f2bb"));
		UIManager.put("Button.focus", Color.WHITE);

		UIManager.put("Panel.background", Color.WHITE);
	}


```

#pagebreak()

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

\
#align(image("assets/borderlayout-2.png"), center);
\

#pagebreak()

==== Funzionamento del ```java BorderLayout```

Il ```java BorderLayout``` permette di specificare come posizionare gli elementi:
- l'elemento ```java CENTER``` occuperà tutto lo spazio possibile 
- gli elementi ```java NORTH``` e ```java SOUTH```  avranno larghezza massima (indipendentemente dalla larghezza impostata) e avranno altezza minima, o, se impostata, l'altezza impostata
- gli elementi ```java WEST``` e ```java EAST```  avranno altezza massima (indipendentemente dall'altezza impostata) e avranno larghezza minima, o, se impostata, la larghezza impostata

Il costruttore ```java BorderLayout(int vgap, int hgap)``` imposta uno "spazio" verticale e orizzontale fra due componenti.

#align(image("assets/borderlayout-3.png"), center)

```java
public class App extends JFrame {
	App() {
    //...

		add(new JPanel(new BorderLayout()) {
			{
				add(new DecoratedPanel("Nord"), BorderLayout.NORTH);
				add(new DecoratedPanel("Sud"), BorderLayout.SOUTH);
				add(new DecoratedPanel("West") {
					{
						setPreferredSize(new Dimension(120, 0)); // Larghezza custom
					}
				}, BorderLayout.WEST);
				add(new DecoratedPanel("East"), BorderLayout.EAST);
				add(new DecoratedPanel("Center"), BorderLayout.CENTER);
			}
		});
	}

	public static void main(String[] args) { new App(); }
}
```

#pagebreak()

=== #link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/CardLayout.html")[CardLayout]

==== Menu, impostazioni e partita _(cambiare schermata)_

Il ```java CardLayout``` è molto utile quando abbiamo più schermate (menu principale, impostazioni, partita etc...)

#figure(
  image("assets/wireframe-3.png"),
  caption: [caso d'uso di un ```java CardLayout``` e frecce nel *wireframe* per le transizioni],
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

// - usa il pattern *Observer* per notificare gli ```java Observer``` dei cambiamenti di schermata 

- ```java Navigator``` è la classe che permette di cambiare schermata 
  - usa il pattern *Singleton* perché deve avere una sola istanza globale
  - usa il pattern *Observer* per notificare i componenti quando cambia schermata 
  - per cambiare schermata, _da qualsiasi parte del codice_, basta usare ```java Navigator.getInstance().navigate(Screen.Schermata);```
- ```java App``` 
  - è un *Observer* perché deve essere notificato quando cambia la schermata 
  - usa ```java Navigator.getInstance().addObserver(this);``` per osservare l'unica istanza di ```java Navigator```
	- nel metodo ```java update(Observable o, Object arg)``` cambia la schermata usando ```java CardLayout::show```

#pagebreak()

=== #link("https://docs.oracle.com/en/java/javase/17/docs/api/java.desktop/java/awt/GridLayout.html")[GridLayout]

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

=== #link("https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/GridBagLayout.html")[GridBagLayout]


==== Il layout #text(darkred)[più flessibile]

Il ```java GridBagLayout``` permette di dividere il panel in una griglia (nell'esempio, le celle della griglia sono 3, e sono divise dalla linea gialla) in maniera molto flessibile:
- una cella può essere *posizionata* in qualunque ```java x``` e ```java y``` della griglia
- la *dimensione* di una cella può essere definita in diversi modi
  - numero di righe e numero di colonne
  - può essere specificato che deve occupare "tutto lo *spazio rimanente*"
    - in largheza
    - in altezza 
    - in entrambe le dimensioni

La particolarità (rispetto agli altri layout) è che gli elementi *non vengono ridimensionati* per occupare tutto lo spazio di una cella, ma vengono posizionati all'interno della cella rispettando le loro dimensioni (nella cella a sinistra, si può vedere che il label ```java "testo"``` è posizionato a ```java NORTH_EAST```)

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
						setBorder(BorderFactory.createCompoundBorder(BorderFactory.createLineBorder(Color.DARK_GRAY),
								BorderFactory.createEmptyBorder(30, 30, 30, 30)));

						GridBagConstraints constraints = new GridBagConstraints();

						constraints.weightx = 1;
						constraints.weighty = 1;

						constraints.anchor = GridBagConstraints.NORTHEAST;
						constraints.gridx = 0;
						constraints.gridy = 0;
						constraints.gridwidth = 1;
						constraints.gridheight = 3;

						add(new JLabel("testo"), constraints);

						constraints.anchor = GridBagConstraints.CENTER;
						constraints.gridx = 1;
						constraints.gridy = 0;
						constraints.gridwidth = GridBagConstraints.REMAINDER;
						constraints.gridheight = 2;

						add(new JLabel("x: 1,\n y: 0, w: spaz. rim., h: 2 righe"), constraints);

						constraints.gridx = 1;
						constraints.gridy = 2;
						constraints.gridwidth = GridBagConstraints.REMAINDER;
						constraints.gridheight = 1;

						add(new JLabel("x: 1, y: 0, w: spaz. rim., h: 1 riga"), constraints);
					}

					@Override
					protected void paintComponent(Graphics g) {
						setPreferredSize(new Dimension(frame.getWidth() - 80, frame.getHeight() - 80));
						super.paintComponent(g);
					}
				});
			}

			@Override
			protected void paintComponent(Graphics g) {
				super.paintComponent(g);
				int density = 5;
				g.setColor(Color.decode("#e9ecef"));
				for (int x = 0; x <= getWidth() + getHeight(); x += density)
					g.drawLine(x, 0, 0, x);
			}
		});

		setLocationRelativeTo(null);
		setVisible(true);
	}

	public static void main(String[] args) { new App(); }
}
```

\
#align(image("assets/gridbaglayout-1.png"), center)
\

```java GridBagConstraints``` ha anche *altri attributi* estremamente utili come ```java ipdax```, ```java ipady``` e ```java insets``` che sono discussi nella #link("https://docs.oracle.com/javase%2Ftutorial%2Fuiswing%2F%2F/layout/gridbag.html#gridbagConstraints")[guida ufficiale]

#pagebreak()

=== In conclusione (sui Layout)

Dato un *wireframe* ora dovreste avere gli strumenti per implementare il layout 

#figure(
	image("assets/wireframe-5.png"),
	caption: [esempio di wireframe per il gioco "Minesweeper"],
) <wireframe-5>
\

I layout visti in questa guida #link("https://docs.oracle.com/javase%2Ftutorial%2Fuiswing%2F%2F/layout/visual.html")[non sono gli unici] (e non sono state coperte tutte le loro funzionalità), ma, capiti i concetti chiave, si può passare alla #link("https://docs.oracle.com/en/java/javase/21/docs/api/index.html")[documentazione].

#pagebreak()

== Pulsanti

== Immagini

== Animazioni

== Graphics

== Timer

#pagebreak()

= #text(darkred)[MVC]

#align(
	center, 
	image("assets/mvc.png", width: 100%)
)

*MVC* è un *pattern architetturale* per sviluppare diversi tipi di applicazioni: servizi web, programmi GUI, programmi per terminale etc...

L'idea è quella di *separare la logica del programma dall'interfaccia*. In questo modo:
- la logica e i dati sono *definiti in modo chiaro e pulito*
- la logica è *riusabile* (più interfacce diverse possono condividere la logica)

Ad esempio, posso definire la logica del gioco *Solitario* una volta sola, e usarla per costruire un sito web, un'applicazione per Windows, un'API REST, una TUI (terminal user interface) etc... Il *Model* è condiviso da più *View*.

\
Fin'ora abbiamo discusso solo della *View*, ora l'obiettivo è quello di *progettare una semplice applicazione* e mostrare un possibile modo di strutturare il codice. 

#pagebreak()

== Minesweeper _(prato fiorito)_

Trovate il codice completo del progetto #link("https://github.com/CuriousCI/minesweeper")[su GitHub]

=== UML e modello

Iniziamo definendo il modello

#align(
	center, 
	image("assets/uml.png", width: 100%)
)

#note[
	#text(darkred)[*Attenzione!*] Questo *NON è il tipo di UML che avete visto a lezione*.
	
	È definito tramite la #link("https://en.wikipedia.org/wiki/First-order_logic")[logica di primo ordine] ed è *agnostico*. Si vede in corsi come *Basi di dati 2* e *Ingegneria del software*. Lo uso per bervità e semplicità.
]

==== In breve

- vogliamo gestire le partite (Game)
	- ogni partita ha 100 caselle (Tile) 
		- sono disposte in una griglia 10x10
		- c'è un numero variabile di mine da 0 a 100
	- una partita può essere finita (Ended) 
		- caso in cui va segnata la durata
		- può avere uno di tre esiti
			- sconfitta (Loss)
			- vittoria (Victory)
			- terminata dall'utente (Terminated)
	- di ogni partita si devono poter calcolare
		- il numero di mine
		- il numero di bandiere

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
	
#pagebreak()

=== Vincoli del modello

Il modello che abbiamo definito è *incompleto*: permette *alcuni stati che non vogliamo*
- una partita potrebbe essere una vittoria anche con una mina scoperta 
- una partita potrebbe essere una vittoria con tutte le caselle nascoste 

Servono dei vincoli (qui scritti in _logica di primo ordine_) per *limitare* i possibili stati del modello. 

#note[
Di seguito sono riportati alcuni vincoli, #link("https://github.com/CuriousCI/minesweeper/blob/main/docs/main.pdf")[qui trovate il documento completo]
]

\

Una partita è una vittoria in uno di due casi 
	- tutte le mine hanno una bandiera e tutte le caselle vuote sono senza bandiera
	- tutte le caselle vuote sono scoperte

#constraint(
  [*Game*._victory_condition_],
  [
    $forall$ game\
    #t Victory(game) <=> \
    #t#t $forall$ tile _mine_game_(tile, game) #[==>] Flagged(tile) $and$ \
    #t#t $not$ $exists$ tile _tile_game_(tile, game) $and$ Empty(tile) $and$ Flagged(tile) \
    #t#t $or$ \
    #t#t $forall$ tile (_tile_game_(tile, game) $and$ Empty(tile) #[==>] Revealed(tile)) \
  ]
) 

\

Una partita è una sconfitta se e solo se c'è una mina scoperta

#constraint(
  [*Game*._loss_condition_],
  [
    $forall$ game \
    #t Loss(game) <=> \
		#t#t $exists$ mine _mine_game_(mine, game) $and$ Revealed(mine)
  ]
)

\

#note[ Vedremo che in Java questi vincoli sono comodi da scrivere con gli ```java Stream``` ]

#pagebreak()

=== Operazioni sul modello

//  Sono le funzionalità che dobbiamo garantire nella progettazione del *wireframe* e che verranno tradotte in parte in operazioni del *Controller*.
Bisogna definire un insieme di *operazioni* che un *utente* deve poter effettuare sul modello. Queste operazioni verranno tradotte in metodi del controller.

\
#operation([start_game], type: [*Game*])
#operation([terminate_game], args: [game: *Game*], type: [*Terminated*]) 
#operation([reveal], args: [tile: *Hidden*], type: [*Revealed*])
#operation([flag], args: [tile: *Hidden*], type: [*Flagged*])
#operation([remove_flag], args: [tile: *Flagged*], type: [*Hidden*])
#operation([games_played], type: [*Integer* >= 0])
#operation([games_won], type: [*Integer* >= 0])
#operation([time], type: [*Duration*])
#operation([mines], type: [(0..100)])
#operation([flags], type: [(0..100)])

\

=== Wireframe

Ora dobbiamo solo progettare l'interfaccia dell'applicazione con un *wireframe* (garantendo le operazioni definite prima)

#align(center, image("assets/wireframe.png"))

#pagebreak()

== Codice

Nel #link("https://github.com/CuriousCI/minesweeper/tree/main/src/main/java/minesweeper")[codice] del progetto ho deciso di creare un *package* principale chiamato *minesweeper* e di suddividerlo a sua volta in 3 *package* per *model*, *view* e *controller*. Il progetto è piccolo, quindi bastano questi tre. I *package* sono lo strumento più importante per l'*encapsulation*.

=== Model

Il ```java model``` ha solo due classi: ```java model.Tile``` e ```java model.Game```. Di seguito ```java model.Tile``` con alcune particolarità degne di nota.

```java
package minesweeper.model;

import static minesweeper.model.Tile.Visibility.*;

import java.util.Observable;
import java.util.Optional;

@SuppressWarnings("deprecation")
public class Tile extends Observable {

	public enum Kind { Mine, Empty }

	public enum Visibility { Hidden, Flagged, Revealed }

	public final int x, y;
	public final Kind kind;
	private Visibility visibility = Visibility.Hidden;
	Optional<Integer> adjacentMines = Optional.empty();

	Tile(int x, int y, Kind kind) {
		this.x = x;
		this.y = y;
		this.kind = kind;
	}

	public Visibility visibility() { return visibility; }

	public Optional<Integer> adjacentMines() { return adjacentMines; }

	public void flag() {
		visibility = switch (visibility) {
			case Hidden -> { setChanged(); yield Flagged; }
			case Flagged -> { setChanged(); yield Hidden; }
			case Revealed -> Revealed;
		};

		notifyObservers(visibility);
	}

	public void reveal() {
		if (visibility != Hidden)
			return;

		visibility = Revealed;
		setChanged();
		notifyObservers(Revealed);
	}

}
```

#pagebreak()

==== Encapsulation con ```java public final```

// La strategia di ridurre la visibilità di un attributo a ```java private``` e di definire *getter* e *setter* non è l'unico modo di fare encapsulation.

// rendere il costruttore visibile solo all'interno del package* (visibilità di default)

// In questo modo, le *Tile* possono essere istanziate con valori per ```java x```, ```java y``` e ```java kind``` all'interno del package (con valori ragionevoli), e questi valori possono essere letti (ma non modificati) all'esterno. 

Una modo alternativo per ottenere *encapsulation* è quello di segnare un *attributo* come ```java public final```, e di lasciare al *costruttore* la *visibilità di default*. In questo modo:
- ```java model.Tile``` può essere istanziata solo con valori validi all'interno del package 
- questi valori possono essere letti ma non modificati

==== Tipizzazione con ```java enum```

// Ho deciso di codificare i tipi di caselle e i possibili stati con degli ```java enum```: usare l'ereditarietà in questo caso sarebbe stato inutilmente complesso e verboso. 

// Gli ```java enum``` sono interni alla classe per poter usare la notazione ```java Tile.Kind``` e ```java Tile.Visibility``` che trovo più leggibile (e rende il codice più semplice da navigare non dovendo creare altri due file).


Le tipologie di ```java Tile``` (```java Mine```, ```java Empty```) e le visibilità (```java Hidden```, ```java Flagged``` e ```java Revealed```)  sono definite con ```java enum```: usare l'*ereditarietà* in questo caso sarebbe stato inutilmente *verboso*. 

I tipi ```java enum Kind``` e ```java enum Visibility``` sono definiti *internamente* alla ```java class Tile``` per poter usare la notazione ```java Tile.Kind``` e ```java Tile.Visibility``` che trovo più leggibile. Inoltre non serve creare altri due file per questi ```java enum```, facilitando la navigazione del codice.
// (e rende il codice più semplice da navigare non dovendo creare altri due file).

// ==== Tipi ```java null``` con ```java Optional<T>```
==== Il potere di ```java Optional<T>```

In alcuni casi *ha senso* ed *è utile* avere attributi che possono essere ```java null```. Il problema di usare ```java null``` è che chi usa la libreria *deve sapere* in qualche modo (tramite la documentazione) che quell'attributo potrebbe essere ```java null```. 

Per risolvere il problema, basta rendere l'attributo ```java Optional<T>```, in questo modo stiamo *esplicitamente dichiarando nel codice* che quell'attributo potrebbe non avere un valore impostato (```java Optional.empty()```), e chi usa l'attributo deve gestire il caso in cui il valore non c'è.

// Ad esempio, nell'UML che abbiamo progettato, solo le caselle ```java Empty``` hanno l'attributo ```java adjacentMines```. 

// Per poterlo fare in Java possiamo aggiungere un attributo ```java Integer adjacentMines``` a tutte le caselle, e impostarlo a ```java null``` per le caselle *non Empty*.



==== ```java switch``` con steroidi (```java switch``` expression)

In Java 14 sono state uficializzate le ```java switch``` expression che possono restituire un valore e non necessitano l'utilizzo di ```java break;``` (vedere il metodo ```java flag()```). 

// Hanno anche altre funzionalità (permettono di determinare il tipo di un oggetto e castarlo senza usare ```java instanceof```, vedere ```java update(Observable o, Object arg)``` in ```java model.Game```)

==== Observer Pattern

Per la casella ho deciso di usare l'*Observer* per due motivi:
- notificare la *View* (per ridisegnare la casella)
- notificare le altre classi del model (la classe *Game* deve sapere quando una *Tile* cambia stato, per decidere se terminare la partita o scoprire le caselle adiacenti)

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
		Random random = new Random();

		for (int y = 0; y < 10; y++)
			for (int x = 0; x < 10; x++)
				tiles[y * 10 + x] = new Tile(x, y, random.nextInt(100) >= 15 ? Empty : Mine);

		for (Tile tile : tiles) {
			tile.addObserver(this);

			int adjacentMines = (int) adjacent(tile.x, tile.y)
					.filter(t -> t.kind == Mine)
					.count();

			if (tile.kind == Empty && adjacentMines > 0)
				tile.adjacentMines = Optional.of(adjacentMines);
		}

		mines = (int) Stream.of(tiles)
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

Un errore che ho visto è quello di creare un attributo per ogni variabile. Ad esempio: alcuni hanno creato un attributo ```java Random random``` per la classe ```java Game```, nonostante questo venga usato solo nel costruttore. *NON* c'è bisogno di *creare un attributo per ogni variabile*.

==== Gestire il timer

Il *Model* non dovrebbe gestire l'eventuale *timer*, quello è un compito del *Controller*. Mettendo il *timer* fuori dal *Model* diventa più facile mettere in *pausa* il gioco.

Il *Model* dovrebbe semplicemente avere un metodo ```java update()``` (nel mio caso ```java updateTime()```) che deve essere invocato dal *Controller* quando scatta il *timer*.

==== Alcuni esempi di ```java Stream```

Nella classe ```java model.Game``` ci sono alcuni esempi di ```java Stream``` oltre a quelli sopra.


#pagebreak()

==== Il metodo ```java update(Observable o, Object arg)```

```java
@Override
public void update(Observable o, Object arg) {
	switch (o) {
		case Tile tile -> {
			switch (arg) {
				case Tile.Visibility visibility -> {
					switch (visibility) {
						case Flagged -> flags++;
						case Hidden -> flags--;
						case Revealed -> {
							if (tile.kind == Mine) {
								setChanged();
								notifyObservers(Result.Loss);
								deleteObservers();
								return;
							}

							if (tile.adjacentMines().isEmpty())
								adjacent(tile.x, tile.y).forEach(Tile::reveal);

							boolean allEmptyRevealed = Stream.of(tiles)
									.allMatch(t -> t.visibility() == Revealed || t.kind == Mine);

							boolean allMinesFlagged = Stream.of(tiles)
									.allMatch(t -> (t.kind == Mine && t.visibility() == Flagged)
											|| (t.kind == Empty && t.visibility() != Flagged));

							if (allEmptyRevealed || allMinesFlagged) {
								setChanged();
								notifyObservers(Result.Victory);
								deleteObservers();
							}
						}
					}
				}
				default -> {
				}
			}
		}
		default -> {
		}
	}
}
```

// Il metodo ```java update(Observable o, Object arg)``` in ```java model.Game``` viene invocato quando cambia lo stato di una delle caselle della partita.

Per assicurarci che ```java Observable o``` sia effettivamente un'istanza di ```java Tile``` e per castare l'istanza a ```java Tile``` usiamo la sintassi ```java case Tile tile -> { }``` di Java 21.

A questo punto, sappiano che il metodo è stato invocato da una ```java Tile```, e possiamo usare uno ```java switch``` per determinare il valore effettivo di ```java Object arg```. Preferisco questa strategia perché in questo modo posso distinguere diversi tipi di messaggi, e comportarmi adeguatamente in base al tipo di messaggio, ad esempio:

```java mode.Game``` può inviare due tipi di messaggi:
- ```java model.Game.Result``` (con le varianti ```java Loss, Victory, Terminated```), caso in cui devo cambiare schermata nella view
- ```java model.Game.Messagge``` (con la variante ```java Timer```) caso in cui devo solo aggiornare il ```java JLabel``` con il tempo nella view

Questo approccio in cui "event driven" ha una serie di vantaggi:
- se aggiungo un ```java Observer``` alle ```java Tile``` non rompo il comportamento attuale
- se aggiungo una PowerUp che agisce sulle ```java Tile``` preservo il comportamento attuale 

#pagebreak()

=== Controller

=== View



#pagebreak()

= #text(darkred)[git]

== Lavorare in gruppo

=== Merge conflict

== GitHub Actions

=== Generare la documentazione in automatico

=== Generare l'eseguibile in automatico