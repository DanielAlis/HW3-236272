import 'package:badges/badges.dart';
import 'package:hello_me/screens/login_screen.dart';
import 'package:hello_me/screens/suggestions_screen.dart';
import 'package:hello_me/widgets/snapping_widget.dart';
import 'package:provider/provider.dart';
import '../providers/user_notifier.dart';
import '../providers/suggestions_notifier.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import '../widgets/snackbar_widget.dart';



class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> with ChangeNotifier {
  int _counter = 0;
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  void _pushSaved() {
    setState(() {
      _counter = 0;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SuggestionsScreen()));
  }

  void _pushLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          Badge(
            showBadge: _counter > 0 ? true : false,
            position: BadgePosition.topEnd(top: 0, end: 3),
            animationDuration: const Duration(milliseconds: 300),
            animationType: BadgeAnimationType.scale,
            badgeContent: Text(
              _counter.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            child: IconButton(
                icon: const Icon(Icons.star),
                tooltip: 'Saved Suggestions',
                onPressed: _pushSaved,
                ),
          ),
          IconButton(
            icon: context.watch<UserNotifier>().status == Status.Authenticated
                ? const Icon(Icons.exit_to_app)
                : const Icon(Icons.login),
            onPressed: () {
              if (context.read<UserNotifier>().status == Status.Authenticated) {
                context.read<UserNotifier>().signOut();
                showSnackBar(context,'Successfully logged out');
              } else {
                _pushLogin();
              }
            },
            tooltip:
                context.watch<UserNotifier>().status == Status.Authenticated
                    ? 'logout'
                    : 'Login',
          ),
        ],
      ),
      body: Stack(
          children: <Widget>[
      ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return const Divider();

              final index = i ~/ 2;
              if (index >= _suggestions.length) {
                _suggestions.addAll(generateWordPairs().take(10));
              }
              final alreadySaved = context
                  .watch<SuggestionsNotifier>()
                  .saved
                  .contains(_suggestions[index]);
              return ListTile(
                title: Text(
                  _suggestions[index].asPascalCase,
                  style: _biggerFont,
                ),
                trailing: Icon(
                  alreadySaved ? Icons.star : Icons.star_border,
                  color: alreadySaved ? Colors.deepPurple : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                ),
                onTap: () {
                  if (alreadySaved) {
                    setState(() {
                      if(_counter>0)
                        {
                          _counter--;
                        }
                      context
                          .read<SuggestionsNotifier>()
                          .removeFavourites(_suggestions[index]);
                    });
                  } else {
                    setState(() {
                      _counter++;
                      context
                          .read<SuggestionsNotifier>()
                          .addFavourites(_suggestions[index]);
                    });
                  }
                },
              );
            },
      ),
    const SnappingWidget(),
    ],
      ),
    );
  }

}
