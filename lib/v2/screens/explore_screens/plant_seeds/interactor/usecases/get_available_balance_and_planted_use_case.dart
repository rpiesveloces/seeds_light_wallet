import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/api/planted_repository.dart';

export 'package:async/src/result/result.dart';

class GetAvailableBalanceAndPlantedDataUseCase {
  final BalanceRepository _balanceRepository = BalanceRepository();
  final PlantedRepository _plantedRepository = PlantedRepository();

  Future<List<Result>> run() {
    var account = settingsStorage.accountName;
    var futures = [
      _balanceRepository.getBalance(account),
      _plantedRepository.getPlanted(account),
    ];
    return Future.wait(futures);
  }
}
