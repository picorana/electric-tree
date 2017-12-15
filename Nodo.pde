class Nodo {
    
public Nodo(int x, int y){
    this.x = x;
    this.y = y;
}

public Nodo(int x, int y, int livello) {
    
}

int x, y;
int livello;

public ArrayList<Nodo> nodiFigli = new ArrayList<Nodo>();
    
    
    public void addFiglio() {
        //da mettere l'algoritmo della posizione del nuovo nodo
        Nodo figlio = new Nodo(0, 0, this.livello + 1);
        addFiglio(figlio);
    }

    public void addFiglio(Nodo figlio){
        nodiFigli.add(figlio);
        nodi.add(figlio);
    }
    
    public void draw(){
        if (nodiFigli.size()==0) return;
        for (int i=0; i<nodiFigli.size(); i++){
            stroke(255);
            line(this.x, this.y, nodiFigli.get(i).x, nodiFigli.get(i).y);
            nodiFigli.get(i).draw();
        }
    }
    
    
    
}