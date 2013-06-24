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

@protocol JSSurveyFormModel <RAFExtract>
- (id<RAFText>)name;
- (id<RAFNumber>)age;
+ (instancetype)name:(id<RAFText>)name age:(id<RAFNumber>)age;
@concrete
- (id<JSSurveyFormModel>)raf_extract;
@end

@interface JSSurveyViewModel : NSObject
@property (strong, readonly) RACCommand *doneCommand;
@property (strong, readonly) RAFValidator *nameValidator;
@property (strong, readonly) RAFValidator *ageValidator;

@property (strong) RAFValidation *validationState;
@property (strong, readonly) NSString *message;
@end
