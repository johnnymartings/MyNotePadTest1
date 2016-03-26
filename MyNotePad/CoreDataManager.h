//
//  CoreDataManager.h
//  MyNotePad
//
//  Created by yang johnny on 3/22/16.
//  Copyright © 2016 yang johnny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notes.h"

#define TableName @"Notes"

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;


//插入数据
- (void)insertCoreData:(NSString *)titleName content:(NSString *)content;
//查询
- (NSMutableArray*)selectData:(NSString *)titleName;
//查询所有的数据
-(NSMutableArray *)selectAllData;
//删除
- (void)deleteData:(NSString *)titleName;
//更新
- (void)updateData:(NSString *)titleName content:(NSString*)content;

@end
