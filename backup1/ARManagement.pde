import processing.video.*;
import jp.nyatla.nyar4psg.*;

class ARManagement {
  
	class MarkerInfo {
    public PMatrix3D modelview; 
		public float inactive_time; // time from marker lost
    
    public PMatrix3D modelviewInv() {
      PMatrix3D req = modelview.get();
      req.invert();
      return req;
    }

		{
      modelview = new PMatrix3D(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f);
			inactive_time = 0.0f;
		}
	};

	private PApplet papplet;
	public Capture cam;
	public MultiMarker nya;
  public PMatrix3D projection;
	public MarkerInfo[] marker_info;

	public ARManagement(PApplet tmp_papplet, int w, int h, String[] marker_path) {
		papplet = tmp_papplet;
		cam = new Capture(papplet, w, h, Capture.list()[1]);
		nya = new MultiMarker(papplet, w, h, "./data/camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
    projection = nya.getProjectionMatrix().get();
		marker_info = new MarkerInfo[marker_path.length];

		for(int i = 0; i < marker_path.length; i++) {
			nya.addARMarker(marker_path[i], 80);
      marker_info[i] = new MarkerInfo();
		}

    cam.start();
	}

	public void update() {
		if (cam.available() == true) {
			cam.read();
			nya.detect(cam);
		}
		else {
			for(int i = 0; i < marker_info.length; i++) marker_info[i].inactive_time += 1.0 / papplet.frameRate;
			return;
		}

		for(int i = 0; i < marker_info.length; i++) {
			if(nya.isExist(i)){
				marker_info[i].inactive_time = 0.0f;
        marker_info[i].modelview = nya.getMatrix(i).get();
        marker_info[i].modelview = getMatrix(marker_info[i].modelview);
			}
			else marker_info[i].inactive_time += 1.0 / papplet.frameRate;
		}
	}
  
  // this is wrapper function of MultiMarker.beginTransform()
  // this function is exist for don't use frustum()
  public void beginTransform(int index){
    papplet.pushMatrix();
    setMatrix(ar.marker_info[index].modelview.get());
  }
  
  // this is wrapper function of MultiMarker.endTransform()
  // this function is exist for don't use frustum()
  public void endTransform(){
    papplet.popMatrix();
  }

  // this function return the model view matrix of target marker
  // the matrix has been fixed the conflicts of projection matrix between NyAR and Processing
  private PMatrix3D getMatrix(PMatrix3D modelview){
    PMatrix3D req = new PMatrix3D();
    req = ((PGraphicsOpenGL)papplet.g).projection.get();
    req.invert();
    req.apply(projection);
    req.apply(new PMatrix3D(1.0f, 0.0f, 0.0f, 0.0f, 0.0f, -1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f));
    req.apply(modelview);
    return req;
  }
  
  // this function return the relative coordinates
  public PVector getRelativeCoordinates(int target, int from){
    PMatrix3D mat = ar.marker_info[from].modelviewInv().get();
    PVector req = new PVector();
    mat.apply(ar.marker_info[target].modelview);
    mat.mult(new PVector(0.0f, 0.0f, 0.0f), req);
    return req;
  }
};