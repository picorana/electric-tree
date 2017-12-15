class Testo {
    
public int x, y;
public String string;


    public Testo(int x, int y, String string) {
        this.x = x;
        this.y = y;
        this.string = string;
    }
    
    public Testo(String string, int x, int y) {
        this.x = x;
        this.y = y;
        this.string = string;
    }
    
    public void draw(PApplet app) {
        app.text(string, x, y);
    }
    
    
    
    
}