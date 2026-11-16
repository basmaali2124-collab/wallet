import 'package:wallet_app/core/models/account_model.dart';
import 'package:wallet_app/core/models/bill_category.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/models/transaction_model.dart';
import 'package:wallet_app/l10n/app_localizations.dart';

extension TransactionTypeL10n on TransactionType {
  String localized(AppLocalizations l) => switch (this) {
    TransactionType.income => l.typeIncome,
    TransactionType.expense => l.typeExpense,
    TransactionType.transfer => l.typeTransfer,
  };
}

extension TransactionCategoryL10n on TransactionCategory {
  String localized(AppLocalizations l) => switch (this) {
    TransactionCategory.shopping => l.catShopping,
    TransactionCategory.foodAndDrink => l.catFoodDrink,
    TransactionCategory.subscription => l.catSubscription,
    TransactionCategory.education => l.catEducation,
    TransactionCategory.bills => l.catBills,
    TransactionCategory.others => l.catOthers,
    TransactionCategory.salary => l.catSalary,
    TransactionCategory.transfer => l.catTransfer,
  };
}

extension BillCategoryL10n on BillCategory {
  String localized(AppLocalizations l) => switch (this) {
    BillCategory.internet => l.bcInternet,
    BillCategory.electricity => l.bcElectricity,
    BillCategory.water => l.bcWater,
    BillCategory.gas => l.bcGas,
    BillCategory.mobile => l.bcMobile,
    BillCategory.rent => l.bcRent,
    BillCategory.insurance => l.bcInsurance,
    BillCategory.tv => l.bcTv,
    BillCategory.other => l.bcOther,
  };
}

String accountName(AppLocalizations l, AccountModel a) => switch (a.id) {
  AccountIds.main => l.accountMain,
  AccountIds.guest => l.accountGuest,
  _ => a.name,
};