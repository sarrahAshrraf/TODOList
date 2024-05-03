//
//  TodoViewController.m
//  ToDoApp
//
//  Created by sarrah ashraf on 21/04/2024.
//

#import "TodoViewController.h"
#import "Task.h"
#import "TaskTableViewCell.h"
#import "EditTaskViewController.h"

@interface TodoViewController (){
    NSUserDefaults *userDef;
    NSData *todoData;
    BOOL isSearched;
    NSMutableArray *searchArr;
    NSMutableArray<Task*> *todoArray;

}
@property (weak, nonatomic) IBOutlet UITableView *toDoTableView;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;



@end

@implementation TodoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    userDef = [NSUserDefaults new];
    
    todoData = [userDef objectForKey:@"todo"];
    todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];
    [self.toDoTableView reloadData];
    isSearched = NO;
    searchArr = [NSMutableArray new];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        self.noDataLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
        self.noDataLabel.text = @"No data found";
        self.noDataLabel.textColor = [UIColor grayColor];
        self.noDataLabel.textAlignment = NSTextAlignmentCenter;
        self.noDataLabel.hidden = YES;
        [self.view addSubview:self.noDataLabel];
    userDef = [NSUserDefaults new];
    _toDoTableView.dataSource = self;
    _toDoTableView.delegate = self;
    todoData = [userDef objectForKey:@"todo"];
    todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];

}


- (IBAction)addTask:(id)sender {
    AddTaskViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addTaskVC"];
    [self.navigationController pushViewController:addVC animated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowCount = isSearched ? (int)searchArr.count : (int)todoArray.count;
    self.noDataLabel.hidden = (rowCount != 0);
    return rowCount > 0 ? rowCount : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *myCell = (TaskTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!myCell) {
        myCell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if ((isSearched && searchArr.count == 0) || (!isSearched && todoArray.count == 0)) {
        myCell.taskTitle.text = isSearched ? @"" : @"";
        myCell.taskImg.image = nil;
        return myCell;
    }

    Task *task = isSearched ? [searchArr objectAtIndex:indexPath.row] : [todoArray objectAtIndex:indexPath.row];
    myCell.taskTitle.text = task.title;
    switch (task.priorty) {
        case 0:
            myCell.taskImg.image = [UIImage imageNamed:@"low"];
            break;
        case 1:
            myCell.taskImg.image = [UIImage imageNamed:@"medium"];
            break;
        case 2:
            myCell.taskImg.image = [UIImage imageNamed:@"high"];
            break;
    }
    return myCell;
}





- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [todoArray removeObjectAtIndex:indexPath.row];
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:todoArray ];
            [userDef setObject:encodedArray forKey:@"todo"];
            [userDef synchronize];
            [_toDoTableView reloadData];

            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:Nil];
        
    }
}

-(void) AlertSetup:(NSString *) msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:Nil];
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditTaskViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editVC"];
    editVC.taskIndex = indexPath.row;
    editVC.taskStatus = 0;

    [self.navigationController pushViewController:editVC animated:YES];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isSearched = NO;
    } else {
        isSearched = YES;
        [searchArr removeAllObjects];
        for (Task *task in todoArray) {
            NSRange range = [task.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [searchArr addObject:task];
            }
        }
    }
    [_toDoTableView reloadData];
}

@end
