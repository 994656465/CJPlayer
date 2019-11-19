//
//  CJLrcLabel.m
//  播放器1
//
//  Created by dd luo on 2019/11/5.
//  Copyright © 2019 dd luo. All rights reserved.
//

#import "CJLrcLabel.h"

@implementation CJLrcLabel


-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    if (progress == 0) {
        self.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
    }else{
        self.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];

    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    
    if (self.text.length == 0) {
        [[UIColor clearColor] setFill];
    }else{
        [[UIColor redColor] setFill];

    }
    UIRectFillUsingBlendMode(CGRectMake(0, 0, rect.size.width * _progress , rect.size.height), kCGBlendModeSourceIn);
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
