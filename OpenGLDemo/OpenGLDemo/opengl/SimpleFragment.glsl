
//第一阶段：旋转的方块
//varying lowp vec4 DestinationColor; // 1
//
//void main(void) { // 2
//    gl_FragColor = DestinationColor; // 3
//}

//第二阶段：带纹理的方块
varying lowp vec4 DestinationColor;

varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

void main(void) {
    gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut); // New
}

