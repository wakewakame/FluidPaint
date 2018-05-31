class Slide {
  PImage[] slides;
  int num_pages = 13;
  int current_page = 0;
  boolean appear = false;
  
  Slide() {
    slides = new PImage[num_pages];
    for(int i = 0; i < num_pages; i++){
      slides[i] = loadImage("./data/slide/slide-" + String.valueOf(i) + ".png");
    }
  }
  
  void draw(){
    if (appear) {
      tint(255, 255, 255, 204);
      float window_aspect = (float)width / (float)height;
      float slide_aspect = (float)slides[current_page].width / (float)slides[current_page].height;
      if (window_aspect > slide_aspect) image(
        slides[current_page],
        (width - (int)((float)slides[current_page].width * (float)height / (float)slides[current_page].height)) / 2,
        0,
        (int)((float)slides[current_page].width * (float)height / (float)slides[current_page].height),
        height
      );
      else image(
        slides[current_page],
        0,
        (height - (int)((float)slides[current_page].height * (float)width / (float)slides[current_page].width)) / 2,
        width,
        (int)((float)slides[current_page].height * (float)width / (float)slides[current_page].width)
      );
      noTint();
    }
  }
  
  void keyPressed(){
    if (key == CODED){
      if (keyCode == LEFT && appear) current_page--;
      if (keyCode == RIGHT && appear) current_page++;
    }
    else{
      if (key == ' ') appear = !appear;
    }
    if (current_page < 0) current_page = num_pages - 1;
    if (current_page > num_pages - 1) current_page = 0;
  }
};