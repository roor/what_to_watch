//
//  WTWMovieDetailsViewController.m
//  What to watch
//
//  Created by Artem Podustov on 2/15/15.
//
//

#import "WTWMovieDetailsViewController.h"
#import "WTWNetworkingService.h"
#import <UIImageView+AFNetworking.h>

@interface WTWMovieDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *releaseYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *popularityLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation WTWMovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    WTWNetworkingService *service = [WTWNetworkingService new];
    
    [self.releaseYearLabel setText:self.releaseYear];
    [self.popularityLabel setText:self.popularity];
    [self.ratingLabel setText:self.rating];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLRequest *request = [service requestForImagePath:self.posterPath];
    [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        [weakSelf.imageView setImage:image];
    } failure:nil];
    
    [service movieWithId:[self.movieId stringValue] withSuccessBlock:^(NSDictionary *item) {
        NSMutableArray *genres = [NSMutableArray array];
        for (NSDictionary *genre in item[@"genres"]) {
            [genres addObject:genre[@"name"]];
        }
        
        NSString *genresString = [genres componentsJoinedByString:@", "];
        
        [weakSelf.categoryLabel setText:genresString];
        
    } andFailureBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
