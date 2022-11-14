import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:hello_me/providers/user_notifier.dart';

class SuggestionsNotifier extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final counter = 0;
  Set<WordPair> _saved = <WordPair>{};
  UserNotifier? _user;

  SuggestionsNotifier();

  Set<WordPair> get saved => _saved;

  set saved(Set<WordPair> saved) {
    _saved = saved;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getFavourites(String? id) async {
    final DocumentSnapshot document =
        await _firestore.collection("users").doc(id).get();
    return (document.data() as Map<String, dynamic>);
  }

  Future<void> setFavourites(String? id) async {
    for (var favorite in _saved) {
      await _firestore
          .collection("users")
          .doc(id)
          .update({favorite.asPascalCase: "${favorite.first} ${favorite.second}"});
    }
  }

  void addFavourites(WordPair pair) {
    saved.add(pair);

    if (_user?.status == Status.Authenticated) {
      _firestore
          .collection("users")
          .doc(_user?.getID())
          .update({pair.asPascalCase: "${pair.first} ${pair.second}"});
    }
  }

  Future<void> setFavouritesScreen(String? id) async {
    final favourites = await getFavourites(id);
    for(var value in favourites.values){
      var splitted = value.toString().split(' ');
      _saved.add(WordPair(splitted[0],splitted[1]));
    }
  }

  void removeFavourites(WordPair toDelete) {
    saved.remove(toDelete);
    if (_user?.status == Status.Authenticated) {
      _firestore
          .collection('users')
          .doc(_user?.getID())
          .update({toDelete.asPascalCase: FieldValue.delete()});
    }
    notifyListeners();
  }

  Future<void> update(UserNotifier user) async {
    if (user.status == Status.Authenticated) {
      _user = user;
      await setFavourites(user.getID());
      await setFavouritesScreen(user.getID());
    }
  }
}
