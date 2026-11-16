// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wallet';

  @override
  String get profile => 'Profile';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get upcomingBills => 'Upcoming Bills';

  @override
  String get viewAll => 'View All';

  @override
  String get noBillsDue => 'No bills due';

  @override
  String overdueCount(int count) {
    return '$count overdue';
  }

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get sectionMoney => 'MONEY';

  @override
  String get sectionApp => 'APP';

  @override
  String get accounts => 'Accounts';

  @override
  String get categories => 'Categories';

  @override
  String get initialBalance => 'Initial balance';

  @override
  String get currency => 'Currency';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get exportCsv => 'Export data (CSV)';

  @override
  String get resetData => 'Reset data';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get reset => 'Reset';

  @override
  String get resetDialogTitle => 'Reset all data?';

  @override
  String get resetDialogBody =>
      'This permanently deletes all transactions and bills and restores the default settings.';

  @override
  String get allDataCleared => 'All data cleared';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email';

  @override
  String csvCopied(int count) {
    return 'CSV copied to clipboard ($count transactions)';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navTransaction => 'Transaction';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String get navProfile => 'Profile';

  @override
  String greeting(String name) {
    return 'Hi, $name!';
  }

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get monthlyIncome => 'Monthly Income';

  @override
  String get monthlyExpense => 'Monthly Expense';

  @override
  String get spent => 'Spent';

  @override
  String get noBillsDueMonth => 'No bills due this month';

  @override
  String get accountMain => 'Main Account';

  @override
  String get accountGuest => 'Guest Account';

  @override
  String get accountUnknown => 'Unknown account';

  @override
  String get bills => 'Bills';

  @override
  String get noBillsYet => 'No bills yet';

  @override
  String get billOverdue => 'Overdue';

  @override
  String get billThisWeek => 'This week';

  @override
  String get billLater => 'Later';

  @override
  String get billPaid => 'Paid';

  @override
  String get billUpcoming => 'Upcoming';

  @override
  String get dueThisMonth => 'Due this month';

  @override
  String billDueOn(String date) {
    return 'Due $date';
  }

  @override
  String get dueToday => 'Due today';

  @override
  String daysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String daysLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days late',
      one: '1 day late',
    );
    return '$_temp0';
  }

  @override
  String get editBill => 'Edit bill';

  @override
  String get newBill => 'New bill';

  @override
  String get billName => 'Bill name';

  @override
  String get amount => 'Amount';

  @override
  String get dueDate => 'Due date';

  @override
  String get billType => 'Bill type';

  @override
  String get repeatsMonthly => 'Repeats monthly';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get addBill => 'Add Bill';

  @override
  String get billUpdated => 'Bill updated';

  @override
  String get billAdded => 'Bill added';

  @override
  String get billDeleted => 'Bill deleted';

  @override
  String billMarkedPaid(String name) {
    return '$name marked as paid';
  }

  @override
  String get status => 'Status';

  @override
  String get category => 'Category';

  @override
  String get repeats => 'Repeats';

  @override
  String get monthly => 'Monthly';

  @override
  String get once => 'Once';

  @override
  String get note => 'Note';

  @override
  String get markAsPaid => 'Mark as paid';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get typeIncome => 'Income';

  @override
  String get typeExpense => 'Expense';

  @override
  String get typeTransfer => 'Transfer';

  @override
  String get filterAll => 'All';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get noTransactionsHint => 'Add your first transaction to see it here.';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get totalSpend => 'Total Spend';

  @override
  String get budgetAlert => 'Budget Alert';

  @override
  String budgetAlertBody(int percent) {
    return 'You\'ve spent $percent% of your monthly budget';
  }

  @override
  String get chooseDifferentAccounts => 'Choose two different accounts';

  @override
  String get insufficientBalance => 'Insufficient balance';

  @override
  String get fromAccount => 'From account';

  @override
  String get toAccount => 'To account';

  @override
  String get transactionAdded => 'Transaction added';

  @override
  String get transactionUpdated => 'Transaction updated';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get typeLabel => 'Type';

  @override
  String get dateLabel => 'Date';

  @override
  String get titleLabel => 'Title';

  @override
  String get searchHint => 'Search title or category';

  @override
  String get searchEmpty => 'Search by title or category';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearAll => 'Clear all';

  @override
  String get analytics => 'Analytics';

  @override
  String get periodWeek => 'Week';

  @override
  String get periodMonth => 'Month';

  @override
  String get periodYear => 'Year';

  @override
  String get incomeVsExpense => 'Income vs Expense';

  @override
  String get noSpendingPeriod => 'No spending in this period';

  @override
  String get topCategories => 'Top categories';

  @override
  String get insightNotEnough => 'Not enough data to compare yet.';

  @override
  String insight(int pct, String direction, String category, String period) {
    String _temp0 = intl.Intl.selectLogic(direction, {
      'less': 'less',
      'other': 'more',
    });
    String _temp1 = intl.Intl.selectLogic(period, {
      'week': 'last week',
      'month': 'last month',
      'other': 'last year',
    });
    return 'You spent $pct% $_temp0 on $category than $_temp1.';
  }

  @override
  String get catShopping => 'Shopping';

  @override
  String get catFoodDrink => 'Food & Drink';

  @override
  String get catSubscription => 'Subscription';

  @override
  String get catEducation => 'Education';

  @override
  String get catBills => 'Bills';

  @override
  String get catOthers => 'Others';

  @override
  String get catSalary => 'Salary';

  @override
  String get catTransfer => 'Transfer';

  @override
  String get bcInternet => 'Internet';

  @override
  String get bcElectricity => 'Electricity';

  @override
  String get bcWater => 'Water';

  @override
  String get bcGas => 'Gas';

  @override
  String get bcMobile => 'Mobile';

  @override
  String get bcRent => 'Rent';

  @override
  String get bcInsurance => 'Insurance';

  @override
  String get bcTv => 'TV';

  @override
  String get bcOther => 'Other';

  @override
  String transferTo(String name) {
    return 'Transfer to $name';
  }

  @override
  String transferFromTo(String source, String target) {
    return 'From $source to $target';
  }

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get editTransactionTitle => 'Edit transaction';

  @override
  String noMatches(String query) {
    return 'No matches for \"$query\"';
  }

  @override
  String get noBillsDueMonthHint =>
      'Nothing left to pay this month. Tap View All to see bills due in later months.';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get nameTooShort => 'Enter at least 2 characters';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get amountMustBePositive => 'Amount must be greater than zero';
}
