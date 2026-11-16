// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'المحفظة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get monthlyBudget => 'الميزانية الشهرية';

  @override
  String get upcomingBills => 'الفواتير القادمة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get noBillsDue => 'لا توجد فواتير مستحقة';

  @override
  String overdueCount(int count) {
    return '$count متأخرة';
  }

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get sectionMoney => 'المال';

  @override
  String get sectionApp => 'التطبيق';

  @override
  String get accounts => 'الحسابات';

  @override
  String get categories => 'الفئات';

  @override
  String get initialBalance => 'الرصيد الافتتاحي';

  @override
  String get currency => 'العملة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get exportCsv => 'تصدير البيانات (CSV)';

  @override
  String get resetData => 'إعادة ضبط البيانات';

  @override
  String get edit => 'تعديل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get resetDialogTitle => 'إعادة ضبط كل البيانات؟';

  @override
  String get resetDialogBody =>
      'سيتم حذف كل المعاملات والفواتير نهائيًا واستعادة الإعدادات الافتراضية.';

  @override
  String get allDataCleared => 'تم مسح كل البيانات';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get nameLabel => 'الاسم';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String csvCopied(int count) {
    return 'تم نسخ ملف CSV ($count معاملة)';
  }

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navTransaction => 'المعاملات';

  @override
  String get navAnalytics => 'التحليلات';

  @override
  String get navProfile => 'حسابي';

  @override
  String greeting(String name) {
    return 'أهلًا، $name!';
  }

  @override
  String get totalBalance => 'إجمالي الرصيد';

  @override
  String get monthlyIncome => 'دخل الشهر';

  @override
  String get monthlyExpense => 'مصروفات الشهر';

  @override
  String get spent => 'المصروف';

  @override
  String get noBillsDueMonth => 'لا توجد فواتير مستحقة هذا الشهر';

  @override
  String get accountMain => 'الحساب الرئيسي';

  @override
  String get accountGuest => 'حساب الضيف';

  @override
  String get accountUnknown => 'حساب غير معروف';

  @override
  String get bills => 'الفواتير';

  @override
  String get noBillsYet => 'لا توجد فواتير بعد';

  @override
  String get billOverdue => 'متأخرة';

  @override
  String get billThisWeek => 'هذا الأسبوع';

  @override
  String get billLater => 'لاحقًا';

  @override
  String get billPaid => 'مدفوعة';

  @override
  String get billUpcoming => 'قادمة';

  @override
  String get dueThisMonth => 'مستحق هذا الشهر';

  @override
  String billDueOn(String date) {
    return 'الاستحقاق $date';
  }

  @override
  String get dueToday => 'مستحقة اليوم';

  @override
  String daysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'باقي $count يوم',
      many: 'باقي $count يومًا',
      few: 'باقي $count أيام',
      two: 'باقي يومان',
      one: 'باقي يوم',
    );
    return '$_temp0';
  }

  @override
  String daysLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'متأخرة $count يوم',
      many: 'متأخرة $count يومًا',
      few: 'متأخرة $count أيام',
      two: 'متأخرة يومين',
      one: 'متأخرة يوم',
    );
    return '$_temp0';
  }

  @override
  String get editBill => 'تعديل الفاتورة';

  @override
  String get newBill => 'فاتورة جديدة';

  @override
  String get billName => 'اسم الفاتورة';

  @override
  String get amount => 'المبلغ';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get billType => 'نوع الفاتورة';

  @override
  String get repeatsMonthly => 'تتكرر شهريًا';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get addBill => 'إضافة فاتورة';

  @override
  String get billUpdated => 'تم تحديث الفاتورة';

  @override
  String get billAdded => 'تمت إضافة الفاتورة';

  @override
  String get billDeleted => 'تم حذف الفاتورة';

  @override
  String billMarkedPaid(String name) {
    return 'تم تسجيل $name كمدفوعة';
  }

  @override
  String get status => 'الحالة';

  @override
  String get category => 'الفئة';

  @override
  String get repeats => 'التكرار';

  @override
  String get monthly => 'شهريًا';

  @override
  String get once => 'مرة واحدة';

  @override
  String get note => 'ملاحظة';

  @override
  String get markAsPaid => 'تسجيل كمدفوعة';

  @override
  String get delete => 'حذف';

  @override
  String get undo => 'تراجع';

  @override
  String get typeIncome => 'دخل';

  @override
  String get typeExpense => 'مصروف';

  @override
  String get typeTransfer => 'تحويل';

  @override
  String get filterAll => 'الكل';

  @override
  String get noTransactionsYet => 'لا توجد معاملات بعد';

  @override
  String get noTransactionsHint => 'أضف أول معاملة لتظهر هنا.';

  @override
  String get addTransaction => 'إضافة معاملة';

  @override
  String get totalSpend => 'إجمالي المصروفات';

  @override
  String get budgetAlert => 'تنبيه الميزانية';

  @override
  String budgetAlertBody(int percent) {
    return 'لقد أنفقت $percent% من ميزانيتك الشهرية';
  }

  @override
  String get chooseDifferentAccounts => 'اختر حسابين مختلفين';

  @override
  String get insufficientBalance => 'الرصيد غير كافٍ';

  @override
  String get fromAccount => 'من حساب';

  @override
  String get toAccount => 'إلى حساب';

  @override
  String get transactionAdded => 'تمت إضافة المعاملة';

  @override
  String get transactionUpdated => 'تم تحديث المعاملة';

  @override
  String get transactionDeleted => 'تم حذف المعاملة';

  @override
  String get typeLabel => 'النوع';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get titleLabel => 'العنوان';

  @override
  String get searchHint => 'ابحث بالعنوان أو الفئة';

  @override
  String get searchEmpty => 'ابحث بالعنوان أو الفئة';

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get analytics => 'التحليلات';

  @override
  String get periodWeek => 'أسبوع';

  @override
  String get periodMonth => 'شهر';

  @override
  String get periodYear => 'سنة';

  @override
  String get incomeVsExpense => 'الدخل مقابل المصروف';

  @override
  String get noSpendingPeriod => 'لا توجد مصروفات في هذه الفترة';

  @override
  String get topCategories => 'أعلى الفئات';

  @override
  String get insightNotEnough => 'لا توجد بيانات كافية للمقارنة بعد.';

  @override
  String insight(int pct, String direction, String category, String period) {
    String _temp0 = intl.Intl.selectLogic(direction, {
      'less': 'أقل',
      'other': 'أكثر',
    });
    String _temp1 = intl.Intl.selectLogic(period, {
      'week': 'الأسبوع الماضي',
      'month': 'الشهر الماضي',
      'other': 'العام الماضي',
    });
    return 'أنفقت $pct% $_temp0 على $category مقارنةً بـ$_temp1.';
  }

  @override
  String get catShopping => 'التسوق';

  @override
  String get catFoodDrink => 'الطعام والشراب';

  @override
  String get catSubscription => 'الاشتراكات';

  @override
  String get catEducation => 'التعليم';

  @override
  String get catBills => 'الفواتير';

  @override
  String get catOthers => 'أخرى';

  @override
  String get catSalary => 'الراتب';

  @override
  String get catTransfer => 'تحويل';

  @override
  String get bcInternet => 'الإنترنت';

  @override
  String get bcElectricity => 'الكهرباء';

  @override
  String get bcWater => 'المياه';

  @override
  String get bcGas => 'الغاز';

  @override
  String get bcMobile => 'الموبايل';

  @override
  String get bcRent => 'الإيجار';

  @override
  String get bcInsurance => 'التأمين';

  @override
  String get bcTv => 'التلفزيون';

  @override
  String get bcOther => 'أخرى';

  @override
  String transferTo(String name) {
    return 'تحويل إلى $name';
  }

  @override
  String transferFromTo(String source, String target) {
    return 'من $source إلى $target';
  }

  @override
  String get noteOptional => 'ملاحظة (اختياري)';

  @override
  String get editTransactionTitle => 'تعديل المعاملة';

  @override
  String noMatches(String query) {
    return 'لا توجد نتائج لـ \"$query\"';
  }

  @override
  String get noBillsDueMonthHint =>
      'لا يوجد ما تدفعه هذا الشهر. اضغط على عرض الكل لمشاهدة الفواتير المستحقة في الأشهر القادمة.';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get nameTooShort => 'اكتب حرفين على الأقل';

  @override
  String get invalidEmail => 'اكتب بريدًا إلكترونيًا صحيحًا';

  @override
  String get amountMustBePositive => 'يجب أن يكون المبلغ أكبر من صفر';
}
