import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get appTitle;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get monthlyBudget;

  /// No description provided for @upcomingBills.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Bills'**
  String get upcomingBills;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noBillsDue.
  ///
  /// In en, this message translates to:
  /// **'No bills due'**
  String get noBillsDue;

  /// No description provided for @overdueCount.
  ///
  /// In en, this message translates to:
  /// **'{count} overdue'**
  String overdueCount(int count);

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @sectionMoney.
  ///
  /// In en, this message translates to:
  /// **'MONEY'**
  String get sectionMoney;

  /// No description provided for @sectionApp.
  ///
  /// In en, this message translates to:
  /// **'APP'**
  String get sectionApp;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @initialBalance.
  ///
  /// In en, this message translates to:
  /// **'Initial balance'**
  String get initialBalance;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export data (CSV)'**
  String get exportCsv;

  /// No description provided for @resetData.
  ///
  /// In en, this message translates to:
  /// **'Reset data'**
  String get resetData;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all data?'**
  String get resetDialogTitle;

  /// No description provided for @resetDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes all transactions and bills and restores the default settings.'**
  String get resetDialogBody;

  /// No description provided for @allDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get allDataCleared;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @csvCopied.
  ///
  /// In en, this message translates to:
  /// **'CSV copied to clipboard ({count} transactions)'**
  String csvCopied(int count);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTransaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get navTransaction;

  /// No description provided for @navAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String greeting(String name);

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get monthlyIncome;

  /// No description provided for @monthlyExpense.
  ///
  /// In en, this message translates to:
  /// **'Monthly Expense'**
  String get monthlyExpense;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @noBillsDueMonth.
  ///
  /// In en, this message translates to:
  /// **'No bills due this month'**
  String get noBillsDueMonth;

  /// No description provided for @accountMain.
  ///
  /// In en, this message translates to:
  /// **'Main Account'**
  String get accountMain;

  /// No description provided for @accountGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest Account'**
  String get accountGuest;

  /// No description provided for @accountUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown account'**
  String get accountUnknown;

  /// No description provided for @bills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get bills;

  /// No description provided for @noBillsYet.
  ///
  /// In en, this message translates to:
  /// **'No bills yet'**
  String get noBillsYet;

  /// No description provided for @billOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get billOverdue;

  /// No description provided for @billThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get billThisWeek;

  /// No description provided for @billLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get billLater;

  /// No description provided for @billPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get billPaid;

  /// No description provided for @billUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get billUpcoming;

  /// No description provided for @dueThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Due this month'**
  String get dueThisMonth;

  /// No description provided for @billDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String billDueOn(String date);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day left} other{{count} days left}}'**
  String daysLeft(int count);

  /// No description provided for @daysLate.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day late} other{{count} days late}}'**
  String daysLate(int count);

  /// No description provided for @editBill.
  ///
  /// In en, this message translates to:
  /// **'Edit bill'**
  String get editBill;

  /// No description provided for @newBill.
  ///
  /// In en, this message translates to:
  /// **'New bill'**
  String get newBill;

  /// No description provided for @billName.
  ///
  /// In en, this message translates to:
  /// **'Bill name'**
  String get billName;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @billType.
  ///
  /// In en, this message translates to:
  /// **'Bill type'**
  String get billType;

  /// No description provided for @repeatsMonthly.
  ///
  /// In en, this message translates to:
  /// **'Repeats monthly'**
  String get repeatsMonthly;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @addBill.
  ///
  /// In en, this message translates to:
  /// **'Add Bill'**
  String get addBill;

  /// No description provided for @billUpdated.
  ///
  /// In en, this message translates to:
  /// **'Bill updated'**
  String get billUpdated;

  /// No description provided for @billAdded.
  ///
  /// In en, this message translates to:
  /// **'Bill added'**
  String get billAdded;

  /// No description provided for @billDeleted.
  ///
  /// In en, this message translates to:
  /// **'Bill deleted'**
  String get billDeleted;

  /// No description provided for @billMarkedPaid.
  ///
  /// In en, this message translates to:
  /// **'{name} marked as paid'**
  String billMarkedPaid(String name);

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @repeats.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get repeats;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @once.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get once;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @markAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get markAsPaid;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @typeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get typeIncome;

  /// No description provided for @typeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get typeExpense;

  /// No description provided for @typeTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get typeTransfer;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @noTransactionsHint.
  ///
  /// In en, this message translates to:
  /// **'Add your first transaction to see it here.'**
  String get noTransactionsHint;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @totalSpend.
  ///
  /// In en, this message translates to:
  /// **'Total Spend'**
  String get totalSpend;

  /// No description provided for @budgetAlert.
  ///
  /// In en, this message translates to:
  /// **'Budget Alert'**
  String get budgetAlert;

  /// No description provided for @budgetAlertBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve spent {percent}% of your monthly budget'**
  String budgetAlertBody(int percent);

  /// No description provided for @chooseDifferentAccounts.
  ///
  /// In en, this message translates to:
  /// **'Choose two different accounts'**
  String get chooseDifferentAccounts;

  /// No description provided for @insufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get insufficientBalance;

  /// No description provided for @fromAccount.
  ///
  /// In en, this message translates to:
  /// **'From account'**
  String get fromAccount;

  /// No description provided for @toAccount.
  ///
  /// In en, this message translates to:
  /// **'To account'**
  String get toAccount;

  /// No description provided for @transactionAdded.
  ///
  /// In en, this message translates to:
  /// **'Transaction added'**
  String get transactionAdded;

  /// No description provided for @transactionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Transaction updated'**
  String get transactionUpdated;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search title or category'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Search by title or category'**
  String get searchEmpty;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// No description provided for @periodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get periodYear;

  /// No description provided for @incomeVsExpense.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expense'**
  String get incomeVsExpense;

  /// No description provided for @noSpendingPeriod.
  ///
  /// In en, this message translates to:
  /// **'No spending in this period'**
  String get noSpendingPeriod;

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top categories'**
  String get topCategories;

  /// No description provided for @insightNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to compare yet.'**
  String get insightNotEnough;

  /// No description provided for @insight.
  ///
  /// In en, this message translates to:
  /// **'You spent {pct}% {direction, select, less{less} other{more}} on {category} than {period, select, week{last week} month{last month} other{last year}}.'**
  String insight(int pct, String direction, String category, String period);

  /// No description provided for @catShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get catShopping;

  /// No description provided for @catFoodDrink.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get catFoodDrink;

  /// No description provided for @catSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get catSubscription;

  /// No description provided for @catEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get catEducation;

  /// No description provided for @catBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get catBills;

  /// No description provided for @catOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get catOthers;

  /// No description provided for @catSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get catSalary;

  /// No description provided for @catTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get catTransfer;

  /// No description provided for @bcInternet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get bcInternet;

  /// No description provided for @bcElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get bcElectricity;

  /// No description provided for @bcWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get bcWater;

  /// No description provided for @bcGas.
  ///
  /// In en, this message translates to:
  /// **'Gas'**
  String get bcGas;

  /// No description provided for @bcMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get bcMobile;

  /// No description provided for @bcRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get bcRent;

  /// No description provided for @bcInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get bcInsurance;

  /// No description provided for @bcTv.
  ///
  /// In en, this message translates to:
  /// **'TV'**
  String get bcTv;

  /// No description provided for @bcOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get bcOther;

  /// No description provided for @transferTo.
  ///
  /// In en, this message translates to:
  /// **'Transfer to {name}'**
  String transferTo(String name);

  /// No description provided for @transferFromTo.
  ///
  /// In en, this message translates to:
  /// **'From {source} to {target}'**
  String transferFromTo(String source, String target);

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @editTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransactionTitle;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches for \"{query}\"'**
  String noMatches(String query);

  /// No description provided for @noBillsDueMonthHint.
  ///
  /// In en, this message translates to:
  /// **'Nothing left to pay this month. Tap View All to see bills due in later months.'**
  String get noBillsDueMonthHint;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @amountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero'**
  String get amountMustBePositive;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
