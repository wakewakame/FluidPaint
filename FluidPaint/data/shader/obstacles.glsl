#version 150

precision highp float;
precision highp int;

out vec4 glFragColor;

uniform vec2 wh;
uniform sampler2D tex;

void main() {
	vec2 posn = gl_FragCoord.xy;
	vec4 col = texture(tex, posn / wh);

	glFragColor = vec4((col.r > 0.5)?1.0:0.0);
}