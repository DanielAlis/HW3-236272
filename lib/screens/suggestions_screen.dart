import 'package:provider/provider.dart';
import '../providers/suggestions_notifier.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final tiles = context.watch<SuggestionsNotifier>().saved.map(
      (pair) {
        return Dismissible(
          background: Container(
            color: Colors.deepPurple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                SizedBox(width: 7),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                SizedBox(width: 12),
                Text('Delete Suggestion',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          secondaryBackground: Container(
            color: Colors.deepPurple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const <Widget>[
                Text('Delete Suggestion',
                    style: TextStyle(color: Colors.white)),
                SizedBox(width: 12),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                SizedBox(width: 7),
              ],
            ),
          ),
          key: ValueKey<WordPair>(pair),
          confirmDismiss: (DismissDirection direction) async {
            _showAlertDialog(context, pair);
            return false;
          },
          child: ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          ),
        );
      },
    );
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
        : <Widget>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Suggestions'),
      ),
      body: ListView(children: divided),
    );
  }

  _showAlertDialog(BuildContext context, WordPair val) {
    Widget yesButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
      ),
      child: const Text("Yes"),
      onPressed: () {
        setState(() {
          context.read<SuggestionsNotifier>().removeFavourites(val);
        });
        Navigator.pop(context);
      },
    );
    Widget noButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
      ),
      child: const Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Delete Suggestion"),
      content: Text(
          "Are you sure you want to delete ${val.asPascalCase} from your saved suggestions?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
