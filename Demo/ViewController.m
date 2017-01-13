//
//  ViewController.m
//  Demo
//
//  Created by Satish on 10/01/17.
//  Copyright © 2017 Infosys. All rights reserved.
//

#import "ViewController.h"
#import "DataUtility.h"
#import "CanadaDetails.h"
#import "CustomTableViewCell.h"

#define MAX_HEIGHT 100
#define CELL_CONTENT_MARGIN 20
#define CONSTANT_VALUE_ZERO 0
#define COORDINATE_VALUE 10
#define FONT_SIZE 15.0

@interface ViewController ()

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * details;
@property (nonatomic, strong) NSMutableDictionary * images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createTableView];
    
    self.details = [[NSArray alloc] init];
    self.images = [[NSMutableDictionary alloc] init];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    [refreshButton release];
    [self refreshData];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void)createTableView {
    //Create tableView programatically
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.details count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cellIdentifier";
    CustomTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    CanadaDetails * canadaDetails = [self.details objectAtIndex:indexPath.row];
    cell.cellImageView.image = [UIImage imageNamed:@"default.png"];
    
    if ([self.images objectForKey:canadaDetails.title]) {
        cell.cellImageView.image = [self.images objectForKey:canadaDetails.title];
    }
    else {
        if (![canadaDetails.imageURL isEqual:[NSNull null]]) {
            [DataUtility downloadImageForURL:canadaDetails.imageURL WithCallback:^(BOOL succeeded, NSData * data) {
                if (succeeded) {
                    UIImage * image = [UIImage imageWithData:data];
                    
                    if (image) {
                        //Cache the image for later use when the tableView is scrolled
                        [self.images setValue:image forKey:canadaDetails.title];
                        
                        //Update the self.imageView with the fetched view on a main thread
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            cell.cellImageView.image = image;
                        });
                    }
                }
            }];
        }
    }
    
    cell.titleLabel.text = @"";
    cell.descriptionLabel.text = @"";
    
    if (![canadaDetails.title isEqual:[NSNull null]]) {
        cell.titleLabel.text = canadaDetails.title;
    }
    
    if (![canadaDetails.topicDescription isEqual:[NSNull null]]) {
        cell.descriptionLabel.text = canadaDetails.topicDescription;
    }
    
    cell.titleLabel.frame = CGRectMake(MAX_HEIGHT, COORDINATE_VALUE, self.view.frame.size.width - MAX_HEIGHT, [self getTextHeightForText:cell.titleLabel.text]);
    cell.descriptionLabel.frame = CGRectMake(MAX_HEIGHT, cell.titleLabel.frame.size.height + COORDINATE_VALUE, self.view.frame.size.width - MAX_HEIGHT, [self getTextHeightForText:cell.descriptionLabel.text]);
    
    return cell;
}

- (CGFloat)getTextHeightForText:(NSString*)text {
    if ([text isEqual:[NSNull null]] || [text length] == CONSTANT_VALUE_ZERO) {
        return COORDINATE_VALUE;
    } else {
        CGSize boundingSize = CGSizeMake(self.view.frame.size.width-MAX_HEIGHT, 250);
        NSDictionary *attributeDictionary = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE]
                                                                        forKey:NSFontAttributeName];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributeDictionary];
        
        CGRect rect = [attributedText boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize requiredSize = rect.size;
        [attributedText release];
        return requiredSize.height + COORDINATE_VALUE;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CanadaDetails * canadaDetails = [self.details objectAtIndex:indexPath.row];
    CGFloat titleHeight = [self getTextHeightForText:canadaDetails.title];
    CGFloat descriptionHeight = [self getTextHeightForText:canadaDetails.topicDescription];
    if (titleHeight + descriptionHeight + CELL_CONTENT_MARGIN < MAX_HEIGHT) {
        return MAX_HEIGHT;
    }
    else {
        return titleHeight + descriptionHeight + CELL_CONTENT_MARGIN;
    }
}

-(void)dealloc {
    self.view = nil;
    [self.images release];
    [self.details release];
    [super dealloc];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshData {
    //Make a service call to fetch the Details
    [DataUtility fetchCanadaDetailsWithCallback:^(NSArray *results, NSString *title) {
        self.title = title;
        self.details = results;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

@end
