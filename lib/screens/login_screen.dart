import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import '../providers/user_notifier.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_sheet_widget.dart';
import '../widgets/snackbar_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: <Widget>[
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            child: AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [TyperAnimatedText('Welcome to Startup Names Generator, please log in!',speed: const Duration(milliseconds: 65))],
              ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(350, 35),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: context
                  .watch<UserNotifier>()
                  .status ==
                  Status.Authenticating
                  ? null
                  : () async {
                bool result = await context.read<UserNotifier>().signIn(
                    emailController.text, passwordController.text);
                if (result == true) {
                  Navigator.pop(context);
                } else {
                  showSnackBar(context,
                      'There was an error logging into the app');
                }
              },
              child: const Text('Log in'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(350, 35),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: context
                  .watch<UserNotifier>()
                  .status ==
                  Status.Authenticating
                  ? null
                  : () async {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: ( BuildContext context ) {
                      return BottomSheetWidget(passwordController: passwordController, emailController: emailController);
                    }
                );
              },
              child: const Text('New user? Click to sign up'),
            ),
          ),
        ],
      ),
    );
  }

}
