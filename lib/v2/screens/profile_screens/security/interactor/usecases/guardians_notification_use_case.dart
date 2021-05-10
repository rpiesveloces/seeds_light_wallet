import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_guardians_repository.dart';

class GuardiansNotificationUseCase {
  Stream<bool> get hasGuardianNotificationPending {
    return FirebaseDatabaseGuardiansRepository().hasGuardianNotificationPending(settingsStorage.accountName);
  }
}
