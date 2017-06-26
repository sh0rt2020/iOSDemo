
attribute vec4 Position; // 1
attribute vec4 SourceColor; // 2

varying vec4 DestinationColor; // 3

//just a constant value for all vertices
//mat4 means 4x4 matrix
uniform mat4 Projection;
uniform mat4 ModelView;

void main(void) { // 4
    DestinationColor = SourceColor; // 5
    gl_Position = Projection * ModelView * Position; // 6
}
