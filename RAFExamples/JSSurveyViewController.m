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
#import <ReactiveFormlets/RAFValidator.h>
#import <ReactiveFormlets/RAFValidation.h>
#import <ReactiveFormlets/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JSSurveyViewModel.h"

@interface JSSurveyViewController ()
@property (readonly, strong) JSSurveyViewModel *viewModel;
@end

@implementation JSSurveyViewController {
    RAFSingleSectionTableForm<JSSurveyFormModel> *_form;
}

- (void)loadView {
    [super loadView];

    _viewModel = [JSSurveyViewModel new];

    Class JSSurveyForm = [RAFSingleSectionTableForm model:@protocol(JSSurveyFormModel)];

    id<RAFText> nameField = [[[RAFTextInputRow new] placeholder:@"George Smiley"] validator:self.viewModel.nameValidator];
    id<RAFNumber> ageField = [[[RAFNumberInputRow new] placeholder:@"62"] validator:self.viewModel.ageValidator];

    _form = [JSSurveyForm name:nameField age:ageField];
    RAC(self.viewModel.data) = _form.rawDataSignal;
    RAC(self.viewModel.validationState) = _form.validationSignal;

    _form.headerTitle = @"Enter your info:";
    RAC(_form, footerTitle) = RACAbleWithStart(self.viewModel.message);

    self.view = [_form buildView];
}

- (void)viewDidLoad {
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
