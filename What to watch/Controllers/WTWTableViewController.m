//
//  WTWTableViewController.m
//  What to watch
//
//  Created by Artem Podustov on 2/14/15.
//
//

#import "WTWTableViewController.h"
#import "WTWNetworkingService.h"
#import "NSManagedObject+TypicalActions.h"
#import "WTWMovie.h"
#import "WTWMovieDetailsViewController.h"

#import <UIImageView+AFNetworking.h>

@interface WTWTableViewController ()

@property (strong, nonatomic) NSDateFormatter *dateFormater;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) WTWNetworkingService *service;

@end

@implementation WTWTableViewController

- (void)reloadData {
    __weak typeof(self) weakSelf = self;
    
    [self.service mostPopularMoviesWithSuccessBlock:^(NSArray *items) {
        for (NSDictionary *item in items) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movieId = %@", item[@"id"]];
            WTWMovie *movie = [WTWMovie objectForPredicate:predicate];
            
            [movie setMovieId:item[@"id"]];
            [movie setTitle:item[@"title"]];
            [movie setPopularity:item[@"popularity"]];
            [movie setVoteAverage:item[@"vote_average"]];
            [movie setPosterPath:item[@"poster_path"]];
            [movie setReleaseDate:[self.dateFormater dateFromString:item[@"release_date"]]];
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"popularity" ascending:NO];
        weakSelf.dataSource = [WTWMovie objectsWithPredicate:nil andSortDescriptors:@[sort]];
        [weakSelf.tableView reloadData];
        
    } andFailureBlock:^(NSError *error) {
        weakSelf.dataSource = @[];
    }];
    
    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"movieTableTitle", nil);
    
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
    self.dateFormater = [NSDateFormatter new];
    [self.dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.service = [WTWNetworkingService new];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"MovieCellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    WTWMovie *movie = self.dataSource[indexPath.row];
    
    cell.textLabel.text = movie.title;
    
    NSURLRequest *request = [self.service requestForImagePath:movie.posterPath];
    
    __weak typeof(UITableViewCell) *weakCell = cell;
    
    [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        [weakCell.imageView setImage:image];
        [weakCell setNeedsLayout];
    } failure:nil];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WTWMovieDetailsViewController *details = [segue destinationViewController];
    
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    WTWMovie *movie = self.dataSource[ip.row];
    
    [details setMovieId:movie.movieId];
    [details setTitle:movie.title];
    [details setPosterPath:movie.posterPath];
    [details setReleaseYear:[self.dateFormater stringFromDate:movie.releaseDate]];
    [details setPopularity:[NSString stringWithFormat:@"%.2f", [movie.popularity floatValue]]];
    [details setRating:[movie.voteAverage stringValue]];
}


@end
