//
//  EditTaskViewController.m
//  ToDoApp
//
//  Created by sarrah ashraf on 22/04/2024.
//

#import "EditTaskViewController.h"

#import "Task.h"

@interface EditTaskViewController (){
    NSUserDefaults *userDeff;
    NSData *todoData;
    NSData *inProgressData;
    NSData *doneData;
    NSMutableArray<Task*> *todoArray;
    NSMutableArray<Task*> *inProgressArray;
    NSMutableArray<Task*> *doneArray;
    Task *currentTask;
}
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UIImageView *TaskImg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priortySegment;
@property (weak, nonatomic) IBOutlet UITextField *descTask;
@property (weak, nonatomic) IBOutlet UISegmentedControl *StausSegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@end

@implementation EditTaskViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    userDeff = [NSUserDefaults standardUserDefaults];
    todoData = [userDeff objectForKey:@"todo"];
    inProgressData = [userDeff objectForKey:@"prog"];
    doneData = [userDeff objectForKey:@"don"];
    todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];
    inProgressArray = [NSKeyedUnarchiver unarchiveObjectWithData:inProgressData];
    doneArray = [NSKeyedUnarchiver unarchiveObjectWithData:doneData];

    if (self.taskStatus == 0)
        currentTask = [todoArray objectAtIndex:_taskIndex];
    else if (self.taskStatus == 1)
        currentTask = [inProgressArray objectAtIndex:_taskIndex];
    else if (self.taskStatus == 2)
        currentTask = [doneArray objectAtIndex:_taskIndex];

    _taskTitle.text = currentTask.title;
    _descTask.text = currentTask.descp;
    _priortySegment.selectedSegmentIndex = currentTask.priorty;
    _StausSegment.selectedSegmentIndex = currentTask.state;
    _datePicker.date = currentTask.selectedDate;

    [self updatePriorityImage:currentTask.priorty];
}

- (void)updatePriorityImage:(NSInteger)priority {
    switch (priority) {
        case 0:
            _TaskImg.image = [UIImage imageNamed:@"low"];
            break;
        case 1:
            _TaskImg.image = [UIImage imageNamed:@"medium"];
            break;
        case 2:
            _TaskImg.image = [UIImage imageNamed:@"high"];
            break;
        default:
            _TaskImg.image = nil;
            break;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(_taskStatus == 1){
        [_StausSegment setEnabled:NO forSegmentAtIndex:0];
        [_editBtn setHidden:NO];
    }
    else if(_taskStatus == 2){
        [_StausSegment setEnabled:NO forSegmentAtIndex:0];
        [_StausSegment setEnabled:NO forSegmentAtIndex:1];
        [_editBtn setHidden:YES];
    }else{
        
        [_StausSegment setEnabled:YES forSegmentAtIndex:0];
        [_StausSegment setEnabled:YES forSegmentAtIndex:1];
        [_editBtn setHidden:NO];
    }
    [self.navigationController setNavigationBarHidden:NO];
}


- (IBAction)editBtnClick:(id)sender {
    
    currentTask.title = _taskTitle.text;
    currentTask.descp = _descTask.text;
    currentTask.priorty = _priortySegment.selectedSegmentIndex;
    currentTask.state = _StausSegment.selectedSegmentIndex;
    currentTask.selectedDate = _datePicker.date;
    
    [self validateData];
    
}



-(void) validateData{
    
    NSDate *today = [NSDate new];
    if(_taskTitle.text.length == 0){
        [self alertSetUp:@"Empty title!"];
    }else if(!([_datePicker.date compare: today] == NSOrderedDescending)){
        [self alertSetUp:@"Enter a valid date!"];
    }
    else{
        [self changeStatus];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void) alertSetUp:(NSString *) alertMsg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:Nil];
    
}

-(void) changeStatus{
    if(_StausSegment.selectedSegmentIndex==0){
        
        [todoArray replaceObjectAtIndex:_taskIndex withObject:currentTask];
        
        NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:todoArray ];
        [userDeff setObject:encodedArray forKey:@"todo"];
    }
    else if(_StausSegment.selectedSegmentIndex==1){
        
        
        if(inProgressArray.count == 0){
            inProgressArray = [NSMutableArray new];
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:inProgressArray ];
            [userDeff setObject:encodedArray forKey:@"prog"];
            
        } else{
            inProgressData = [userDeff objectForKey:@"prog"];
            inProgressArray = [NSKeyedUnarchiver unarchiveObjectWithData:inProgressData];
        }
        if(self.taskStatus == 0){
            [todoArray removeObjectAtIndex:_taskIndex];
            NSData *encodedToDoArray = [NSKeyedArchiver archivedDataWithRootObject:todoArray ];
            [userDeff setObject:encodedToDoArray forKey:@"todo"];
            [inProgressArray addObject:currentTask];
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:inProgressArray ];
            [userDeff setObject:encodedArray forKey:@"prog"];
        }else if(self.taskStatus == 1){
            
            [inProgressArray replaceObjectAtIndex:_taskIndex withObject:currentTask];
            
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:inProgressArray ];
            [userDeff setObject:encodedArray forKey:@"prog"];
        }
        
    }else if (_StausSegment.selectedSegmentIndex==2){
        
        if(doneArray.count == 0){
            doneArray = [NSMutableArray new];
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:doneArray ];
            [userDeff setObject:encodedArray forKey:@"don"];
            
        } else{
            doneData = [userDeff objectForKey:@"don"];
            doneArray = [NSKeyedUnarchiver unarchiveObjectWithData:doneData];
        }
        
        if(self.taskStatus == 0){
            [todoArray removeObjectAtIndex:_taskIndex];
            NSData *encodedToDoArray = [NSKeyedArchiver archivedDataWithRootObject:todoArray ];
            [userDeff setObject:encodedToDoArray forKey:@"todo"];

            
            doneData = [userDeff objectForKey:@"don"];
            doneArray = [NSKeyedUnarchiver unarchiveObjectWithData:doneData];
            
            [doneArray addObject:currentTask];
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:doneArray ];
            [userDeff setObject:encodedArray forKey:@"don"];
        }else if(self.taskStatus == 1){
            
                [inProgressArray removeObjectAtIndex:_taskIndex];
                NSData *encodedToDoArray = [NSKeyedArchiver archivedDataWithRootObject:inProgressArray ];
                [userDeff setObject:encodedToDoArray forKey:@"prog"];
            doneData = [userDeff objectForKey:@"don"];
            doneArray = [NSKeyedUnarchiver unarchiveObjectWithData:doneData];
            
            [doneArray addObject:currentTask];
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:doneArray ];
            [userDeff setObject:encodedArray forKey:@"don"];
        }else if(self.taskStatus == 2){
            
            [doneArray replaceObjectAtIndex:_taskIndex withObject:currentTask];
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:doneArray ];
            [userDeff setObject:encodedArray forKey:@"don"];
        }
        
    }
}



@end
