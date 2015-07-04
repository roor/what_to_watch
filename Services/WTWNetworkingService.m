//
//  WTWNetworkingService.m
//  What to watch
//
//  Created by Artem Podustov on 2/15/15.
//
//

#import "WTWNetworkingService.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const baseURLString = @"http://api.themoviedb.org/3/";
static NSString *const imageBaseURLString = @"http://image.tmdb.org/t/p/w500";
static NSString *const APIKey = @"cfef1b81c95543bf4dedb4d3297a68e1";

@implementation WTWNetworkingService

- (void)mostPopularMoviesWithSuccessBlock:(void(^)(NSArray *items))successBlock andFailureBlock:(void(^)(NSError *error))failureBlock {
    [self makeRequestWithPath:@"/discover/movie" andParams:@{@"sort_by":@"popularity.desc"} successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject[@"results"]);
    } andFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failureBlock(error);
    }];
}

- (void)movieWithId:(NSString *)aId withSuccessBlock:(void(^)(NSDictionary *item))successBlock andFailureBlock:(void(^)(NSError *error))failureBlock {
    [self makeRequestWithPath:[NSString stringWithFormat:@"/movie/%@", aId] andParams:nil successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } andFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failureBlock(error);
    }];
}

- (NSURLRequest *)requestForImagePath:(NSString *)path {
    NSURL *URL = [NSURL URLWithString:[imageBaseURLString stringByAppendingPathComponent:path]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Accept"];
    
    return [request copy];
}

- (NSURLRequest *)requestWithPath:(NSString *)path andParams:(NSDictionary *)params {
    
    NSMutableString *extraParams = [NSMutableString string];
    for (NSString *key in [params allKeys]) {
        [extraParams appendFormat:@"&%@=%@", key, params[key]];
    }

    NSURL *URL = [NSURL URLWithString:[baseURLString stringByAppendingPathComponent:[NSString stringWithFormat:@"%@?api_key=%@%@", path, APIKey, extraParams]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return [request copy];
}

- (void)makeRequestWithPath:(NSString *)path andParams:(NSDictionary *)params successBlock:(void(^)(AFHTTPRequestOperation *operation, id responseObject))successBlock andFailureBlock:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {
    
    NSURLRequest *request = [self requestWithPath:path andParams:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        successBlock(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failureBlock(operation, error);
        
    }];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [operation start];
}

@end
