//
//  Task.h
//  ToDoApp
//
//  Created by sarrah ashraf on 22/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject<NSCoding, NSSecureCoding>

@property NSString *title;
@property NSString *descp;
@property int priorty;
@property int state;
@property NSDate *selectedDate;


@end

NS_ASSUME_NONNULL_END

//
//typedef NS_ENUM(NSUInteger, TaskPriority) {
//    TaskPriorityHigh,
//    TaskPriorityMedium,
//    TaskPriorityLow
//};
//
//typedef NS_ENUM(NSUInteger, TaskStatus) {
//    TaskStatusTodo,
//    TaskStatusDone,
//    TaskStatusInProgress
//};
