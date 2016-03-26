//
//  CoreDataManager.m
//  MyNotePad
//
//  Created by yang johnny on 3/22/16.
//  Copyright © 2016 yang johnny. All rights reserved.
//

#import "CoreDataManager.h"
#import "Notes.h"
#import <CoreData/CoreData.h>

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


-(void)saveContext{
    
    //    NSManagedObjectContext *context = [self managedObjectContext];
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"notes.data"]];
    
    
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) {
        [NSException raise:@"初始化数据库环境失败。" format:@"%@" ,[error localizedDescription]];
    }
    //初始化上下文
    _managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    self.managedObjectContext.persistentStoreCoordinator = psc;
    
}


-(void)insertCoreData:(NSString *)titleName content:(NSString *)content{
    
    //    NSManagedObjectContext *context = [self managedObjectContext];
    
    // 传入上下文，创建一个Person实体对象
    NSManagedObject *notes = [NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext:self.managedObjectContext];
    // 设置Person的简单属性
    [notes setValue:titleName forKey:@"titleName"];
    [notes setValue:content forKey:@"content"];
    
    // 利用上下文对象，将数据同步到持久化存储库
    NSError *error = nil;
    BOOL success = [self.managedObjectContext save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }
    NSLog(@"插入数据成功");
 
}

-(NSMutableArray *)selectData:(NSString *)titleName{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:context];
    
    // 设置条件过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"titleName like %@", titleName];
    request.predicate = predicate;
    // 执行请求
    NSError *error;
    NSArray *objs = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    // 遍历数据
    NSMutableArray *array = [NSMutableArray array];
    for (NSManagedObject *obj in objs) {
        Notes *note = [[Notes alloc]init];
        note.titleName = [obj valueForKey:@"titleName"];
        note.content = [obj valueForKey:@"content"];
        
        [array addObject:note];
        
    }
    NSLog(@"查询成功");
    
    return array;
    
}
//查询所有数据
-(NSMutableArray *)selectAllData{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:self.managedObjectContext];
    
    // 执行请求
    NSError *error;
    NSArray *objs = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    // 遍历数据
    NSMutableArray *array = [NSMutableArray array];
    for (NSManagedObject *obj in objs) {
        Notes *note = [NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext:self.managedObjectContext];
        note.titleName = [obj valueForKey:@"titleName"];
        note.content = [obj valueForKey:@"content"];
        
        [array addObject:note];
        
    }
    NSLog(@"查询所有数据成功");
    return array;
    
}
//删除数据
-(void)deleteData:(NSString *)titleName{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:context];
    request.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"titleName like %@",titleName];
    
    request.predicate = predicate;
    
    NSError *err ;
    
    NSArray *result = [context executeFetchRequest:request error:&err];
    
    for (NSManagedObject *obj in result) {
        [context deleteObject:obj];
    }
    
    NSError *error = nil;
    [context save:&error];
    if (error) {
        [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]];
    }
     NSLog(@"删除成功");
}

//更新数据
-(void)updateData:(NSString *)titleName content:(NSString *)content{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"titleName like %@",titleName];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (Notes *info in result) {
        info.titleName = titleName;
        info.content = content;
        NSManagedObjectID *moID = [info objectID];
        NSLog(@"objectID:%@",moID);
        
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
    
}


@end