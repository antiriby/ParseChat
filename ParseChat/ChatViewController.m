//
//  ChatViewController.m
//  ParseChat
//
//  Created by antiriby on 7/10/19.
//  Copyright © 2019 antiriby. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *chatMessageField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    [self onTimer];
}

- (void)onTimer{
    [self.tableView reloadData];
    [self fetchMessages];
}

- (void)fetchMessages{
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2019"];
    //[query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    
    //fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(objects != nil){
            //do something with the array of objects returned by the call
            self.messages = objects;
        } else {
            NSLog(@" %@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2019"];
    
    // Use the name of your outlet to get the text the user typed
    chatMessage[@"text"] = self.chatMessageField.text;
    
    // Save message in background and print successfully
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"The message was saved");
        } else {
            NSLog(@"There was a problem saving the message: %@", error.localizedDescription);
        }
    }];
    
    self.chatMessageField.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    PFObject *message = self.messages[indexPath.row];
    cell.messageLabel.text = message[@"text"];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


@end
