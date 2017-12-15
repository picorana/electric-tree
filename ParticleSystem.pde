class ParticleSystem {
    
  public double whenLastAddedParticle = 0;  
  
  ArrayList<Particles> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particles>();
  }

  void addParticle() {
      if (System.currentTimeMillis() - whenLastAddedParticle > 50) {
        particles.add(new Particles(origin));
        whenLastAddedParticle = System.currentTimeMillis();
      }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particles p = particles.get(i);
      p.run();
            if (p.isDead()) {
              particles.remove(i);
            }
    }
  }
}