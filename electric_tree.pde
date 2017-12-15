public static int [] consumiValori = {
    918,
    975,
    993,
    1054,
    1065,
    1154,
    1204,
    1247,
    1270,
    1316,
};

public static String [] consumiNomi = {
    "Campobasso",
    "Benevento",
    "Cosenza",
    "Frosinone",
    "Crotone",
    "Lodi",
    "Cremona",
    "Siena",
    "Pavia",
    "Mantova"
};
    
    
int system_time = 0;

public ArrayList<Lampadina> lampadine = new ArrayList<Lampadina>();
public ArrayList<Nodo> nodi = new ArrayList<Nodo>();
    
public static final int GAME_WIDTH = 700;

public static boolean lightning = false;

//roba sull'albero
public static int ALBERO_Y = 600;
public static int ALBERO_X = 0;
public static int STROKE = 20;
public static double time;
public static float crescita = 0;
public static float maxLevel = 1;

public static double MOUSE_AFFECTION_X = 4;
public static double MOUSE_AFFECTION_Y = 15;
public static double MOUSE_MAX_DISTANCE = 1;

public static double TEMPO_DI_CRESCITA = .2;
public static double START_TIME_CRESCITA = 0;

public static int LIGHT_RADIUS = 70;

public static int GROWTH_RATE = 40;


public Nodo nodoinit = new Nodo(GAME_WIDTH/2, 600);

public static int [][] numRamiChePartonoDaQui = new int[12][1000];
public static int [] numRamiIndex = new int[12];
public static double [][] valoriRandom = new double[12][100];
public static int[] valoriRandomIndex = new int[12];

public static int[] blackPixels = new int[GAME_WIDTH*GAME_WIDTH];

public static int[] contaRami = new int[12];
public static int[] numRamiPerLivello = new int[12];

public static PImage shadowmap, sfondo;


