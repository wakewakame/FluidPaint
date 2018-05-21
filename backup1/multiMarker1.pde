/*
markers job

  *hiro
    this marker is like a 3D canvas
    this marker's coordinates become global coordinates
    
  *kanji
    this marker is work like a pen
    you can draw to 3D canvas with this marker
  
*/

String[] marker_path = {"./data/patt.hiro", "./data/patt.kanji", "./data/patt.sample1", "./data/patt.sample2"};
ARManagement ar;
Particle p1;
Particle p2_1;
Particle p2_2;

void setup() {
  
  // resize window
  size(640, 480, P3D);
  
  // create instances
  ar = new ARManagement(this, width, height, marker_path);
  p1 = new Particle();
  p2_1 = new Particle();
  p2_2 = new Particle();
  p2_1.col = new PVector(240.0f, 0.0f, 78.0f);
  p2_2.col = new PVector(240.0f, 240.0f, 240.0f);
  p2_2.width = 8.0f;
}

void draw() {
  
  // update markers infomation
  ar.update();
  
  // draw camera image
  image(ar.cam, 0, 0, width, height);

  for(int i=0; i < ar.marker_info.length; i++) {
    
    // check timeout
    if (ar.marker_info[i].inactive_time > 0.5f) continue;
    
    ar.beginTransform(i);
    switch(i) {
      
      case 0: // draw points to 3D canvas
        p1.draw();
        p2_1.draw();
        p2_2.draw();
        break;
      
      case 1: // add points to 3D canvas
        if (ar.marker_info[0].inactive_time <= 0.5f) p1.add(ar.getRelativeCoordinates(1, 0));
        break;
        
      case 2: // add points to 3D canvas
        if (ar.marker_info[2].inactive_time <= 0.5f) {
          p2_1.add(ar.getRelativeCoordinates(2, 0));
          p2_2.add(ar.getRelativeCoordinates(2, 0));
        }
        break;
      
      case 3: // draw points to 3D canvas
        //p1.reset();
        //p2_1.reset();
        //p2_2.reset();
        break;


    }
    ar.endTransform();
  }
}