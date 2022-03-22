import '../../models/usermodels/user.dart';

abstract class BaseUserRepository {
  //functions to override
  Stream<List<User>> users();
  Future<void> updateUser(User user);
  Future<void> addToCreatedLedger(
      {required String currentUserId, required String ledgerId});
  Future<void> addToAssignedLedger(
      {required String assignedToUserId, required String ledgerId});
}
