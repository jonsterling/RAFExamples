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
        RACSignal *validation = RACAble(self.valid);
        _doneCommand = [RACCommand commandWithCanExecuteSignal:validation];
        RAC(self.message) = [RACSignal if:validation then:[RACAble(self.data) map:^id(id<JSSurveyFormModel> data) {
            return [NSString stringWithFormat:@"%@ is %@ years old!", data.name, data.age];
        }] else:[RACSignal empty]];
    }

    return self;
}

@end
