import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nikita_flutter_interview/data/models/task.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'tasks';

  Future<void> addOrUpdateTask(Task task) async {
    await _firestore.collection(_collection).doc(task.id).set(task.toMap());

    print("addOrUpdateTask Add Success task: ${task.toMap()}");
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  Future<Task?> getTask(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      print("getTask task: ${doc.data()!}");
      return Task.fromMap(doc.data()!);
    }
    return null;
  }

  Future<List<Task>> getAllTasks() async {
    final snapshot = await _firestore.collection(_collection).get();
    print("syncTasks snapshot: ${snapshot.docs.map((doc) => doc.data()).toList()}");
    return snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
  }
}
