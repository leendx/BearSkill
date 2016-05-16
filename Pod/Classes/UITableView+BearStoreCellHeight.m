//
//  UITableView+BearStoreCellHeight.m
//  Pods
//
//  Created by apple on 16/5/16.
//
//

#import "UITableView+BearStoreCellHeight.h"
#import "objc/runtime.h"

static const void *cellFrameDictKey = &cellFrameDictKey;

@implementation UITableView (BearStoreCellHeight)

- (NSDictionary *)cellFrameDict
{
    return objc_getAssociatedObject(self, cellFrameDictKey);
}

- (void)setCellFrameDict:(NSDictionary *)cellFrameDict
{
    objc_setAssociatedObject(self, cellFrameDictKey, cellFrameDict, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.cellFrameDict) {
        self.cellFrameDict = [[NSMutableDictionary alloc] init];
    }
    
    NSString *indexPathStr = [self indexPathToStr:indexPath];
    if ([self.cellFrameDict objectForKey:indexPathStr]) {
        CGRect tempRect = [[self.cellFrameDict objectForKey:indexPathStr] CGRectValue];
        return tempRect.size.height;
    }
    
    return 10;
}

- (void)recordingFrame:(CGRect)frame forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.cellFrameDict) {
        self.cellFrameDict = [[NSMutableDictionary alloc] init];
    }
    
    NSString *indexPath_Key = [self indexPathToStr:indexPath];
    NSValue *tempRect_Value = [NSValue valueWithCGRect:frame];
    
    NSMutableDictionary *tempDict = [self.cellFrameDict mutableCopy];
    [tempDict setObject:tempRect_Value forKey:indexPath_Key];
    self.cellFrameDict = tempDict;
}




//  索引转字符串
- (NSString *)indexPathToStr:(NSIndexPath *)indexPath
{
    NSString *resultStr = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    return resultStr;
}

//  字符串转索引
- (NSIndexPath *)strToIndexPath:(NSString *)str
{
    NSArray *strArray = [str componentsSeparatedByString:@"-"];
    NSInteger section = [strArray[0] integerValue];
    NSInteger row = [strArray[1] integerValue];
    NSIndexPath *resultIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    return resultIndexPath;
}

@end
