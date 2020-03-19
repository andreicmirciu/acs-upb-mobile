import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword {
  ResetPassword._();

  static show({BuildContext context, String email}) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    // Set the given email as the starting text, if provided
    TextEditingController emailController =
        TextEditingController(text: email ?? "");

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(S.of(context).actionResetPassword),
              content: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Expanded(child: Container(height: 8)),
                    Text(S.of(context).messageResetPassword),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            key: ValueKey('reset_password_email_text_field'),
                            controller: emailController,
                            decoration: InputDecoration(
                                hintText: S.of(context).hintEmail),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(S.of(context).stringEmailDomain,
                            style: Theme.of(context)
                                .inputDecorationTheme
                                .suffixStyle),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  key: ValueKey('cancel_button'),
                  child: Text(
                    S.of(context).buttonCancel.toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                AppButton(
                  key: ValueKey('send_email_button'),
                  text: S.of(context).actionSendEmail.toUpperCase(),
                  width: 130,
                  onTap: () async {
                    bool success = await authProvider.sendPasswordResetEmail(
                        email: emailController.text +
                            S.of(context).stringEmailDomain,
                        context: context);
                    if (success) {
                      Navigator.pop(context);
                    }
                    return;
                  },
                ),
              ],
            ));
  }
}
