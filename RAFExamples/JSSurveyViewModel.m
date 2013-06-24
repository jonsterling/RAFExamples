//
//  JSSurveyViewModel.m
//  RAFExamples
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "JSSurveyViewModel.h"
#import <ReactiveFormlets/NSArray+RAFMonoid.h>

@interface JSSurveyViewModel ()
@property (strong, readwrite) NSString *message;
@end

@implementation JSSurveyViewModel

- (id)init {
    if (self = [super init]) {
        RAFValidator *nameNotNil = [self notNilValidatorWithName:@"name"];
        _nameValidator = [nameNotNil raf_append:[RAFValidator predicate:^BOOL(NSString *text) {
            return text.length > 0;
        } errors:^NSArray *(id object) {
            return @[ @"name = “”" ];
        }]];

        RAFValidator *ageNotNil = [self notNilValidatorWithName:@"age"];
        _ageValidator = [ageNotNil raf_append:[RAFValidator predicate:^BOOL(NSNumber *age) {
            return ![age isEqualToNumber:@0];
        } errors:^NSArray *(id object) {
            return @[ @"age = 0" ];
        }]];

        RACSignal *validation = RACAbleWithStart(self.validationState);
        RACSignal *isValid = [validation raf_isSuccessSignal];
        _doneCommand = [RACCommand commandWithCanExecuteSignal:isValid];

        RAC(self.message) = [validation map:^(RAFValidation *v) {
            return [v caseSuccess:^(id<JSSurveyFormModel> value) {
                return [NSString stringWithFormat:@"%@ is %@ years old!", value.name.raf_extract, value.age.raf_extract];
            } failure:^(id errors) {
                return [NSString stringWithFormat:@"[%@]", [errors componentsJoinedByString:@", "]];
            }];
        }];
    }

    return self;
}

- (RAFValidator *)notNilValidatorWithName:(NSString *)name {
    return [RAFValidator predicate:^BOOL(id object) {
        return object != nil;
    } errors:^NSArray *(id object) {
        NSString *message = [NSString stringWithFormat:@"%@ is nil", name];
        return @[ message ];
    }];
}

@end
