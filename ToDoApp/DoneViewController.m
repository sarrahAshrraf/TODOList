//
//  DoneViewController.m
//  ToDoApp
//
//  Created by sarrah ashraf on 21/04/2024.
//

#import "DoneViewController.h"
#import "EditTaskViewController.h"
#import "Task.h"

@interface DoneViewController () {
    NSUserDefaults *userDeff;
    NSData *todoData;
    NSMutableArray<Task*> *lowPriroty;
    NSMutableArray<Task*> *medPriorty;
    NSMutableArray<Task*> *highPiority;
    NSData *inProgressData;
    NSMutableArray<Task*> *inProgressArray;
    NSData *doneData;
    NSMutableArray<Task*> *doneArray;
    Task *task;
    NSUInteger taskIndex;
    BOOL isFiltered;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;


@end
@implementation DoneViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    userDeff = [NSUserDefaults new];
    doneData = [userDeff objectForKey:@"don"];
    doneArray = [NSKeyedUnarchiver unarchiveObjectWithData:doneData];
    
    [self filterToMiniArrays];
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userDeff = [NSUserDefaults new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    todoData = [userDeff objectForKey:@"don"];
    doneArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(isFiltered)
        return 3;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSData *todoData = [userDeff objectForKey:@"don"];
    NSArray<Task*> *todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];
    
    if(!isFiltered)
        return todoArray.count;
        switch(section){
            case 0:
                return [lowPriroty count];
            case 1:
                return [medPriorty count];
            default:
                return [highPiority count];
        }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *doneCell = [tableView dequeueReusableCellWithIdentifier:@"doneCell" forIndexPath:indexPath];
    if(!isFiltered){
        
        doneCell.textLabel.text = [doneArray objectAtIndex:indexPath.row].title;
        
        switch([doneArray objectAtIndex:indexPath.row].priorty){
            case 0:
                doneCell.imageView.image = [UIImage imageNamed:@"low"];
                break;
            case 1:
                doneCell.imageView.image = [UIImage imageNamed:@"medium"];
                break;
            case 2:
                doneCell.imageView.image = [UIImage imageNamed:@"high"];
                break;
        }
    }
    else{
        
        switch(indexPath.section){
            case 0:
                doneCell.textLabel.text = [lowPriroty objectAtIndex:indexPath.row].title;
                doneCell.imageView.image = [UIImage imageNamed:@"low"];
                break;
            case 1:
                doneCell.textLabel.text = [medPriorty objectAtIndex:indexPath.row].title;
                doneCell.imageView.image = [UIImage imageNamed:@"medium"];
                break;
            case 2:
                doneCell.textLabel.text = [highPiority objectAtIndex:indexPath.row].title;
                doneCell.imageView.image = [UIImage imageNamed:@"high"];
                break;
        }
        
    }
    
    return doneCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure to delete the task?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            if(isFiltered){
                switch(indexPath.section){
                    case 0:
                        task = [lowPriroty objectAtIndex:indexPath.row];
                        taskIndex = [doneArray indexOfObject:task];
                        break;
                    case 1:
                        task = [medPriorty objectAtIndex:indexPath.row];
                        taskIndex = [doneArray indexOfObject:task];
                        break;
                    case 2:
                        task = [highPiority objectAtIndex:indexPath.row];
                        taskIndex = [doneArray indexOfObject:task];
                        break;
                }
                
            }else{
                taskIndex = indexPath.row;
            }
            
            [doneArray removeObjectAtIndex:taskIndex];
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:doneArray ];
            [userDeff setObject:encodedArray forKey:@"don"];
            [userDeff synchronize];
            
            [self filterToMiniArrays];
            
            [_tableView reloadData];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:Nil];
        
    }
}

-(void) createAlert:(NSString *) msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:Nil];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditTaskViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editVC"];
    
    editVC.taskStatus = 2;

    if(isFiltered){
        switch(indexPath.section){
            case 0:
                task = [lowPriroty objectAtIndex:indexPath.row];
                editVC.taskIndex = [doneArray indexOfObject:task];
                break;
            case 1:
                task = [medPriorty objectAtIndex:indexPath.row];
                editVC.taskIndex = [doneArray indexOfObject:task];
                break;
            case 2:
                task = [highPiority objectAtIndex:indexPath.row];
                editVC.taskIndex = [doneArray indexOfObject:task];
                break;
        }
        
    }else{
        editVC.taskIndex = indexPath.row;
    }
    
    [self.navigationController pushViewController:editVC animated:YES];

}
- (IBAction)onFilterClcik:(id)sender {
    [_filterBtn setSelected:!isFiltered];
    isFiltered = !isFiltered;
    [_tableView reloadData];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(isFiltered){
        if(section == 0)
        {
            return @"Low";
        }
        else if (section == 1){
            return @"Medium";
        }
        else if (section == 2){
            return @"High";
        }
    }

    return @"";
}
-(void) filterToMiniArrays{
    lowPriroty  = [NSMutableArray new];
    medPriorty  = [NSMutableArray new];
    highPiority  = [NSMutableArray new];
    for(int i=0 ;i <doneArray.count; i++){
        switch([doneArray objectAtIndex:i].priorty){
            case 0:
                [lowPriroty addObject:[doneArray objectAtIndex:i]];
                break;
            case 1:
                [medPriorty addObject:[doneArray objectAtIndex:i]];
                break;
            case 2:
                [highPiority addObject:[doneArray objectAtIndex:i]];
                break;
        }
    }
}

@end
