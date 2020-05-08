/*
markers job

  *canvas
    this marker is like a 3D canvas
    this marker's coordinates become global coordinates
    
  *pen
    this marker is work like a pen
    you can draw to 3D canvas with this marker

  *fluid
    this marker generate fluid flow

  *reset
    when this marker appear ,canvas is reseted
  
*/

import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;

final static boolean inverted_camera = true;

int cam_w, cam_h;

PGraphics3D canvas;
PGraphics2D cam;
ARManagement ar;
Particle p1;
Particle p2_1;
Particle p2_2;

Native n;
NativeShader density;
NativeShader velocity;
NativeShader obstacles;
NativeShader refraction;
DwFluid2D fluid;

Slide slide;

void setup() {
  
  // resize window
  size(640, 480, P3D);
  
  // initialize variable
  cam_w = width; cam_h = height;
  
  // create ar instances
  canvas = (PGraphics3D) createGraphics(cam_w, cam_h, P3D);
  cam = (PGraphics2D) createGraphics(cam_w, cam_h, P2D);
  ar = new ARManagement(this, canvas, cam_w, cam_h);
  ar.addARMarker("./data/marker/canvas.png");
  ar.addARMarker("./data/marker/pen.png");
  ar.addARMarker("./data/marker/fluid.png");
  ar.addARMarker("./data/marker/eraser.png");
  p1 = new Particle();
  p2_1 = new Particle();
  p2_2 = new Particle();
  p1.col = new PVector(255.0f, 0.0f, 0.0f);
  p2_1.col = new PVector(0.0f, 255.0f, 0.0f);
  p2_2.col = new PVector(0.0f, 255.0f, 255.0f);
  p1.width = 24.0f;
  p2_1.width = 40.0f;
  p2_2.width = 30.0f;
  p2_1.add(new PVector(0.0f, 0.0f, 0.0f));
  p2_2.add(new PVector(0.0f, 0.0f, 0.0f));
  
  // create native instances
  n = new Native(this, cam_w, cam_h);
  density = new NativeShader(n, "./data/shader/density.glsl");
  velocity = new NativeShader(n, "./data/shader/velocity.glsl");
  obstacles = new NativeShader(n, "./data/shader/obstacles.glsl");
  refraction = new NativeShader(n, "./data/shader/refraction.glsl");
  fluid = new DwFluid2D(n.context, cam_w, cam_h, 1);
  fluid.param.dissipation_velocity = 1f;
  fluid.param.dissipation_density = 1f;
  fluid.addCallback_FluiData(new DwFluid2D.FluidData() {
    public void update(DwFluid2D fluid) {
      //brightsmoke
    }
  });
  
  slide = new Slide();
}

void draw() {
  background(255, 255, 255, 255);
  
  arProcess();
  shaderProcess();
  
  slide.draw();
  
  fill(0, 128, 198, 255);
  textSize(30.0f);
  text("fps : " + frameRate, 30, 60);
}

void arProcess(){
  canvas.beginDraw();
  
  // update markers infomation
  ar.update();
  
  // reset canvas
  background(0.0f, 0.0f, 0.0f, 255.0f);

  for(Iterator<MarkerInfo> it = ar.iterator(); it.hasNext();) {
    MarkerInfo m = it.next();

    ar.beginTransform(m);
    switch(m.getId()) {
      
      case 0: // draw wall points to 3D canvas
        p1.draw(canvas);
        break;
      
      case 1: // add wall points to 3D canvas
        if (m.inactive_time == 0.0f)
          p1.add(ar.getRelativeCoordinates(1, 0));
        break;
        
      case 2: // draw fluid generateing point to 3D canvas
        if (m.inactive_time <= 0.5f) {
          p2_1.draw(canvas);
          p2_2.draw(canvas);
        }
        break;
      
      case 3: // reset all wall points
        if (m.inactive_time == 0.0f)
          p1.reset();
        break;


    }
    ar.endTransform();
  }
  canvas.endDraw();
  
  // draw camera image
  cam.beginDraw();
  cam.image(ar.cam, 0, 0, cam.width, cam.height);
  cam.endDraw();
}

void shaderProcess(){
  density.beginDraw(fluid.tex_density);
  density.s.uniform2f("wh", (float)fluid.tex_density.src.w, (float)fluid.tex_density.src.h);
  density.s.uniform4f("d", 1.0f, 1.0f, 1.0f, 0.5f);
  density.s.uniformTexture("tex_density", fluid.tex_density.src);
  density.s.uniformTexture("tex", n.getGLTextureHandle(canvas));
  density.endDraw();
  
  velocity.beginDraw(fluid.tex_velocity);
  velocity.s.uniform2f("wh", (float)fluid.tex_velocity.src.w, (float)fluid.tex_velocity.src.h);
  velocity.s.uniform2f("v", random(-20.0f, 20.0f), random(0.0f, 100.0f));
  velocity.s.uniformTexture("tex_velocity", fluid.tex_velocity.src);
  velocity.s.uniformTexture("tex", n.getGLTextureHandle(canvas));
  velocity.endDraw();
  
  obstacles.beginDraw(fluid.tex_obstacleC);
  obstacles.s.uniform2f("wh", (float)fluid.tex_obstacleC.src.w, (float)fluid.tex_obstacleC.src.h);
  obstacles.s.uniformTexture("tex", n.getGLTextureHandle(canvas));
  obstacles.endDraw();
  
  fluid.update();
  
  refraction.beginDraw();
  refraction.s.uniform2f("wh", (float)fluid.tex_density.src.w, (float)fluid.tex_density.src.h);
  refraction.s.uniform1f("scale", 4000.0f);
  refraction.s.uniformTexture("tex_density", fluid.tex_density.src);
  refraction.s.uniformTexture("tex", n.getGLTextureHandle(canvas));
  refraction.s.uniformTexture("cam", n.getGLTextureHandle(cam));
  refraction.s.uniform1i("inverted_camera", inverted_camera?1:0);
  refraction.endDraw();
  
  // draw fluid
  float window_aspect = (float)width / (float)height;
  float canvas_aspect = (float)n.canvas.width / (float)n.canvas.height;
  if (window_aspect > canvas_aspect) n.draw(
    (width - (int)((float)n.canvas.width * (float)height / (float)n.canvas.height)) / 2,
    0,
    (int)((float)n.canvas.width * (float)height / (float)n.canvas.height),
    height
  );
  else n.draw(
    0,
    (height - (int)((float)n.canvas.height * (float)width / (float)n.canvas.width)) / 2,
    width,
    (int)((float)n.canvas.height * (float)width / (float)n.canvas.width)
  );
}

void keyPressed(){
  slide.keyPressed();
}
