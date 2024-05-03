//
//  InProgressViewController.m
//  ToDoApp
//
//  Created by sarrah ashraf on 21/04/2024.
//


#import "InProgressViewController.h"
#import "Task.h"
#import "EditTaskViewController.h"

@interface InProgressViewController (){
    NSUserDefaults *userDefults;
    NSData *todoData;
    NSMutableArray<Task*> *highPiority;
    NSMutableArray<Task*> *lowPriority;
    NSMutableArray<Task*> *medPriorty;
    NSData *inProgressData;
    NSMutableArray<Task*> *inProgressArray;
    Task *task;
    NSUInteger taskIndex;
    BOOL isFiltered;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;


@end

@implementation InProgressViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    userDefults = [NSUserDefaults new];
    inProgressData = [userDefults objectForKey:@"prog"];
    inProgressArray = [NSKeyedUnarchiver unarchiveObjectWithData:inProgressData];
    
    [self filterArray];
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefults = [NSUserDefaults new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    todoData = [userDefults objectForKey:@"prog"];
    inProgressArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];
    // Do any additional setup after loading the view.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(isFiltered)
        return 3;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSData *todoData = [userDefults objectForKey:@"prog"];
    NSArray<Task*> *todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];
    
    if(!isFiltered)
        return todoArray.count;
        switch(section){
            case 0:
                return [lowPriority count];
            case 1:
                return [medPriorty count];
            default:
                return [highPiority count];
        }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *proCell = [tableView dequeueReusableCellWithIdentifier:@"progressCell" forIndexPath:indexPath];
    
    if(!isFiltered){
        
        proCell.textLabel.text = [inProgressArray objectAtIndex:indexPath.row].title;
        
        switch([inProgressArray objectAtIndex:indexPath.row].priorty){
            case 0:
                proCell.imageView.image = [UIImage imageNamed:@"low"];
                break;
            case 1:
                proCell.imageView.image = [UIImage imageNamed:@"medium"];
                break;
            case 2:
                proCell.imageView.image = [UIImage imageNamed:@"high"];
                break;
        }
    }
    else{
        
        switch(indexPath.section){
            case 0:
                proCell.textLabel.text = [lowPriority objectAtIndex:indexPath.row].title;
                proCell.imageView.image = [UIImage imageNamed:@"low"];
                break;
            case 1:
                proCell.textLabel.text = [medPriorty objectAtIndex:indexPath.row].title;
                proCell.imageView.image = [UIImage imageNamed:@"medium"];
                break;
            case 2:
                proCell.textLabel.text = [highPiority objectAtIndex:indexPath.row].title;
                proCell.imageView.image = [UIImage imageNamed:@"high"];
                break;
        }
        
    }
    
    return proCell;
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
                        task = [lowPriority objectAtIndex:indexPath.row];
                        taskIndex = [inProgressArray indexOfObject:task];
                        break;
                    case 1:
                        task = [medPriorty objectAtIndex:indexPath.row];
                        taskIndex = [inProgressArray indexOfObject:task];
                        break;
                    case 2:
                        task = [highPiority objectAtIndex:indexPath.row];
                        taskIndex = [inProgressArray indexOfObject:task];
                        break;
                }
                
            }else{
                taskIndex = indexPath.row;
            }
            
            [inProgressArray removeObjectAtIndex:taskIndex];
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:inProgressArray ];
            [userDefults setObject:encodedArray forKey:@"prog"];
            [userDefults synchronize];
            
            [self filterArray];
            
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
    
    editVC.taskStatus = 1;

    if(isFiltered){
        switch(indexPath.section){
            case 0:
                task = [lowPriority objectAtIndex:indexPath.row];
                editVC.taskIndex = [inProgressArray indexOfObject:task];
                break;
            case 1:
                task = [medPriorty objectAtIndex:indexPath.row];
                editVC.taskIndex = [inProgressArray indexOfObject:task];
                break;
            case 2:
                task = [highPiority objectAtIndex:indexPath.row];
                editVC.taskIndex = [inProgressArray indexOfObject:task];
                break;
        }
        
    }else{
        editVC.taskIndex = indexPath.row;
    }
    
    [self.navigationController pushViewController:editVC animated:YES];

}
- (IBAction)filterBtn:(id)sender {
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
-(void) filterArray{
    lowPriority  = [NSMutableArray new];
    medPriorty  = [NSMutableArray new];
    highPiority  = [NSMutableArray new];
    for(int i=0 ;i <inProgressArray.count; i++){
        switch([inProgressArray objectAtIndex:i].priorty){
            case 0:
                [lowPriority addObject:[inProgressArray objectAtIndex:i]];
                break;
            case 1:
                [medPriorty addObject:[inProgressArray objectAtIndex:i]];
                break;
            case 2:
                [highPiority addObject:[inProgressArray objectAtIndex:i]];
                break;
        }
    }
}

@end
