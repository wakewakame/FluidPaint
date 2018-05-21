#version 150

precision highp float;
precision highp int;

uniform vec2 wh;
uniform sampler2D tex;

void main() {
	vec2 posn = gl_FragCoord.xy;
	vec4 col = texture(tex, posn / wh);

	gl_FragColor = vec4((col.r > 0.5)?1.0:0.0);
}