import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wallet_app/core/theme/app_spacing.dart';
import 'package:wallet_app/core/theme/app_text_styles.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/widgets/app_icon_button.dart';
import 'package:wallet_app/core/widgets/transaction_tile.dart';
import 'package:wallet_app/features/transactions/presentation/detail/transaction_detail_sheet.dart';
import 'package:wallet_app/features/transactions/presentation/search/search_cubit.dart';
import 'package:wallet_app/features/transactions/presentation/search/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  String get _typed => _controller.text.trim();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    context.read<SearchCubit>().onChanged(value);
    setState(() {});
  }

  void _useRecent(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    context.read<SearchCubit>().submit(value);
    setState(() {});
  }

  void _clear() {
    _controller.clear();
    context.read<SearchCubit>().onChanged('');
    setState(() {});
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: AppSpacing.md,
                end: AppSpacing.xl,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              child: Row(
                children: [
                  AppIconButton(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => context.pop(),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focus,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: _onChanged,
                      onSubmitted: cubit.submit,
                      decoration: InputDecoration(
                        hintText: l10n.searchHint,
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _typed.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: _clear,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  final typed = _typed;
                  if (typed.isEmpty) {
                    return _Recent(
                      recent: state.recent,
                      onTap: _useRecent,
                      onRemove: cubit.removeRecent,
                      onClear: cubit.clearRecent,
                    );
                  }
                  if (state.results.isEmpty) {
                    if (state.query != typed) return const SizedBox.shrink();
                    return Center(
                      child: Text(
                        l10n.noMatches(typed),
                        style: AppTextStyles.caption,
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                    itemCount: state.results.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final tx = state.results[i];
                      return TransactionTile(
                        transaction: tx,
                        showDate: true,
                        onTap: () {
                          cubit.saveRecent(typed);
                          TransactionDetailSheet.show(context, tx);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Recent extends StatelessWidget {
  const _Recent({
    required this.recent,
    required this.onTap,
    required this.onRemove,
    required this.onClear,
  });

  final List<String> recent;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (recent.isEmpty) {
      return Center(
        child: Text(l10n.searchEmpty, style: AppTextStyles.caption),
      );
    }
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.recentSearches, style: AppTextStyles.title),
            ),
            TextButton(onPressed: onClear, child: Text(l10n.clearAll)),
          ],
        ),
        for (final q in recent)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.history_rounded),
            title: Text(q, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => onRemove(q),
            ),
            onTap: () => onTap(q),
          ),
      ],
    );
  }
}