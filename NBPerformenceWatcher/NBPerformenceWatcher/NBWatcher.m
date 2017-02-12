//
//  NBWatcher.m
//  NBPerformenceWatcher
//
//  Created by sunwell on 2017/2/12.
//  Copyright © 2017年 sunwell. All rights reserved.
//

#import "NBWatcher.h"

@interface NBWatcher () {
    
}

@property (nonatomic, assign) CFRunLoopActivity activity;
@property (nonatomic) dispatch_semaphore_t semaphore;
@end

@implementation NBWatcher


static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    NBWatcher *watcher = (__bridge NBWatcher *)info;
    watcher.activity = activity;
    
    dispatch_semaphore_signal(watcher.semaphore);
}


- (void)registerWatcher {
    
    CFRunLoopObserverContext watcherContext = {0, (__bridge void *)self, NULL, NULL};
    CFRunLoopObserverRef watcher = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, runLoopObserverCallBack, &watcherContext);
    CFRunLoopAddObserver(CFRunLoopGetMain(), watcher, kCFRunLoopCommonModes);
    
    self.semaphore = dispatch_semaphore_create(0);
    __block int loopCount = 0;
    
    dispatch_queue_t global_queue = dispatch_get_global_queue(0, 0);
    dispatch_async(global_queue, ^{
        
        while (1) {
            //计算时间
            long duration = dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_SEC));
            if (duration != 0) {
                if (self.activity == kCFRunLoopBeforeSources || self.activity == kCFRunLoopAfterWaiting) {
                    if (++loopCount <= 5)
                        continue;
                }
            }
            loopCount = 0;
        }
    });
}

@end
