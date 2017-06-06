//
//  GS_RotationGuestreRecognizer.h
//  GS_RotationGuestreRecognizer-Master
//
//

#import <UIKit/UIKit.h>

@interface GS_RotationGuestreRecognizer : UIGestureRecognizer
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic,assign)BOOL isZoom;
@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, strong) UIView *effectView;
@end
