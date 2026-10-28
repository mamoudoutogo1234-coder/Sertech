import '../models/camera_snapshot.dart';

abstract class CameraRepository {
  Future<CameraSnapshot?> getLatestSnapshot();
  Future<List<CameraSnapshot>> getSnapshots({int limit = 20});
  bool get isAvailable;
}
