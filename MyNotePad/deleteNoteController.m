//
//  deleteNoteController.m
//  MyNotePad
//
//  Created by yang johnny on 3/22/16.
//  Copyright © 2016 yang johnny. All rights reserved.
//

#import "deleteNoteController.h"
#import "showViewController.h"
#import "CoreDataManager.h"

@interface deleteNoteController ()

@property (strong, nonatomic) IBOutlet UITextField *deletedTitle;
@property (strong, nonatomic) IBOutlet UITextView *deletedContent;

- (IBAction)deleteNote:(UIButton *)sender;
- (IBAction)backAndRef:(UIButton *)sender;

@end

@implementation deleteNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)deleteNote:(UIButton *)sender {
    
    CoreDataManager *data = [[CoreDataManager alloc]init];
    [data saveContext];
    //删除数据
    [data deleteData:self.deletedTitle.text];
    NSLog(@"删除成功");
    //弹出提示框
    UIAlertController *uialert = [UIAlertController alertControllerWithTitle:@"恭喜!" message:@"删除成功。" preferredStyle:UIAlertControllerStyleAlert];
    [uialert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    
    //启动弹框
    [self presentViewController:uialert animated:NO completion:nil];

}

- (IBAction)backAndRef:(UIButton *)sender {
    
    CoreDataManager *data = [[CoreDataManager alloc]init];
    [data saveContext];
    //更新数据
    [data updateData:self.deletedTitle.text content:self.deletedContent.text];
    NSLog(@"保存成功");
    //弹出提示框
    UIAlertController *uialert = [UIAlertController alertControllerWithTitle:@"恭喜!" message:@"保存成功。" preferredStyle:UIAlertControllerStyleAlert];
    [uialert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    
    //启动弹框
    [self presentViewController:uialert animated:NO completion:nil];

}
-(void)showData:(Notes *)obj{

    self.deletedTitle.text = obj.titleName;
    self.deletedContent.text = obj.content;

}


@end
