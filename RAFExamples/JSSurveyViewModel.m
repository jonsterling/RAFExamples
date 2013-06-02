//
//  JSSurveyViewModel.m
//  RAFExamples
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "JSSurveyViewModel.h"
#import <ReactiveFormlets/NSArray+RAFMonoid.h>

@implementation JSSurveyViewModel

- (id)init {
    if (self = [super init]) {
        RAFValidator *nameNotNil = [self notNilValidatorWithName:@"name"];
        _nameValidator = [nameNotNil raf_append:[RAFValidator predicate:^RAFValidation *(NSString *text) {
            return text.length > 0 ? [RAFValidation success:text] : [RAFValidation failure:@[ @"name = “”" ]];
        }]];

        RAFValidator *ageNotNil = [self notNilValidatorWithName:@"age"];
        _ageValidator = [ageNotNil raf_append:[RAFValidator predicate:^RAFValidation *(NSNumber *number) {
            return ![number isEqualToNumber:@0] ? [RAFValidation success:number] : [RAFValidation failure:@[ @"age = 0" ]];
        }]];

        RACSignal *validation = RACAbleWithStart(self.validationState);
        RACSignal *isValid = [validation raf_isSuccessSignal];
        _doneCommand = [RACCommand commandWithCanExecuteSignal:isValid];

        RAC(self.message) = [validation map:^(RAFValidation *v) {
            return [v caseSuccess:^(id<JSSurveyFormModel> value) {
                return [NSString stringWithFormat:@"%@ is %@ years old!", value.name, value.age];
            } failure:^(id errors) {
                return [NSString stringWithFormat:@"[%@]", [errors componentsJoinedByString:@", "]];
            }];
        }];
    }

    return self;
}

- (RAFValidator *)notNilValidatorWithName:(NSString *)name {
    return [RAFValidator predicate:^RAFValidation *(id object) {
        NSString *message = [NSString stringWithFormat:@"%@ is nil", name];
        return object ? [RAFValidation success:object] : [RAFValidation failure:@[ message ]];
    }];
}

@end
