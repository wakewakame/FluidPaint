#version 150

precision highp float;
precision highp int;

out vec4 glFragColor;

uniform vec2 wh;
uniform vec4 d;
uniform sampler2D tex_density;
uniform sampler2D tex;

void main() {
	vec2 posn = gl_FragCoord.xy;
	vec4 col = texture(tex, posn / wh);
	vec4 old = texture(tex_density, posn / wh) * 0.99;

	glFragColor = col.g * d + (1.0 - col.g) * old;
}