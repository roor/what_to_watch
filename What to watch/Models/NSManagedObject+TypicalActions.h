//
//  NSManagedObject+TypicalActions.h
//  What to watch
//
//  Created by Artem Podustov on 2/15/15.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject(TETypicalActions)

+ (instancetype)objectForPredicate:(NSPredicate *)predicate;
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors;

@end
