//
//  musicModel.h
//  播放器1
//
//  Created by dd luo on 2019/10/31.
//  Copyright © 2019 dd luo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface musicModel : NSObject
@property(nonatomic,copy)NSString * image;
@property(nonatomic,copy)NSString * lrc;
@property(nonatomic,copy)NSString * mp3;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * singer;
@property(nonatomic,copy)NSString * zhuanji;
@property (nonatomic, assign) NSInteger  type;




@end

NS_ASSUME_NONNULL_END
