import 'package:cloud_firestore/cloud_firestore.dart';

const String FIREBASE_DATABASE_USERS_TOKEN = 'users';
const String GUARDIAN_NOTIFICATION_KEY = 'guardianNotification';
const String PENDING_NOTIFICATIONS_KEY = 'pendingNotifications';
const String GUARDIANS_COLLECTION_KEY = 'guardians';
const String GUARDIANS_STATUS_KEY = 'status';
const String GUARDIANS_DATE_CREATED_KEY = 'dateCreated';
const String GUARDIANS_DATE_UPDATED_KEY = 'dateUpdated';
const String GUARDIAN_CONTRACT_INITIALIZED = 'guardianContractInitialized';
const String GUARDIAN_CONTRACT_INITIALIZED_DATE = 'guardianContractInitializedDate';
const String GUARDIAN_CONTRACT_INITIALIZED_UPDATE_DATE = 'guardianContractInitializedUpdateDate';
const String GUARDIAN_RECOVERY_STARTED_KEY = 'guardianRecoveryStarted';
const String UID_KEY = 'uid';
const String TYPE_KEY = 'type';
const String RECOVERY_COLLECTION_KEY = 'recovery';
const String RECOVERY_STARTED_DATE_KEY = 'recoveryStartedDate';
const String RECOVERY_APPROVED_DATE_KEY = 'recoveryApprovedDate';
const String FIREBASE_MESSAGE_TOKENS_KEY = 'firebaseMessageTokens';

abstract class FirebaseDatabaseService {
  CollectionReference get usersCollection => FirebaseFirestore.instance.collection(FIREBASE_DATABASE_USERS_TOKEN);
}
