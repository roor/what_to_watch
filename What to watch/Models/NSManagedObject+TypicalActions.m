//
//  NSManagedObject+TypicalActions.m
//  What to watch
//
//  Created by Artem Podustov on 2/15/15.
//
//

#import "NSManagedObject+TypicalActions.h"
#import "AppDelegate.h"

@implementation NSManagedObject(TETypicalActions)

+ (instancetype)object {
    NSManagedObjectContext *moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    id result = [[self class] objectInContext:moc];
    return result;
}

+ (instancetype)objectInContext:(NSManagedObjectContext *)aContext {
    id result = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:aContext];
    return result;
}

+ (instancetype)objectForPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSArray *result = [moc executeFetchRequest:request error:&error];
    id entity = nil;
    
    if ([result count] > 0) {
        entity = [result lastObject];
    }
    else {
        entity = [[self class] object];
    }
    
    return entity;
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors {
    
    NSError *error = nil;
    NSManagedObjectContext *moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSArray *result = [moc executeFetchRequest:request error:&error];
    
    return result;
}

@end
