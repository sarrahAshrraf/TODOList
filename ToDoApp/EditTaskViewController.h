//
//  EditTaskViewController.h
//  ToDoApp
//
//  Created by sarrah ashraf on 22/04/2024.
//


#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditTaskViewController : UIViewController
@property NSInteger taskIndex;
-(void) validateData;
@property NSInteger taskStatus;
-(void) alertSetUp:(NSString *) alertMsg;
-(void) changeStatus;
@end

NS_ASSUME_NONNULL_END
