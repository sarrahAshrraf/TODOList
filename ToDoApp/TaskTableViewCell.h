//
//  TaskTableViewCell.h
//  ToDoApp
//
//  Created by sarrah ashraf on 22/04/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *taskImg;
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;

@end

NS_ASSUME_NONNULL_END
