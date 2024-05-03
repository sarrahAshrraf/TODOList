//
//  TodoViewController.h
//  ToDoApp
//
//  Created by sarrah ashraf on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "AddTaskViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
-(void) AlertSetup:(NSString *) msg;
@end

NS_ASSUME_NONNULL_END
