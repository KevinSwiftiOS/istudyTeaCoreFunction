//
//  translate.h
//  拖拽icon的实现
//
//  Created by hznucai on 16/2/19.
//  Copyright © 2016年 hznucai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface translate : NSObject
-(void)audio_PCMtoMP3;
-(void)setWithUrl:(NSString*)cafUrl withMp3Url:(NSString*)mp3Url;
@property(nonatomic)NSString *cafUrl;
@property(nonatomic)NSString *mp3Url;
@property(nonatomic)int i;
@end
