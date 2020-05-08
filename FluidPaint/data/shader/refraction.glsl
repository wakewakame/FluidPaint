#version 150

precision highp float;
precision highp int;

out vec4 glFragColor;

uniform vec2 wh;
uniform float scale;
uniform sampler2D tex_density;
uniform sampler2D tex;
uniform sampler2D cam;
uniform int inverted_camera;

float getDensity(vec2 posn) {
	vec4 dVal = texture(tex_density, posn / wh);
	return dVal.a;
}

void main() {
	vec2 posn = gl_FragCoord.xy;
	posn.x = (wh.x - posn.x) * float(inverted_camera) + posn.x * float(1 - inverted_camera);
	vec4 tex_col = texture(tex, posn / wh);

	vec2 normal = vec2(
		getDensity(posn + vec2(1.0, 0.0)) - getDensity(posn),
		getDensity(posn + vec2(0.0, 1.0)) - getDensity(posn)
	);

	vec4 cam_col = texture(cam, (posn + normal * scale) / wh);
	//cam_col = cam_col * 0.5 + vec4(vec3(0.0), 1.0) * 0.5;
	float p = getDensity(posn) * 2.0;
	p *= 0.0; //0.9;
	cam_col = cam_col * (1.0 - p) + vec4(vec3(1.0), 1.0) * p;
	cam_col = cam_col * (1.0 - tex_col.r) + vec4(0.0, 0.5, 0.75, 1.0) * tex_col.r;
	glFragColor = cam_col;
}
