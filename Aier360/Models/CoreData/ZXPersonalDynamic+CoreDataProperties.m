//
//  ZXPersonalDynamic+CoreDataProperties.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/22.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ZXPersonalDynamic+CoreDataProperties.h"

@implementation ZXPersonalDynamic (CoreDataProperties)

@dynamic authority;
@dynamic babyBirthdays;
@dynamic cid;
@dynamic cname;
@dynamic ctype;
@dynamic isTemp;
@dynamic sid;
@dynamic tname;
@dynamic address;
@dynamic latitude;
@dynamic longitude;
@dynamic dynamic;
@dynamic repostDynamics;
@dynamic user;
@dynamic squareLabels;

@end

@implementation ZXPersonalDynamic (CoreDataGeneratedAccessors)
- (void)addSquareLabelsObject:(ZXSquareLabel *)value
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.squareLabels];
    [tempSet addObject:value];
    self.squareLabels = tempSet;
}
@end