//
//  WTWNetworkingService.h
//  What to watch
//
//  Created by Artem Podustov on 2/15/15.
//
//

#import <Foundation/Foundation.h>

@interface WTWNetworkingService : NSObject

- (void)mostPopularMoviesWithSuccessBlock:(void(^)(NSArray *items))successBlock andFailureBlock:(void(^)(NSError *error))failureBlock ;

- (void)movieWithId:(NSString *)aId withSuccessBlock:(void(^)(NSDictionary *item))successBlock andFailureBlock:(void(^)(NSError *error))failureBlock;

- (NSURLRequest *)requestForImagePath:(NSString *)path;

@end
