//
//  InProgressViewController.h
//  ToDoApp
//
//  Created by sarrah ashraf on 21/04/2024.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InProgressViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

-(void) filterArray;

@end

NS_ASSUME_NONNULL_END
