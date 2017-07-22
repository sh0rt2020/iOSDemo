//can't write with chinese charaters
//step two:texture
attribute vec4 Position;
attribute vec4 SourceColor;

varying vec4 DestinationColor;

uniform mat4 Projection;
uniform mat4 Modelview;

attribute vec2 TexCoordIn; //new
varying vec2 TexCoordOut; //new

void main(void) {
    DestinationColor = SourceColor;
    gl_Position = Projection * Modelview * Position;
    TexCoordOut = TexCoordIn; //new
}
