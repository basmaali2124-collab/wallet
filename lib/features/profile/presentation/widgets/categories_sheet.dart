import 'package:flutter/material.dart';
import 'package:wallet_app/core/models/transaction_category.dart';
import 'package:wallet_app/core/widgets/app_sheet.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';

Future<void> showCategoriesSheet(BuildContext context) =>
    showAppSheet<void>(
      context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          children: [
            Text(ctx.l10n.categories, style: AppTextStyles.title),
            SizedBox(height: AppSpacing.sm),
            for (final c in TransactionCategory.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: c.color.withValues(alpha: 0.15),
                  child: Icon(c.icon, color: c.color),
                ),
                title: Text(c.label),
              ),
          ],
        ),
      ),
    );