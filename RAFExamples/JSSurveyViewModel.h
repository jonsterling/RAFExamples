//
//  JSSurveyViewModel.h
//  RAFExamples
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveFormlets/ReactiveFormlets.h>
#import <ReactiveFormlets/RAFValidation.h>
#import <ReactiveFormlets/RAFValidator.h>

extern NSString *const JSSurveyFormErrorDomain;

typedef enum {
    JSSurveyFormValidationErrorCode
} JSSurveyFormErrorCode;

@protocol JSSurveyFormModel <RAFCast>
- (id<RAFString>)name;
- (id<RAFNumber>)age;
+ (instancetype)name:(id<RAFString>)name age:(id<RAFNumber>)age;
@concrete
- (id<JSSurveyFormModel>)raf_cast;
@end

@interface JSSurveyViewModel : NSObject
@property (strong, readonly) RACCommand *doneCommand;
@property (strong, readonly) RAFValidator *nameValidator;
@property (strong, readonly) RAFValidator *ageValidator;
@end
