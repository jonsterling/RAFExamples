//
//  JSSurveyViewController.m
//  RAFExamples
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "JSSurveyViewController.h"
#import <ReactiveFormlets/ReactiveFormlets.h>
#import <ReactiveFormlets/RAFTableForm.h>
#import <ReactiveFormlets/RAFInputRow.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveFormlets/EXTScope.h>
#import "JSSurveyViewModel.h"

@interface JSSurveyViewController ()
@property (strong) JSSurveyViewModel *viewModel;
@end
@implementation JSSurveyViewController {
    RAFSingleSectionTableForm<JSSurveyFormModel> *_form;
}

- (void)loadView
{
    [super loadView];

    _viewModel = [JSSurveyViewModel new];

    Class JSSurveyForm = [RAFSingleSectionTableForm model:@protocol(JSSurveyFormModel)];

    RAFValidator requiredText = ^BOOL (NSString *text) {
        return text.length > 0;
    };
    RAFValidator notZero = ^BOOL (NSNumber *number) {
        return number && ![number isEqualToNumber:@0];
    };

    id<RAFText> nameField = [[[RAFTextInputRow new] placeholder:@"George Smiley"] validators:@[ requiredText ]];
    id<RAFNumber> ageField = [[[RAFNumberInputRow new] placeholder:@"62"] validators:@[ notZero ]];

    _form = [JSSurveyForm name:nameField age:ageField];
    RAC(_viewModel, data) = _form.dataSignal;
    RAC(_viewModel, valid) = _form.validation;

    self.view = [_form buildView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Survey";

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    doneButton.rac_command = self.viewModel.doneCommand;
    self.navigationItem.rightBarButtonItem = doneButton;

    @weakify(self);
    [self.viewModel.doneCommand subscribeNext:^(id sender) {
        @strongify(self);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done!" message:self.viewModel.message delegate:nil cancelButtonTitle:@"Yep!" otherButtonTitles:nil];
        [alert show];
    }];
}

@end
