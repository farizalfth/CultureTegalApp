import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();

  final UserRepository repository;
  UserService(this.repository);

  final user = Rxn<UserModel>();
  RealtimeChannel? _realtimeChannel;

  @override
  void onInit() {
    super.onInit();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    await _waitForAuth();
    await refreshUserData();
    if (user.value != null) {
      _subscribeToUserChanges(user.value!.id);
    }
  }

  Future<void> _waitForAuth() async {
    for (int i = 0; i < 15; i++) {
      if (Supabase.instance.client.auth.currentSession?.accessToken != null) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> refreshUserData() async {
    final data = await repository.getUserProfile();
    if (data != null) {
      user.value = data;
    }
  }

  void _subscribeToUserChanges(String userId) {
    _unsubscribeFromChanges();

    _realtimeChannel = Supabase.instance.client
        .channel('user_realtime_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: userId,
          ),
          callback: (payload) {
            refreshUserData();
          },
        );

    _realtimeChannel?.subscribe();
  }

  void _unsubscribeFromChanges() {
    if (_realtimeChannel != null) {
      Supabase.instance.client.removeChannel(_realtimeChannel!);
      _realtimeChannel = null;
    }
  }

  @override
  void onClose() {
    _unsubscribeFromChanges();
    super.onClose();
  }
}
