//
//  WTWMovieAbstract.h
//  What to watch
//
//  Created by Artem Podustov on 2/15/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WTWMovieAbstract : NSManagedObject

@property (nonatomic, retain) NSString * posterPath;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * movieId;
@property (nonatomic, retain) NSNumber * popularity;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSNumber * voteAverage;
@property (nonatomic, retain) NSString * category;

@end
