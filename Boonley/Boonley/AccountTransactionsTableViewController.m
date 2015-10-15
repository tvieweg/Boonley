//
//  AccountTransactionsTableViewController.m
//  
//
//  Created by Trevor Vieweg on 8/21/15.
//
//

#import "AccountTransactionsTableViewController.h"
#import "Datasource.h"
#import "RoundupTableViewCell.h"

@interface AccountTransactionsTableViewController ()

@end

@implementation AccountTransactionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [Datasource sharedInstance].currentMonthlySummary.transactions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoundupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"roundupCell" forIndexPath:indexPath];
    
    MonthlySummary *currentMonthlySummary = [Datasource sharedInstance].currentMonthlySummary;
    NSNumber *amount = (NSNumber *)currentMonthlySummary.transactions[indexPath.row][@"amount"];
    
    cell.roundupAmount.text = [NSString stringWithFormat:@"$%@", currentMonthlySummary.transactionRoundups[indexPath.row] ];
    
    cell.transactionLabel.text = [NSString stringWithFormat:@"$%@ %@", amount, currentMonthlySummary.transactions[indexPath.row][@"name"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *transactionDate = [dateFormatter dateFromString:currentMonthlySummary.transactions[indexPath.row][@"date"]];
    NSDateComponents *transactionDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:transactionDate];

    NSString *monthName = [[dateFormatter monthSymbols] objectAtIndex:(transactionDateComponents.month - 1)];

    cell.transactionDate.text = [NSString stringWithFormat:@"%@ %ld", monthName, transactionDateComponents.day];
    
    return cell;
}

@end
