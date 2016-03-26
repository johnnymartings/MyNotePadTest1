//
//  addNoteController.m
//  MyNotePad
//
//  Created by yang johnny on 3/22/16.
//  Copyright © 2016 yang johnny. All rights reserved.
//

#import "addNoteController.h"
#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "Notes.h"


@interface addNoteController ()

@property (strong, nonatomic) IBOutlet UITextField *titleName;

@property (strong, nonatomic) IBOutlet UITextView *content;

- (IBAction)saveBtn:(UIButton *)sender;

//- (IBAction)saveContent:(UIBarButtonItem *)sender;

@end

@implementation addNoteController

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

- (IBAction)saveBtn:(UIButton *)sender {

    CoreDataManager *data = [[CoreDataManager alloc]init];
    [data saveContext];
    self.context = [data managedObjectContext];
    
    //调用CoreDataManager类来操作数据
    [data insertCoreData:self.titleName.text content:self.content.text];
    
    NSLog(@"保存成功。");
    //弹框提示操作成功
    UIAlertController *uialert = [UIAlertController alertControllerWithTitle:@"恭喜!" message:@"添加成功。" preferredStyle:UIAlertControllerStyleAlert];
    [uialert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    //启动弹框
    [self presentViewController:uialert animated:NO completion:nil];

}

@end
