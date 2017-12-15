class Roba {
    
//VARIABILI CHE SERVONO
public PApplet applet;

//cose che servono al motore
public int tick = 16;
public double t_tick = tick;
public boolean playing = true;
public int system_time = 0;

//Roba che serve sul serio
public ArrayList<Lampadina> lampadine = new ArrayList<Lampadina>();
public ArrayList<Nodo> nodi = new ArrayList<Nodo>();


    /** Motore logico principale del gioco. Per fermarlo basta mettere "playing" su false. */
    Runnable Engine = new Runnable() {
        public void run() {
            synchronized(this) {
               long t = System.currentTimeMillis(); //qui
               long t_sleep;
               while (playing) {
                   try {
                        //tempo del gioco
                        system_time += tick;
                        //motore

                        //loop
                        t += t_tick;
                        t_sleep = t-System.currentTimeMillis(); //qui
                        if (t_sleep > 0) wait(t_sleep);
                   }catch(InterruptedException e ){}
               }
            }
    }};




    
}