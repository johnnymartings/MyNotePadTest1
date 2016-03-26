//
//  showViewController.m
//  MyNotePad
//
//  Created by yang johnny on 3/22/16.
//  Copyright © 2016 yang johnny. All rights reserved.
//

#import "showViewController.h"
#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "Notes.h"
#import "deleteNoteController.h"


@interface showViewController ()

@property (strong, nonatomic) IBOutlet UINavigationItem *headShow;
@property (strong, nonatomic) IBOutlet UITableView *showTable;
@property (strong, nonatomic) NSArray *array;


@end

@implementation showViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headShow.title = @"记事本";
    
    self.showTable.dataSource = self;
    self.showTable.delegate = self;
    
    
}
//初始化数据
-(void)dealWithData{
    
    CoreDataManager *data = [[CoreDataManager alloc]init];
    [data saveContext];
    self.array = [data selectAllData];
    
}

//返回多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
//返回多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
    
}

//返回怎样的cell，但有一个cell出现在屏幕内就调用
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //带着重用标识符去缓存池中获取cell，如果没有就创建
    //使用static修饰局部变量，保证只分配一次内存
    static NSString *iden  = @"note";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    //获取查询的数据
    CoreDataManager *data = [[CoreDataManager alloc]init];
    [data saveContext];
    self.array = [data selectAllData];
    
    
    Notes *obj =[self.array objectAtIndex:indexPath.row];
    
    cell.textLabel.text  = obj.titleName;
    
    cell.detailTextLabel.text = obj.content;
    cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"notepad" ofType:@".png" ]];
    
    //设置指示器
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //给cell赋值
    //[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle ]
    //可以设置图片和详细小标题
    //    cell.imageView.image = [UIImage imageNamed:grp.icon];
    //    cell.detailTextLabel.text = grp.desc ;
    
    //    UIView *view = [[UIView alloc]init];
    //    view.backgroundColor = [UIColor greenColor];
    //    cell.accessoryView = view;
    //设置选中时候的颜色
    //    cell.selectedBackgroundView = view;
    
    //    NSLog(@"%p",cell);
    //返回cell
    return cell;
    
}
//选中之后跳转到删除页面，使用代理传递选中的数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //初始化Main视图中的delete视图
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    deleteNoteController *deleteCtrl = [sb instantiateViewControllerWithIdentifier:@"delete"];
    
    //实现跳转
    deleteCtrl.view.backgroundColor = [UIColor yellowColor];
    [self.navigationController pushViewController:deleteCtrl animated:YES];
    
    //获取数据中的数据
    CoreDataManager *data = [[CoreDataManager alloc]init];
    [data saveContext];
    self.array = [data selectAllData];
    
    //取得选中行的数据
    Notes *obj =[self.array objectAtIndex:indexPath.row];
    
    self.delegate = deleteCtrl;
    [self.delegate showData:obj];
    
}

//返回之后回刷新显示
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self dealWithData ];
    [self.showTable reloadData];
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
