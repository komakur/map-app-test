import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore;
  late final CollectionReference _usersRef;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance {
    _usersRef = _firebaseFirestore.collection('users').withConverter<User>(
        fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson());
  }

  Future<void> addUserToFirestore(User user) async {
    await _usersRef.doc(user.uuid).set(user);
  }

  Stream<List<User>> getUsersStream() {
    return _firebaseFirestore.collection('users').snapshots().map(
        (event) => event.docs.map((e) => User.fromJson(e.data())).toList());
  }
}
