import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

export 'package:async/src/result/result.dart';

class UpdateProfileUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Result> run({required String? newName, required ProfileModel profile}) {
    return _profileRepository.updateProfile(
      accountName: settingsStorage.accountName,
      nickname: newName,
      image: profile.image,
      story: profile.story,
      roles: profile.roles,
      skills: profile.skills,
      interests: profile.interests,
    );
  }
}
