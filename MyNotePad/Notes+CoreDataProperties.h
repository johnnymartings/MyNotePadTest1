//
//  Notes+CoreDataProperties.h
//  MyNotePad
//
//  Created by yang johnny on 3/22/16.
//  Copyright © 2016 yang johnny. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Notes.h"

NS_ASSUME_NONNULL_BEGIN

@interface Notes (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *titleName;

@end

NS_ASSUME_NONNULL_END
