//
//  IFRiseFilter.m
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import "IFRiseFilter.h"

//NSString *const kIFRiseShaderString = SHADER_STRING
//(
// precision lowp float;
//
// varying highp vec2 textureCoordinate;
//
// uniform sampler2D inputImageTexture;
// uniform sampler2D inputImageTexture2; //blowout;
// uniform sampler2D inputImageTexture3; //overlay;
// uniform sampler2D inputImageTexture4; //map
//
// void main()
// {
//
//     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
//     vec3 bbTexel = texture2D(inputImageTexture2, textureCoordinate).rgb;
//
//     texel.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
//     texel.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
//     texel.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
//
//     vec4 mapped;
//     mapped.r = texture2D(inputImageTexture4, vec2(texel.r, .16666)).r;
//     mapped.g = texture2D(inputImageTexture4, vec2(texel.g, .5)).g;
//     mapped.b = texture2D(inputImageTexture4, vec2(texel.b, .83333)).b;
//     mapped.a = 1.0;
//
//     gl_FragColor = mapped;
// }
// );

NSString * const kIFRiseShaderString = SHADER_STRING
(
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform lowp float saturation;  //饱和度
 
 const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721); //rgb对应的亮度
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 filterTextureColor = texture2D(inputImageTexture2, textureCoordinate);
     
     lowp float luminance = dot(textureColor.rgb, filterTextureColor.rgb);
     lowp vec3 colorScale = vec3(luminance);
     
     gl_FragColor = vec4(mix(colorScale, textureColor.rgb, saturation), textureColor.w);
 }
 
 );

@implementation IFRiseFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFRiseShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
