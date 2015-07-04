//
//  WTWMovieDetailsViewController.h
//  What to watch
//
//  Created by Artem Podustov on 2/15/15.
//
//

#import <UIKit/UIKit.h>

@interface WTWMovieDetailsViewController : UIViewController

@property (strong, nonatomic) NSString *releaseYear;
@property (strong, nonatomic) NSString *popularity;
@property (strong, nonatomic) NSString *rating;

@property (strong, nonatomic) NSNumber *movieId;


@property (strong, nonatomic) NSString *posterPath;

@end
