//
//  ViewController.m
//  InputView Move
//
//  Created by 思久科技 on 16/6/23.
//  Copyright © 2016年 Seejoys. All rights reserved.
//

#import "ViewController.h"
#import "InputViewTC.h"

@interface ViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *_dataArray;     //列表数据
    UITextField *_currentTF;        //记录当前响应的UITextField
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"键盘抬起时输入框自动上移";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 50.0;
    
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _dataArray = [NSMutableArray arrayWithCapacity:50];
    for (int i = 0; i < 50; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"编号%d", i]];
    }
    
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"InputViewTC";
    
    InputViewTC *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[InputViewTC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.label.text = _dataArray[indexPath.row];
    cell.textField.tag = indexPath.row;
    cell.textField.delegate = self;
    
    return cell;
}

#pragma mark - UITextField 代理事件
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _currentTF = textField;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //增加通知中心监听，当键盘出现或消失时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark - 视图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    //删除通知中心监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 键盘显示隐藏
#pragma mark 键盘显示
- (void)keyboardWillShow:(NSNotification *)notification{
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    //2.计算控制器的view需要移动的距离
    //这里设定tableView的一个cell的高度是50
    CGFloat textField_maxY = (_currentTF.tag + 1) * 50;
    //考虑tableView已经滚动位置
    CGFloat space = - self.tableView.contentOffset.y + textField_maxY;
    //得出键盘距离输入框的间距
    CGFloat transformY = height - space;
    
    //3.当键盘会挡到输入框的时候就开始移动，不然不移动。有时候要考虑导航栏要+64
    if (transformY < 0) {
        CGRect frame = self.view.frame;
        frame.origin.y = transformY ;
        self.view.frame = frame;
    }
}

#pragma mark 键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
}

#pragma mark - 监听点击事件，结束所有编辑状态。
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
