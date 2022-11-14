import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/widgets/snackbar_widget.dart';
import 'package:provider/provider.dart';
import '../providers/user_notifier.dart';


class BottomSheetWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const BottomSheetWidget( {Key? key, required this.emailController, required this.passwordController } );

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  bool _validPassword = true;
  TextEditingController validatePasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return   Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text("Please confirm your password below:",),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: validatePasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorText: _validPassword
                              ? null
                              : 'Passwords must match',
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: context
                            .watch<UserNotifier>()
                            .status ==
                            Status.Authenticating
                            ? null
                            : () async {
                          if (validatePasswordController.text !=
                              widget.passwordController.text) {
                            setState(() {
                              _validPassword = false;
                            });
                          }
                          else {
                            setState(() {
                              _validPassword = true;
                            });
                            UserCredential? result = await context
                                .read<UserNotifier>()
                                .signUp(
                                widget.emailController.text,
                                widget.passwordController.text);
                            if (result != null) {
                              Navigator.pop(context);
                              Navigator.pop(context);

                            } else {
                              showSnackBar(context, 'There was an error logging into the app');
                            }
                          }
                        },
                        child: const Text('confirm'),
                      ),
                    ),
                  ],
                ),
              ),

    );
  }

}
