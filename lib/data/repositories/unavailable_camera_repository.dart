import '../../domain/models/camera_snapshot.dart';
import '../../domain/repositories/camera_repository.dart';

class UnavailableCameraRepository implements CameraRepository {
  @override
  bool get isAvailable => false;

  @override
  Future<CameraSnapshot?> getLatestSnapshot() async => null;

  @override
  Future<List<CameraSnapshot>> getSnapshots({int limit = 20}) async => [];
}
