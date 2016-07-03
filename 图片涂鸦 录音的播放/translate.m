//
//  translate.m
//  拖拽icon的实现
//
//  Created by hznucai on 16/2/19.
//  Copyright © 2016年 hznucai. All rights reserved.
//

#import "translate.h"
#import "lame.h"
@implementation translate
-(void)setWithUrl:(NSString*)cafUrl withMp3Url:(NSString*)mp3Url{
  
    self.cafUrl = cafUrl;
    self.mp3Url = mp3Url;
}
- (void)audio_PCMtoMP3
{
    @try {
        int read,write;

        //被转化的音频文件
        FILE *pcm = fopen([self.cafUrl UTF8String], "rb");
         fseek(pcm, 4 * 1024, SEEK_CUR);
        FILE *mp3 = fopen([self.mp3Url UTF8String], "wb");
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        do{
            read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE,pcm);
            if (read == 0){
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            }else{
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                }
            fwrite(mp3_buffer, write, 1, mp3);
        }while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
                NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"生成成功");
    }
}
   
@end
