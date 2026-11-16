import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/core/responsive/responsive_two_pane.dart';
import 'package:wallet_app/core/theme/app_colors.dart';
import 'package:wallet_app/core/theme/app_palette.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/l10n_labels.dart';
import 'package:wallet_app/core/widgets/error_retry.dart';
import 'package:wallet_app/core/widgets/segmented_tabs.dart';
import 'package:wallet_app/features/analytics/domain/analytics_usecases.dart';
import 'package:wallet_app/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:wallet_app/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:wallet_app/features/analytics/presentation/widgets/category_pie_card.dart';
import 'package:wallet_app/features/analytics/presentation/widgets/period_bars_card.dart';
import 'package:wallet_app/features/analytics/presentation/widgets/period_selector.dart';
import 'package:wallet_app/features/analytics/presentation/widgets/top_categories_card.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnalyticsCubit>();

    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              context.l10n.analytics,
              style: AppTextStyles.title.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsetsDirectional.only(end: AppSpacing.xl),
                child: PeriodSelector(
                  isSmall: true,
                  label: state.label,
                  onPrevious: () => cubit.shift(-1),
                  onNext: state.canGoNext ? () => cubit.shift(1) : null,
                ),
              ),
            ],
          ),
          body: SafeArea(
            bottom: false,
            child: _buildBody(context, state, cubit),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AnalyticsState state,
    AnalyticsCubit cubit,
  ) {
    final l10n = context.l10n;
    if (state.status == AnalyticsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == AnalyticsStatus.error) {
      return ErrorRetry(message: state.error, onRetry: cubit.retry);
    }

    final data = state.data;
    return ListView(
      padding: AppSpacing.screenHorizontal.copyWith(bottom: AppSpacing.xxl),
      children: [
        SizedBox(height: AppSpacing.md),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SegmentedTabs(
              labels: [l10n.periodWeek, l10n.periodMonth, l10n.periodYear],
              selectedIndex: state.period.index,
              onChanged: (i) => cubit.setPeriod(AnalyticsPeriod.values[i]),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        ResponsiveTwoPane(
          primaryFlex: 1,
          secondaryFlex: 1,
          primary: PeriodBarsCard(buckets: data.buckets),
          secondary: CategoryPieCard(
            slices: data.slices,
            totalCents: data.expenseCents,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        ResponsiveTwoPane(
          primaryFlex: 1,
          secondaryFlex: 1,
          primary: _InsightCard(insight: data.insight),
          secondary: data.slices.isNotEmpty
              ? TopCategoriesCard(slices: data.slices)
              : null,
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final CategoryInsight? insight;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final i = insight;
    final text = i == null
        ? l10n.insightNotEnough
        : l10n.insight(
            i.changePct.abs(),
            i.changePct < 0 ? 'less' : 'more',
            i.category.localized(l10n),
            i.period.name,
          );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text.rich(
              _buildSpans(text, i?.changePct.abs()),
              style: AppTextStyles.caption.copyWith(
                color: context.palette.textPrimary,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildSpans(String text, int? pct) {
    if (pct == null) return TextSpan(text: text);
    final token = '$pct%';
    final at = text.indexOf(token);
    if (at < 0) return TextSpan(text: text);
    return TextSpan(
      children: [
        TextSpan(text: text.substring(0, at)),
        TextSpan(
          text: token,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        TextSpan(text: text.substring(at + token.length)),
      ],
    );
  }
}