import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/models/camera_snapshot.dart';

final cameraAvailabilityProvider = Provider<bool>((ref) {
  return ref.watch(cameraRepositoryProvider).isAvailable;
});

final latestSnapshotProvider = FutureProvider<CameraSnapshot?>((ref) {
  return ref.watch(cameraRepositoryProvider).getLatestSnapshot();
});
