//
//  DialogsViewController.swift
//  Cyna
//
//  Created by Varsha Balasubramaniam on 4/26/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class DialogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QBActionStatusDelegate {

    var activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if LocalStorageService.shared() != nil {
            self.activityIndicator.startAnimating()
            weakSelf = self()
            QBRequest.dialogsWithSuccessBlock(response, dialogObjects, dialogsUsersIDs) {
                weakSelf.dialogs = dialogObjects.mutableCopy
                QBGeneralResponsePage pagedRequest.responsePageWithCurrentPage = 0
                pagedRequest.perPage = 100
                QBRequest.usersWithIDs[DialogsUsersIDs allObjects] page:pagedRequest
                successBlock(QBResponse response, QBGeneralResponsePage page, users) {
                    LocalStorageService.shared() = users
                    weakSelf.dialogsTableView.reloadData()
                    weakSelf.activityIndicator.stopAnimating()
                }
                
            }
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        static dispatch_once_t onceToken
        dispatch_once(onceToken, {
        self.navigationControll
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(ChatViewController) {
            destinationViewController = segue.destinationViewController
            if self.createdDialog != nil {
                destinationViewController.dialog = self.createdDialog
                self.createdDialog = nil
            } else {
                QBChatDialog dialog =
                destinationViewController.dialog = dialog
            }
        }
    }
    

//    
//    - (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    if([LocalStorageService shared].currentUser != nil){
//    [self.activityIndicator startAnimating];
//    
//    // get dialogs
//    
//    __weak __typeof(self)weakSelf = self;
//    [QBRequest dialogsWithSuccessBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs) {
//    
//    weakSelf.dialogs = dialogObjects.mutableCopy;
//    
//    QBGeneralResponsePage *pagedRequest = [QBGeneralResponsePage responsePageWithCurrentPage:0 perPage:100];
//    
//    [QBRequest usersWithIDs:[dialogsUsersIDs allObjects] page:pagedRequest
//    successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
//    
//    [LocalStorageService shared].users = users;
//    
//    [weakSelf.dialogsTableView reloadData];
//    [weakSelf.activityIndicator stopAnimating];
//    
//    } errorBlock:nil];
//    
//    } errorBlock:^(QBResponse *response) {
//    
//    }];
//    }
//    }
//    
//    - (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//    // Show splash
//    [self.navigationController performSegueWithIdentifier:kShowSplashViewControllerSegue sender:nil];
//    });
//    
//    if(self.createdDialog != nil){
//    [self performSegueWithIdentifier:kShowNewChatViewControllerSegue sender:nil];
//    }
//    }
//    
//    
//    #pragma mark
//    #pragma mark Actions
//    
//    - (IBAction)createDialog:(id)sender{
//    [self performSegueWithIdentifier:kShowUsersViewControllerSegue sender:nil];
//    }
//    
//    
//    #pragma mark
//    #pragma mark Storyboard
//    
//    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.destinationViewController isKindOfClass:ChatViewController.class]){
//    ChatViewController *destinationViewController = (ChatViewController *)segue.destinationViewController;
//    
//    if(self.createdDialog != nil){
//    destinationViewController.dialog = self.createdDialog;
//    self.createdDialog = nil;
//    }else{
//    QBChatDialog *dialog = self.dialogs[((UITableViewCell *)sender).tag];
//    destinationViewController.dialog = dialog;
//    }
//    }
//    }
//    
//    
//    #pragma mark
//    #pragma mark UITableViewDelegate & UITableViewDataSource
//    
//    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//    {
//    return [self.dialogs count];
//    }
//    
//    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//    {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatRoomCellIdentifier"];
//    
//    QBChatDialog *chatDialog = self.dialogs[indexPath.row];
//    cell.tag  = indexPath.row;
//    
//    switch (chatDialog.type) {
//    case QBChatDialogTypePrivate:{
//    cell.detailTextLabel.text = @"private";
//    QBUUser *recipient = [LocalStorageService shared].usersAsDictionary[@(chatDialog.recipientID)];
//    cell.textLabel.text = recipient.login == nil ? recipient.email : recipient.login;
//    }
//    break;
//    case QBChatDialogTypeGroup:{
//    cell.detailTextLabel.text = @"group";
//    cell.textLabel.text = chatDialog.name;
//    }
//    break;
//    case QBChatDialogTypePublicGroup:{
//    cell.detailTextLabel.text = @"public group";
//    cell.textLabel.text = chatDialog.name;
//    }
//    break;
//    
//    default:
//    break;
//    }
//    
//    return cell;
//    }
//    
//    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//    {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }


}
