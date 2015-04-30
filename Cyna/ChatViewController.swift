//
//  ChatViewController.swift
//  Cyna
//
//  Created by Varsha Balasubramaniam on 4/28/15.
//  Copyright (c) 2015 sickles.ryan. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QBActionStatusDelegate {

    var messages;
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendMessageButton: UIButton!
    @IBOutlet var messagesTableView: UITableView!
    var chatRoom: QBChatRoom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messages = NSMutableArray
        self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone
        
    }



//    - (void)viewDidLoad
//    {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.messages = [NSMutableArray array];
//    
//    self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    
//    - (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    // Set keyboard notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
//    name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
//    name:UIKeyboardWillHideNotification object:nil];
//    
//    // Set chat notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveMessageNotification:)
//    name:kNotificationDidReceiveNewMessage object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatRoomDidReceiveMessageNotification:)
//    name:kNotificationDidReceiveNewMessageFromRoom object:nil];
//    
//    // Set title
//    if(self.dialog.type == QBChatDialogTypePrivate){
//    QBUUser *recipient = [LocalStorageService shared].usersAsDictionary[@(self.dialog.recipientID)];
//    self.title = recipient.login == nil ? recipient.email : recipient.login;
//    }else{
//    self.title = self.dialog.name;
//    }
//    
//    // Join room
//    if(self.dialog.type != QBChatDialogTypePrivate){
//    self.chatRoom = [self.dialog chatRoom];
//    [[ChatService instance] joinRoom:self.chatRoom completionBlock:^(QBChatRoom *joinedChatRoom) {
//    // joined
//    }];
//    }
//    
//    // get messages history
//    
//    __weak __typeof(self)weakSelf = self;
//    [QBRequest messagesWithDialogID:self.dialog.ID successBlock:^(QBResponse *response, NSArray *messages) {
//    
//    if(messages.count > 0){
//    [weakSelf.messages addObjectsFromArray:messages];
//    //
//    [weakSelf.messagesTableView reloadData];
//    [weakSelf.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.messages.count-1 inSection:0]
//    atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    }
//    
//    
//    } errorBlock:^(QBResponse *response) {
//    
//    }];
//    }
//    
//    - (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    [self.chatRoom leaveRoom];
//    self.chatRoom = nil;
//    }
//    
//    -(BOOL)hidesBottomBarWhenPushed
//    {
//    return YES;
//    }
//    
//    #pragma mark
//    #pragma mark Actions
//    
//    - (IBAction)sendMessage:(id)sender{
//    if(self.messageTextField.text.length == 0){
//    return;
//    }
//    
//    // create a message
//    QBChatMessage *message = [[QBChatMessage alloc] init];
//    message.text = self.messageTextField.text;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"save_to_history"] = @YES;
//    [message setCustomParameters:params];
//    
//    // 1-1 Chat
//    if(self.dialog.type == QBChatDialogTypePrivate){
//    // send message
//    message.recipientID = [self.dialog recipientID];
//    message.senderID = [LocalStorageService shared].currentUser.ID;
//    
//    [[ChatService instance] sendMessage:message];
//    
//    // save message
//    [self.messages addObject:message];
//    
//    // Group Chat
//    }else {
//    [[ChatService instance] sendMessage:message toRoom:self.chatRoom];
//    }
//    
//    // Reload table
//    [self.messagesTableView reloadData];
//    if(self.messages.count > 0){
//    [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//    
//    // Clean text field
//    [self.messageTextField setText:nil];
//    }
//    
//    
//    #pragma mark
//    #pragma mark Chat Notifications
//    
//    - (void)chatDidReceiveMessageNotification:(NSNotification *)notification{
//    
//    QBChatMessage *message = notification.userInfo[kMessage];
//    if(message.senderID != self.dialog.recipientID){
//    return;
//    }
//    
//    // save message
//    [self.messages addObject:message];
//    
//    // Reload table
//    [self.messagesTableView reloadData];
//    if(self.messages.count > 0){
//    [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
//    atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//    }
//    
//    - (void)chatRoomDidReceiveMessageNotification:(NSNotification *)notification{
//    QBChatMessage *message = notification.userInfo[kMessage];
//    NSString *roomJID = notification.userInfo[kRoomJID];
//    
//    if(![self.chatRoom.JID isEqualToString:roomJID]){
//    return;
//    }
//    
//    // save message
//    [self.messages addObject:message];
//    
//    // Reload table
//    [self.messagesTableView reloadData];
//    if(self.messages.count > 0){
//    [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
//    atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//    }
//    
//    
//    #pragma mark
//    #pragma mark UITableViewDelegate & UITableViewDataSource
//    
//    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//    {
//    return [self.messages count];
//    }
//    
//    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//    {
//    static NSString *ChatMessageCellIdentifier = @"ChatMessageCellIdentifier";
//    
//    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMessageCellIdentifier];
//    if(cell == nil){
//    cell = [[ChatMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatMessageCellIdentifier];
//    }
//    
//    QBChatAbstractMessage *message = self.messages[indexPath.row];
//    //
//    [cell configureCellWithMessage:message];
//    
//    return cell;
//    }
//    
//    -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    QBChatAbstractMessage *chatMessage = [self.messages objectAtIndex:indexPath.row];
//    CGFloat cellHeight = [ChatMessageTableViewCell heightForCellWithMessage:chatMessage];
//    return cellHeight;
//    }
//    
//    
//    #pragma mark
//    #pragma mark UITextFieldDelegate
//    
//    - (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//    }
//    
//    
//    #pragma mark
//    #pragma mark Keyboard notifications
//    
//    - (void)keyboardWillShow:(NSNotification *)note
//    {
//    [UIView animateWithDuration:0.3 animations:^{
//    self.messageTextField.transform = CGAffineTransformMakeTranslation(0, -250);
//    self.sendMessageButton.transform = CGAffineTransformMakeTranslation(0, -250);
//    self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
//    self.messagesTableView.frame.origin.y,
//    self.messagesTableView.frame.size.width,
//    self.messagesTableView.frame.size.height-252);
//    }];
//    }
//    
//    - (void)keyboardWillHide:(NSNotification *)note
//    {
//    [UIView animateWithDuration:0.3 animations:^{
//    self.messageTextField.transform = CGAffineTransformIdentity;
//    self.sendMessageButton.transform = CGAffineTransformIdentity;
//    self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
//    self.messagesTableView.frame.origin.y,
//    self.messagesTableView.frame.size.width,
//    self.messagesTableView.frame.size.height+252);
//    }];
//    }
}
