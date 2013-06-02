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

@protocol JSSurveyFormModel
- (id<RAFText>)name;
- (id<RAFNumber>)age;
+ (instancetype)name:(id<RAFText>)name age:(id<RAFNumber>)age;
@end

@interface JSSurveyViewModel : NSObject
@property (strong, readonly) RACCommand *doneCommand;

@property (strong) id<JSSurveyFormModel> data;
@property (strong) RAFValidation *validationState;
@property (strong) NSString *message;
@end
