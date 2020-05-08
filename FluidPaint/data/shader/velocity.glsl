#version 150

precision highp float;
precision highp int;

out vec4 glFragColor;

uniform vec2 wh;
uniform vec2 v;
uniform sampler2D tex_velocity;
uniform sampler2D tex;

void main() {
	vec2 posn = gl_FragCoord.xy;
	vec4 col = texture(tex, posn / wh);
	vec4 old = texture(tex_velocity, posn / wh);

	glFragColor = col.b * vec4(v, 0.0, 1.0) + (1.0 - col.b) * old;
}