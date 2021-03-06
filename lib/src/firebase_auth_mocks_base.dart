import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'mock_user_credential.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  final stateChangedStreamController = StreamController<User>();
  User _currentUser;

  MockFirebaseAuth({signedIn = false}) {
    if (signedIn) {
      signInWithCredential(null);
    }
  }

  @override
  User get currentUser {
    return _currentUser;
  }

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    return _fakeSignIn();
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) {
    return _fakeSignIn();
  }

  @override
  Future<UserCredential> signInWithCustomToken(String token) async {
    return _fakeSignIn();
  }

  @override
  Future<UserCredential> signInAnonymously() {
    return _fakeSignIn(isAnonymous: true);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    stateChangedStreamController.add(null);
  }

  Future<UserCredential> _fakeSignIn({ bool isAnonymous = false }) {
    final userCredential = MockUserCredential(isAnonymous: isAnonymous);
    _currentUser = userCredential.user;
    stateChangedStreamController.add(_currentUser);
    return Future.value(userCredential);
  }

  @override
  Stream<User> authStateChanges() =>
      stateChangedStreamController.stream;
}
