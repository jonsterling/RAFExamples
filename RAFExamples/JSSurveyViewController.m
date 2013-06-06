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
@property (strong, readonly) JSSurveyViewModel *viewModel;
@property (strong, readonly) RAFSingleSectionTableForm<JSSurveyFormModel> *form;
@end

@implementation JSSurveyViewController

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

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 280.f, 140.f)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:76.0/255 green:86.0/255 blue:108.0/255 alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17.f];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.f, 1.f);

    RAC(label, text) = RACAbleWithStart(self.viewModel.message);

    UITableView *formTableView = [_form buildView];
    formTableView.tableFooterView = label;
    self.view = formTableView;
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
