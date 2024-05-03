//
//  Task.m
//  ToDoApp
//
//  Created by sarrah ashraf on 22/04/2024.
//


#import "Task.h"

@implementation Task

-(void) encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.descp forKey:@"descp"];
    [encoder encodeInteger:self.priorty forKey:@"priorty"];
    [encoder encodeInteger:self.state forKey:@"state"];
    [encoder encodeObject:self.selectedDate forKey:@"selectedDate"];
    
    
}

- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super init]){
        self.title = [decoder decodeObjectForKey:@"title"];
        self.descp = [decoder decodeObjectForKey:@"descp"];
        self.priorty = [decoder decodeIntegerForKey:@"priorty"];
        self.state = [decoder decodeIntegerForKey:@"state"];
        self.selectedDate = [decoder decodeObjectForKey:@"selectedDate"];
    }
    return self;
}

+(BOOL) supportsSecureCoding{
    return YES;
}

@end
