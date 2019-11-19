//
//  lrcModel.h
//  播放器1
//
//  Created by dd luo on 2019/11/4.
//  Copyright © 2019 dd luo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface lrcModel : NSObject

@property(nonatomic,copy)NSString * lrcStr;

@property (nonatomic, assign) NSTimeInterval  time;
@end

NS_ASSUME_NONNULL_END
