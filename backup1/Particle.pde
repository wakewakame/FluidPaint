class Particle {
  public PShape points;
  public int max_point;
  public PVector col;
  public float width;
  
  public Particle() {
    reset();
    max_point = (int)pow(2, 12);
    col = new PVector(0.0f, 128.0f, 198.0f);
    width = 16.0f;
  }
  
  public void draw(){
    shape(points);
  }
  
  public void add(PVector point){
    if (points.getVertexCount() >= max_point) return;
    points.beginShape(POINTS);
    points.noFill();
    points.stroke(col.x, col.y, col.z, 255.0f);
    points.strokeWeight(this.width);
    points.vertex(point.x, point.y, point.z);
    points.endShape();
  }
  
  public void reset(){
    points = createShape();
  }
};