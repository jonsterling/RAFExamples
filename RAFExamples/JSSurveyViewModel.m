//
//  JSSurveyViewModel.m
//  RAFExamples
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "JSSurveyViewModel.h"

@implementation JSSurveyViewModel

- (id)init
{
    if (self = [super init])
    {
        RACSignal *validation = RACAbleWithStart(self.valid);
        _doneCommand = [RACCommand commandWithCanExecuteSignal:validation];

        NSArray *composite = @[ RACAbleWithStart(self.data), validation ];
        RAC(self.message) = [RACSignal combineLatest:composite reduce:^(id<JSSurveyFormModel> data, NSNumber *isValid) {
            return isValid.boolValue ? [NSString stringWithFormat:@"%@ is %@ years old!", data.name, data.age] : @"not valid";
        }];
    }

    return self;
}

@end
