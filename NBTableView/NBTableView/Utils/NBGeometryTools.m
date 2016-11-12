//
//  NBGeometryTools.m
//  NBTableView
//
//  Created by sunwell on 2016/11/12.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import "NBGeometryTools.h"


CGRect CGRectUseEdge(CGRect parent, UIEdgeInsets edge) {
    
    float startX =CGRectGetMinX(parent) + edge.left;
    float startY = CGRectGetMinY(parent) + edge.top;
    float endX = CGRectGetMaxX(parent) - edge.right;
    float endY = CGRectGetMaxY(parent) - edge.bottom;
    return CGRectMake(startX, startY, endX - startX, endY - startY);
}

CGPoint CGPointCenterRect(CGRect rect) {
    
    return CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)/2);
}

float CGDistanceBetweenPoints(CGPoint p1, CGPoint p2) {
    
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
}


@implementation NBGeometryTools

@end
