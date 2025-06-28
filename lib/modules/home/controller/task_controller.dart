import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nikita_flutter_interview/data/models/task.dart';
import 'package:nikita_flutter_interview/data/remote/firebase_service.dart';
import 'package:nikita_flutter_interview/core/utils/snackbar_utils.dart';
import '../../../data/local/db_helper.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isSyncing = false.obs;

  final FirebaseService _firebase = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    loadLocalTasks();
    _syncFromFirebaseOnFirstLaunch();
    _setupConnectivitySync();
  }

  void _syncFromFirebaseOnFirstLaunch() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      await syncTasks(showResultSnackbar: false);
    }
  }

  Future<void> loadLocalTasks() async {
    isLoading.value = true;
    tasks.value = await DBHelper.getTasks();
    isLoading.value = false;
  }

  Future<void> addOrEditTask(Task task) async {
    final updatedAt = DateTime.now();

    final hasInternet =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    final updatedTask = task.copyWith(
      updatedAt: updatedAt,
      isDirty: !hasInternet,
      isSynced: hasInternet,
    );

    await DBHelper.insertTask(updatedTask);

    if (hasInternet) {
      try {
        await _firebase.addOrUpdateTask(updatedTask);
      } catch (e) {
        final fallback = updatedTask.copyWith(isDirty: true, isSynced: false);
        await DBHelper.insertTask(fallback);
      }
    }

    await loadLocalTasks();
  }

  Future<void> deleteTask(String id) async {
    await _firebase.deleteTask(id);
    await DBHelper.deleteTask(id);
    await loadLocalTasks();
  }

  Future<void> syncTasks({bool showResultSnackbar = true}) async {
    try {
      final localTasks = await DBHelper.getTasks();
      final remoteTasks = await _firebase.getAllTasks();

      for (final local in localTasks) {
        final remote = remoteTasks.firstWhereOrNull((r) => r.id == local.id);

        if (remote != null) {
          if (remote.updatedAt.isAfter(local.updatedAt)) {
            await DBHelper.insertTask(remote);
          } else if (local.isDirty) {
            await _firebase.addOrUpdateTask(local);
            await DBHelper.insertTask(
              local.copyWith(isDirty: false, isSynced: true),
            );
          }
        } else {
          if (local.isDirty) {
            await _firebase.addOrUpdateTask(local);
            await DBHelper.insertTask(
              local.copyWith(isDirty: false, isSynced: true),
            );
          }
        }
      }

      for (final remote in remoteTasks) {
        final exists = localTasks.any((l) => l.id == remote.id);
        if (!exists) {
          await DBHelper.insertTask(remote);
        }
      }

      for (final local in localTasks) {
        final existsInRemote = remoteTasks.any((r) => r.id == local.id);
        if (!existsInRemote && !local.isDirty) {
          await DBHelper.deleteTask(local.id);
        }
      }

      await loadLocalTasks();

      if (showResultSnackbar) {
        SnackbarUtils.showSuccess('Synced', 'Tasks synced successfully');
      }
    } catch (e, st) {
      if (showResultSnackbar) {
        SnackbarUtils.showError('Sync Failed', 'Error: ${e.toString()}');
      }
      rethrow;
    }
  }

  Future<void> syncWithInternetCheck() async {
    final hasInternet =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    if (!hasInternet) {
      SnackbarUtils.showWarning(
        'No Internet',
        'Please check your internet connection and try again',
      );
      return;
    }

    SnackbarUtils.showSuccess('Syncing', 'Fetching data from Firebase...');

    isSyncing.value = true;
    try {
      await syncTasks(showResultSnackbar: false);
      SnackbarUtils.closeAll();
      SnackbarUtils.showSuccess('Synced', 'Tasks synced successfully');
    } catch (e) {
      SnackbarUtils.closeAll();
      SnackbarUtils.showError('Sync Failed', 'Error: ${e.toString()}');
    } finally {
      isSyncing.value = false;
    }
  }

  void _setupConnectivitySync() {
    Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        syncTasks();
      }
    });
  }
}
