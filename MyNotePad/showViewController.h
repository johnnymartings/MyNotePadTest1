//
//  showViewController.h
//  MyNotePad
//
//  Created by yang johnny on 3/22/16.
//  Copyright © 2016 yang johnny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notes.h"
@protocol detailDelegate

-(void)showData:(Notes *)note;

@end

@interface showViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)id<detailDelegate> delegate;


@end
