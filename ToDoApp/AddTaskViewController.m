//
//  AddTaskViewController.m
//  ToDoApp
//
//  Created by sarrah ashraf on 22/04/2024.
//
#import "AddTaskViewController.h"
#import "Task.h"

@interface AddTaskViewController (){
    NSUserDefaults *userDeff;
    NSData *todoData;
    NSMutableArray<Task*> *todoArray;
}
@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UITextField *descTaks;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prirtySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    _datePicker.minimumDate = [NSDate new];
    userDeff = [NSUserDefaults standardUserDefaults];
    todoData = [userDeff objectForKey:@"todo"];
    if (todoData) {
        todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];
    } else {
        todoArray = [[NSMutableArray alloc] init];
    }
    [_statusSegment setEnabled:YES forSegmentAtIndex:0];
     NSInteger segmentCount = _statusSegment.numberOfSegments;
     for (NSInteger i = 1; i < segmentCount; i++) {
         [_statusSegment setEnabled:NO forSegmentAtIndex:i];
     }
}
-(void) setUpAlert:(NSString *) alertMsg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)onAddClick:(id)sender {
    if (_taskTitle.text.length == 0) {
        [self setUpAlert:@"Empty Title!"];
    } else {
        Task *task = [[Task alloc] init];
        task.descp = _descTaks.text;
        task.title = _taskTitle.text;
        task.priorty = _prirtySegment.selectedSegmentIndex;
        task.state = _statusSegment.selectedSegmentIndex;
        task.selectedDate = _datePicker.date;
        [todoArray addObject:task];
        NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:todoArray requiringSecureCoding:NO error:nil];
        [userDeff setObject:encodedArray forKey:@"todo"];
        [userDeff synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
