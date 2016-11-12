//
//  NBGeometryTools.h
//  NBTableView
//
//  Created by sunwell on 2016/11/12.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

CGRect CGRectUseEdge(CGRect parent, UIEdgeInsets edge);
CGPoint CGPointCenterRect(CGRect rect);
float CGDistanceBetweenPoints(CGPoint p1, CGPoint p2);

@interface NBGeometryTools : NSObject

@end
