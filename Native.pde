import com.jogamp.opengl.GL;
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLSLProgram;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLTexture;

class Native {
	private PApplet papplet;
	public DwPixelFlow context;
  public PGraphics2D canvas;

	public Native(PApplet tmp_papplet, int canvas_width, int canvas_height) {
		papplet = tmp_papplet;
		context = new DwPixelFlow(papplet);
    canvas = (PGraphics2D) createGraphics(canvas_width, canvas_height, P2D);
	}
  public Native(PApplet tmp_papplet) {
    papplet = tmp_papplet;
    context = new DwPixelFlow(papplet);
    canvas = (PGraphics2D) createGraphics(papplet.width, papplet.height, P2D);
  }
  public void draw(int a, int b, int c, int d) {
    papplet.image(canvas, a, b, c, d);
  }
  public void draw(int a, int b) {
    draw(a, b, canvas.width, canvas.height);
  }
  public void draw() {
    draw(0, 0, canvas.width, canvas.height);
  }
  public int getGLTextureHandle(PGraphics2D tex) {
    int[] tmp_framebuffer = new int[1];
    int[] req = new int[1];
    context.gl.glGetIntegerv(GL.GL_FRAMEBUFFER_BINDING, tmp_framebuffer, 0);
    context.getGLTextureHandle(tex, req);
    context.gl.glBindFramebuffer(GL.GL_FRAMEBUFFER, tmp_framebuffer[0]);
    return req[0];
  }
  public int getGLTextureHandle(PGraphics3D tex) {
    int[] tmp_framebuffer = new int[1];
    int[] req = new int[1];
    context.gl.glGetIntegerv(GL.GL_FRAMEBUFFER_BINDING, tmp_framebuffer, 0);
    context.getGLTextureHandle(tex, req);
    context.gl.glBindFramebuffer(GL.GL_FRAMEBUFFER, tmp_framebuffer[0]);
    return req[0];
  }
};

public class NativeShader {
	private Native n;
	public DwGLSLProgram s;
	private DwGLTexture.TexturePingPong tmp;
	{
		tmp = null;
	}
	public NativeShader(Native tmp_n, String frag_path) {
		n = tmp_n;
		s = n.context.createShader(frag_path);
	}
	public NativeShader(Native tmp_n, String vert_path, String frag_path) {
		n = tmp_n;
		s = n.context.createShader(vert_path, frag_path);
	}
	public void beginDraw(DwGLTexture.TexturePingPong frame_buffer) {
		tmp = frame_buffer;
		n.context.begin();
		n.context.beginDraw(frame_buffer.dst);
		s.begin();
		s.uniform2f("resolution", (float)frame_buffer.src.w, (float)frame_buffer.src.h);
		s.uniformTexture("backbuffer", frame_buffer.src);
	}
	public void beginDraw(PGraphics2D graphics) {
		n.context.begin();
		n.context.beginDraw(graphics);
		s.begin();
		s.uniform2f("resolution", (float)graphics.width, (float)graphics.height);
	}
	public void beginDraw(){
		beginDraw(n.canvas);
	}
	public void endDraw(){
		if (tmp != null) tmp.swap();
		s.drawFullScreenQuad();
		s.end();
		n.context.endDraw();
		n.context.end();
		tmp = null;
	}
};

public class NativeFrameBuffer {
	private Native n;
	public DwGLTexture.TexturePingPong f;

	public NativeFrameBuffer(Native tmp_n, int w, int h) {
		n = tmp_n;
		f = new DwGLTexture.TexturePingPong();
		f.resize(n.context, GL.GL_RGBA32F, w, h, GL.GL_RGBA, GL.GL_FLOAT, GL.GL_NEAREST, GL.GL_REPEAT, 4, 1);
	}
  public NativeFrameBuffer(Native tmp_n) {
    n = tmp_n;
    f = new DwGLTexture.TexturePingPong();
    f.resize(n.context, GL.GL_RGBA32F, n.canvas.width, n.canvas.height, GL.GL_RGBA, GL.GL_FLOAT, GL.GL_NEAREST, GL.GL_REPEAT, 4, 1);
  }
};