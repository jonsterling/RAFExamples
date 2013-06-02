//
//  JSSurveyViewModel.m
//  RAFExamples
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "JSSurveyViewModel.h"
#import <ReactiveFormlets/RAFValidation.h>

@implementation JSSurveyViewModel

- (id)init
{
    if (self = [super init])
    {
        RACSignal *validation = RACAbleWithStart(self.validationState);
        RACSignal *isValid = [validation raf_isSuccessSignal];
        _doneCommand = [RACCommand commandWithCanExecuteSignal:isValid];

        RAC(self.message) = [validation map:^(RAFValidation *validation) {
            return [validation caseSuccess:^(id<JSSurveyFormModel> value) {
                return [NSString stringWithFormat:@"%@ is %@ years old!", value.name, value.age];
            } failure:^(id errors) {
                return [NSString stringWithFormat:@"[%@]", [errors componentsJoinedByString:@", "]];
            }];
        }];
    }

    return self;
}

@end
