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

  Future<User> getUserFromFirestoreByUid(String uuid) async {
    final docSnap = await _usersRef.doc(uuid).get();
    return User.fromJson(docSnap.data()! as Map<String, dynamic>);
  }

  Stream<List<User>> getAllUsers() {
    return _firebaseFirestore.collection('users').snapshots().map((snaphot) =>
        snaphot.docs.map((doc) => User.fromJson(doc.data())).toList());
  }
}
