//
//  DoneViewController.h
//  ToDoApp
//
//  Created by sarrah ashraf on 21/04/2024.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

-(void) filterArrays;

@end

NS_ASSUME_NONNULL_END
