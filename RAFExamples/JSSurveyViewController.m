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
@property (strong, readonly) RAFTableForm<JSSurveyFormModel> *form;
@end

@implementation JSSurveyViewController 

- (void)loadView {
    [super loadView];

    _viewModel = [JSSurveyViewModel new];

    Class JSSurveyForm = [RAFTableForm model:@protocol(JSSurveyFormModel)];

    RAFTextInputRow *nameField = [[RAFTextInputRow new] validator:self.viewModel.nameValidator];
    nameField.textField.placeholder = @"George Smiley";

    RAFNumberInputRow *ageField = [[RAFNumberInputRow new] validator:self.viewModel.ageValidator];
    ageField.textField.placeholder = @"62";

    RAFButtonRow *buttonRow = [RAFButtonRow new];
    buttonRow.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];

    _form = [JSSurveyForm name:nameField age:ageField];

    RAFTableSection *section = [RAFTableSection uniqueIdentifier:nil rows:@[ _form.name, _form.age, buttonRow ] headerTitle:@"Enter your info:" footerTitle:nil];
    _form.sections = @[ section ];

    @weakify(self);
    [buttonRow.command.executionSignals subscribeNext:^(id _) {
        @strongify(self);
        self.form.editable = !self.form.editable;
    }];

    RAC(buttonRow, title) = [RACObserve(self, form.editable) map:^id(NSNumber *editable) {
        return editable.boolValue ? @"Turn Off Editing" : @"Turn On Editing";
    }];

    self.view = _form.tableView;

    Class Model = RAFReify(JSSurveyFormModel);
    [_form.channelTerminal sendNext:[Model name:@"JON" age:@34]];

    [self.form.totalDataSignal subscribeNext:^(id x) {
        NSLog(@"x: %@", x);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Survey";

    @weakify(self);
    RACCommand *doneCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    doneButton.rac_command = doneCommand;

    [[[self.form.validationSignal sample:doneCommand.executionSignals] flattenMap:^RACStream *(RAFValidation *validation) {
        @strongify(self);
        return [self.viewModel.doneCommand execute:validation];
    }].publish connect];
    

    self.navigationItem.rightBarButtonItem = doneButton;

    [self.viewModel.doneCommand.executionSignals.flatten subscribeNext:^(NSString *message) {
        [[[UIAlertView alloc] initWithTitle:@"Done!" message:message delegate:nil cancelButtonTitle:@"Yep!" otherButtonTitles:nil] show];
    }];
}

@end
