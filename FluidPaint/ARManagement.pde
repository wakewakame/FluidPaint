import processing.video.*;
import jp.nyatla.nyar4psg.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

class MarkerInfo {
  public PMatrix3D modelview; 
  public float inactive_time = 0.0f; // time from marker lost
  private int id;
  
  {
    modelview = new PMatrix3D(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f);
  }
  
  public MarkerInfo(int tmp_id) {
    id = tmp_id;
  }
  
  public int getId() {
    return id;
  }
  
  public PMatrix3D modelviewInv() {
    PMatrix3D req = modelview.get();
    req.invert();
    return req;
  }
};

class ARManagement {
	private PApplet papplet;
  private PGraphics3D graphics;
	public Capture cam;
	public MultiMarker nya;
  public PMatrix3D projection;
	public List<MarkerInfo> marker_info;

	public ARManagement(PApplet tmp_papplet, PGraphics3D tmp_graphics, int w, int h) {
		init(tmp_papplet, tmp_graphics, w, h);
	}
  public ARManagement(PApplet tmp_papplet, PGraphics3D tmp_graphics) {
    init(tmp_papplet, tmp_graphics, graphics.width, graphics.height);
  }
  
  private void init(PApplet tmp_papplet, PGraphics3D tmp_graphics, int w, int h) {
    papplet = tmp_papplet;
    graphics = tmp_graphics;
    cam = new Capture(papplet, w, h);
    nya = new MultiMarker(papplet, w, h, "./data/camera/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
    projection = nya.getProjectionMatrix().get();
    marker_info = new ArrayList<MarkerInfo>();

    cam.start();
  }
  
  public void addARMarker(String marker_path){
    nya.addARMarker(loadImage(marker_path), 16, 25, 60);
    marker_info.add(new MarkerInfo(marker_info.size()));
  }

	public void update() {
		if (cam.available() == true) {
			cam.read();
			nya.detect(cam);
		}
		else {
			for(int i = 0; i < marker_info.size(); i++) marker_info.get(i).inactive_time += 1.0 / papplet.frameRate;
			return;
		}

		for(int i = 0; i < marker_info.size(); i++) {
			if(nya.isExist(i)){
				marker_info.get(i).inactive_time = 0.0f;
        marker_info.get(i).modelview = nya.getMatrix(i).get();
        marker_info.get(i).modelview = getMatrix(marker_info.get(i).modelview);
			}
			else marker_info.get(i).inactive_time += 1.0 / papplet.frameRate;
		}
	}

  public Iterator<MarkerInfo> iterator() {return marker_info.iterator();}
  
  // this is wrapper function of MultiMarker.beginTransform()
  // this function is exist for don't use frustum()
  public void beginTransform(int index){
    graphics.pushMatrix();
    graphics.setMatrix(ar.marker_info.get(index).modelview.get());
  }
  public void beginTransform(MarkerInfo marker){
    beginTransform(marker.getId());
  }
  
  // this is wrapper function of MultiMarker.endTransform()
  // this function is exist for don't use frustum()
  public void endTransform(){
    graphics.popMatrix();
  }

  // this function return the model view matrix of target marker
  // the matrix has been fixed the conflicts of projection matrix between NyAR and Processing
  private PMatrix3D getMatrix(PMatrix3D modelview){
    PMatrix3D req = new PMatrix3D();
    req = ((PGraphicsOpenGL)graphics).projection.get();
    req.invert();
    req.apply(projection);
    req.apply(new PMatrix3D(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, -1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f));
    req.apply(modelview);
    return req;
  }
  
  // this function return the relative coordinates
  public PVector getRelativeCoordinates(int target, int from){
    PMatrix3D mat = ar.marker_info.get(from).modelviewInv().get();
    PVector req = new PVector();
    mat.apply(ar.marker_info.get(target).modelview);
    mat.mult(new PVector(0.0f, 0.0f, 0.0f), req);
    return req;
  }
};
