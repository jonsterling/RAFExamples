//
//  JSSurveyViewModel.m
//  RAFExamples
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "JSSurveyViewModel.h"
#import <ReactiveFormlets/NSArray+RAFMonoid.h>

NSString *const JSSurveyFormErrorDomain = @"JSSurveyFormErrorDomain";

@interface JSSurveyViewModel ()
@property (strong, readwrite) NSString *message;
@end

@implementation JSSurveyViewModel

- (id)init {
    if (self = [super init]) {
        RAFValidator *nameNotNil = [self notNilValidatorWithName:@"name"];
        _nameValidator = [nameNotNil raf_append:[RAFValidator predicate:^BOOL(NSString *text) {
            return text.length > 0;
        } error:^NSError *(id object) {
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"name == “”" };
            return [NSError errorWithDomain:JSSurveyFormErrorDomain code:JSSurveyFormValidationErrorCode userInfo:userInfo];
        }]];

        RAFValidator *ageNotNil = [self notNilValidatorWithName:@"age"];
        _ageValidator = [ageNotNil raf_append:[RAFValidator predicate:^BOOL(NSNumber *age) {
            return ![age isEqualToNumber:@0];
        } error:^NSError *(id object) {
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"age == 0" };
            return [NSError errorWithDomain:JSSurveyFormErrorDomain code:JSSurveyFormValidationErrorCode userInfo:userInfo];
        }]];

        _doneCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RAFValidation *validation) {
            NSString *message = [validation caseSuccess:^(id<JSSurveyFormModel> value) {
                return [NSString stringWithFormat:@"%@ is %i years old!", value.name.raf_cast, value.age.raf_cast.integerValue];
            } failure:^(NSArray *errors) {
                NSArray *descriptions = [errors.rac_sequence map:^(NSError *error) {
                    return error.localizedDescription;
                }].array;

                return [NSString stringWithFormat:@"[%@]", [descriptions componentsJoinedByString:@", "]];
            }];

            return [RACSignal return:message];
        }];
    }

    return self;
}

- (RAFValidator *)notNilValidatorWithName:(NSString *)name {
    return [RAFValidator predicate:^BOOL(id object) {
        return object != nil;
    } error:^NSError *(id object) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@ is nil", name] };
        return [NSError errorWithDomain:JSSurveyFormErrorDomain code:JSSurveyFormValidationErrorCode userInfo:userInfo];
    }];
}

@end