public ParticleSystem ps;
    
    
    void setup() {
        size(700, 700);
        background(100);
        frameRate(200);
        noSmooth();
        
        START_TIME_CRESCITA = System.currentTimeMillis();
        
        randomizzaNumeroRamiDaQui();
        randomizzaNumeriDaQui();
        
        for (int i = 0; i < 12; i++) {
            valoriRandomIndex[i] = 0;
            numRamiIndex[i] = 0;
            numRamiPerLivello[i] = 0;
            contaRami[i] = 0;
        }
        
        
        contaRami(1);
        trovaLivello(10);
        
//        System.out.println(k);
//        aggiustaNumeroRami(k, 10);
        for (int i = 0; i < 12; i++) {
            valoriRandomIndex[i] = 0;
            numRamiIndex[i] = 0;
            contaRami[i] = 0;
        }
        //loadImages();
        ps = new ParticleSystem(new PVector(width/2,650));

        sfondo = loadImage("sfondoalbero.jpg");
        
        createBackground();
        
        shadowmap = new PImage(GAME_WIDTH, GAME_WIDTH);
    }
    
    public void draw() {
        text("consumo: ", 0, 0);
        background(sfondo);
        time = millis()/1000;
        
        if (lightning) {
            shadowMap();
        }
        
        
        stroke(255, 1);
        ps.addParticle();
        ps.run();
        
        noFill();
        stroke(255);
        strokeWeight(1);
        bezier(380 + mouseX/30, 540 +mouseY/30,  390 +mouseX/20, 540+mouseY/20,  420, 580,  300, 650);
        noStroke();
        
        fill(255);
        ellipse(380+mouseX/30, 540+mouseY/30, 10, 10);
        ellipse(375+mouseX/30, 550+mouseY/30, 7, 7);
        ellipse(383+mouseX/30, 549+mouseY/30, 4, 4);
        rect(0, 600, 700, 200);
        //filter(BLUR, 1);
        //ellipse(350,350,400,400);  
        
        cresci();
        smooth();
        
        for (int i = 0; i < 12; i++) {
            valoriRandomIndex[i] = 0;
            numRamiIndex[i] = 0;
            contaRami[i] = 0;
        }
        
        
        Scritte.clear();
        
        jumping = 0; jumping7 = 0; jumping8 = 0; jumping9 = 0;
        centri.clear();
        centri.add(new Centro(350, 570, 100));
        drawTree(350, 600, 120, radians(90), 10, 1);
        if (lightning) {
            image(shadowmap, 0, 0);
        }
        
        for (int i = 0; i < Scritte.size(); i++) {
            Scritte.get(i).draw(this);
        }
    }        
        
    public void drawTree (double x0, double y0, double len, double angle, int big, int currentLevel) {
        if(currentLevel <= maxLevel) {
            
               if (currentLevel == maxLevel) {
                   len *= crescita;
               }
               double x1 = x0 + len * Math.cos(angle);
               double y1 = y0 - len * Math.sin(angle);
               
               if (currentLevel == 10){
                   if (numRamiIndex[currentLevel]==1){
                       textSize(10);
                       Scritte.add(new Testo("• Mario Rossi", (int) x0, (int) y0));
                       Scritte.add(new Testo("consumo: " + numRamiIndex[currentLevel], (int) x0, (int) y0 + 12));
                   }
               }
                    
               x1 = muoviConMouseX(x1, (mouseX - x1));
               y1 = muoviConMouseY(y1, (mouseY - y1));
               
               
               aggiungiCentro(x1, y1, currentLevel);
               
               stroke(255, 255/((float)currentLevel / 2) + 30);
               
               if (big <= 0) big = 1;
               strokeWeight(big);
               
               numRamiIndex[currentLevel]++;
               if (numRamiIndex[currentLevel] >= 99) {
                   numRamiIndex[currentLevel] = 0;
               }
  
               line((int)x0, (int)y0, (int)x1, (int)y1);
                /*if (Math.sqrt(Math.pow((mouseY-y0),2)+Math.pow((mouseX-x0),2))>100) {
                    filter(BLUR);
                }*/
            
               
               for (int i = 0; i < numRamiChePartonoDaQui[currentLevel][numRamiIndex[currentLevel]]; i++) {
//                   System.out.println(numRamiChePartonoDaQui[currentLevel][numRamiIndex[currentLevel]]);
                   valoriRandomIndex[currentLevel]++;
                   if (valoriRandomIndex[currentLevel] == 99) {valoriRandomIndex[currentLevel] = 0;}
                   drawTree(x1, y1, len * 0.75, angle + radians(90) * valoriRandom[currentLevel][valoriRandomIndex[currentLevel]], big-2, currentLevel + 1);
               }
               
        }
    }
    
    public static int jumping = 0, jumping7 = 0, jumping8 = 0, jumping9 = 0;
    public static int radius = 0;
    
    public void aggiungiCentro (double x1, double y1, int currentLevel) {
        
        switch (currentLevel) {
            case 1: radius = 100;
                centri.add(new Centro((int)x1, (int)y1, radius));
                break;
            case 2: radius = 90;
                centri.add(new Centro((int)x1, (int)y1, radius));
                break;
            case 3: radius = 75;
                centri.add(new Centro((int)x1, (int)y1, radius));
                break;
            case 4: radius = 60;
                centri.add(new Centro((int)x1, (int)y1, radius));
                break;
            case 5: radius = 50;
                centri.add(new Centro((int)x1, (int)y1, radius));
                break;
            case 6: radius = 35;
                centri.add(new Centro((int)x1, (int)y1, radius));
                break;
            case 7: radius = 25;
                if (jumping7 >= 4) {
                    centri.add(new Centro((int)x1, (int)y1, radius)); jumping7 = 0;
                }
                else {
                    jumping7++;
                }
            
                break;
            case 8: radius = 12;
                if (jumping8 >= 6) {
                    centri.add(new Centro((int)x1, (int)y1, radius)); jumping8 = 0;
                }
                else {
                    jumping8++;
                }
                break;
            case 9: radius = 4;
                if (jumping9 >= 10) {
                    centri.add(new Centro((int)x1, (int)y1, radius)); jumping9 = 0;
                }
                else {
                    jumping9++;
                }
                break;
            default: radius = 0;
                break;
        }
    }
    
    public static void cresci() {
        if (maxLevel < 11) {
            crescita = (float) ((System.currentTimeMillis() - START_TIME_CRESCITA) /1000 / TEMPO_DI_CRESCITA);
            if (crescita >= 1) {
                aumentaLivelloMax();
            }
        }
    }
    
    public static void aumentaLivelloMax() {
            maxLevel += 1;
            crescita = 0;
            START_TIME_CRESCITA = System.currentTimeMillis();
    }
    
    
    
    
    
    
    public static double muoviConMouseX(double x, double distanceX) {
        if (distanceX > 0) {
                   x = x + (Math.sqrt(distanceX)) / MOUSE_AFFECTION_X;
               }
               else {
                   x = x + (-Math.sqrt(Math.abs(distanceX))) / MOUSE_AFFECTION_X;
               }
        return x;
    }
    
    public static double muoviConMouseY(double y, double distanceY) {
        if (distanceY > 0) {
                   y = y + (Math.sqrt(distanceY)) / MOUSE_AFFECTION_Y;
               }
               else {
                   y = y + (-Math.sqrt(Math.abs(distanceY))) / MOUSE_AFFECTION_Y;
               }
        return y;
      }
    
    
    public void randomizzaNumeroRamiDaQui () {
        for (int i = 0; i < 10; i++) {
            for (int j = 0; j < Math.pow(2, i) + 1; j++) {
                numRamiChePartonoDaQui[i][j] = (int)(Math.random()*3) +1;
            }
        }
    } 
    
    public void randomizzaNumeriDaQui () {
        for (int i = 0; i < 12; i++) {
            for (int j = 0; j < 100; j++) {
                valoriRandom[i][j] = (Math.random() - .5);
                
                if (j != 0) {
                while (Math.abs(valoriRandom[i][j] - valoriRandom[i][j-1]) < 0.3) {
                    valoriRandom[i][j] = (Math.random() - .5);
                }
                }
            }
        }
    }
    
    public void trovaLivello(int numRami) {
        int rami = 0;
        int livelloDesiderato = 0;
        
        for (int i = 1; i < 10; i++) {
            if (numRamiPerLivello[i] >= numRami) {
                aggiustaNumeroRami(i, numRami);
                System.out.println(i);
                break;
            }
        }
    }
    
    public static void contaRami (int currentLevel) {
        
        if (currentLevel >= 10) {return;}
        
        numRamiPerLivello[currentLevel]++;
        
        
        numRamiIndex[currentLevel]++;
               if (numRamiIndex[currentLevel] >= 99) {
                   numRamiIndex[currentLevel] = 0;
               }
               
        if (currentLevel == 1) {
            System.out.println("Level 1 : " + numRamiChePartonoDaQui[currentLevel][numRamiIndex[currentLevel]]);
        }
        
        for (int i = 0; i < numRamiChePartonoDaQui[currentLevel][numRamiIndex[currentLevel]]; i++) {
                   contaRami(currentLevel + 1);
        }
        
        
    }
    
    public void aggiustaNumeroRami (int livello, int numRami) {
        int rami = 0;
        
        System.out.println("Il livello da operare e'" + (livello));
        
        //conta il numero dei rami
        rami = numRamiPerLivello[livello];
        System.out.print("Il numero di rami su quel livello e' " + rami);
        
        while (rami > numRami) {
        
        for (int i = 0; i < Math.pow(2, livello - 1); i++) {
            if (numRamiChePartonoDaQui[livello - 1][i] > 1 && rami > numRami) {
                numRamiChePartonoDaQui[livello - 1][i] -= 1;
                rami--;
            }
            
        }
        
        
        }
        
        System.out.println("ciao");
    }
    
    public static ArrayList<Testo> Scritte = new ArrayList<Testo>();
    public static ArrayList<Centro> centri = new ArrayList<Centro>();
    public static int px, py;
    public int background = color(0,0,0,200);
    public int pixelBeforeColor;
    public int temp1, temp2;
    public double distanceSquared, distance;
    public void shadowMap () {
        shadowmap.loadPixels();
                System.out.println(centri.size());
        
        shadowmap.pixels = blackPixels.clone();
                
                
        for (int k = 0; k < centri.size(); k++) {
            for (int i = centri.get(k).y - centri.get(k).radius; i < centri.get(k).y + centri.get(k).radius; i++) {
                for (int j = centri.get(k).x - centri.get(k).radius; j < centri.get(k).x + centri.get(k).radius; j++) {
                    distanceSquared = (((i - centri.get(k).y) * (i - centri.get(k).y)) + (j - centri.get(k).x) * (j - centri.get(k).x));
                    if (distanceSquared < centri.get(k).radius*centri.get(k).radius) {
                        distance = Math.sqrt(distanceSquared);
                        if ((int)((shadowmap.pixels[i * GAME_WIDTH + j] >> 24) & 0xFF) > (230*distance/centri.get(k).radius)) {
                            shadowmap.pixels[i * GAME_WIDTH + j] = 230*(int)distance/centri.get(k).radius << 24;
                        }
                    }
                }
            }
        }
        shadowmap.format = ARGB;
        shadowmap.updatePixels();
    }
    
    public void createBackground() {
        for (int i = 0; i < GAME_WIDTH; i++) {
            for (int j = 0; j < GAME_WIDTH; j++) {
                py = GAME_WIDTH * i; px = j;
                
                blackPixels[py + px] = color(0,0,0,230);
            }
        }
    }
    
   public void keyPressed() {
        if (key == ' ') {
            lightning = !lightning;
        } else {
        }
      }
    
    
    
    
    
    
    
    
    
   