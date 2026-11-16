import 'package:flutter/material.dart';
import 'package:wallet_app/core/utils/l10n_ext.dart';
import 'package:wallet_app/core/utils/validators.dart';
import 'package:wallet_app/core/widgets/app_dialog.dart';

Future<({String name, String email})?> showEditProfileDialog(
  BuildContext context, {
  required String name,
  required String email,
}) => showDialog<({String name, String email})>(
  context: context,
  builder: (_) => _EditProfileDialog(name: name, email: email),
);

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({required this.name, required this.email});
  final String name;
  final String email;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController _name = TextEditingController(
    text: widget.name,
  );
  late final TextEditingController _email = TextEditingController(
    text: widget.email,
  );

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  bool get _valid =>
      Validators.name(context.l10n, _name.text) == null &&
      Validators.email(context.l10n, _email.text) == null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppDialog(
      title: l10n.editProfile,
      children: [
        TextField(
          controller: _name,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          inputFormatters: Validators.nameFormatters(),
          decoration: InputDecoration(
            labelText: l10n.nameLabel,
            errorText: Validators.name(l10n, _name.text),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          inputFormatters: Validators.emailFormatters(),
          decoration: InputDecoration(
            labelText: l10n.emailLabel,
            errorText: Validators.email(l10n, _email.text),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: _valid
              ? () => Navigator.of(context).pop((
                  name: _name.text.trim(),
                  email: _email.text.trim(),
                ))
              : null,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}