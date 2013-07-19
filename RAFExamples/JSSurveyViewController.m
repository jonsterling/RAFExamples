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
#import <ReactiveFormlets/RAFButtonRow.h>
#import <ReactiveFormlets/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JSSurveyViewModel.h"

@interface JSSurveyViewController ()
@property (strong, readonly) JSSurveyViewModel *viewModel;
@property (strong, readonly) RAFOneSectionTableForm<JSSurveyFormModel> *form;
@end

@implementation JSSurveyViewController

- (void)loadView {
    [super loadView];

    _viewModel = [JSSurveyViewModel new];

    Class JSSurveyFormSection = [RAFTableSection model:@protocol(JSSurveyFormModel)];

    RAFTextInputRow *nameField = [[RAFTextInputRow new] validator:self.viewModel.nameValidator];
    nameField.configureTextField = ^(UITextField *textField) {
        textField.placeholder = @"George Smiley";
    };

    RAFNumberInputRow *ageField = [[RAFNumberInputRow new] validator:self.viewModel.ageValidator];
    ageField.configureTextField = ^(UITextField *textField) {
        textField.placeholder = @"62";
    };

    RAFButtonRow *buttonRow = [RAFButtonRow new];
    buttonRow.command = [RACCommand command];

    RAFTableSection<JSSurveyFormModel> *section = [[JSSurveyFormSection name:nameField age:ageField] modifySection:^(id<RAFMutableTableSection, JSSurveyFormModel> section) {
        section.rows = @[ section.name, section.age, buttonRow ];
        section.headerTitle = @"Enter your info:";
    }];


    @weakify(self);
    [buttonRow.command subscribeNext:^(id _) {
        @strongify(self);
        self.form.editable = !self.form.editable;
    }];

    _form = [RAFOneSectionTableForm section:section];

    RAC(self.viewModel.validationState) = _form.validationSignal;
    RAC(buttonRow, title) = [RACAbleWithStart(self.form.editable) map:^id(NSNumber *editable) {
        return editable.boolValue ? @"Turn Off Editing" : @"Turn On Editing";
    }];

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

    _form.tableView.tableFooterView = label;
    self.view = _form.tableView;
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
        [[[UIAlertView alloc] initWithTitle:@"Done!" message:self.viewModel.message delegate:nil cancelButtonTitle:@"Yep!" otherButtonTitles:nil] show];
    }];
}

@end
