import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:seeds/v2/screens/transfer/receive/receive_enter_data/interactor/usecases/receive_seeds_invoice_use_case.dart';
import 'package:seeds/v2/screens/transfer/receive/receive_enter_data/interactor/viewmodels/receive_enter_data_events.dart';
import 'package:seeds/v2/screens/transfer/receive/receive_enter_data/interactor/viewmodels/receive_enter_data_state.dart';
import 'package:seeds/v2/utils/double_extension.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';

import 'mappers/create_invoice_result_mapper.dart';
import 'mappers/user_balance_state_mapper.dart';

/// --- BLOC
class ReceiveEnterDataBloc extends Bloc<ReceiveEnterDataEvents, ReceiveEnterDataState> {
  ReceiveEnterDataBloc(RatesState rates) : super(ReceiveEnterDataState.initial(rates));

  @override
  Stream<ReceiveEnterDataState> mapEventToState(ReceiveEnterDataEvents event) async* {
    if (event is LoadUserBalance) {
      yield state.copyWith(pageState: PageState.loading);
      Result result = await GetAvailableBalanceUseCase().run();
      yield UserBalanceStateMapper().mapResultToState(state, result);
    } else if (event is OnAmountChange) {
      double parsedQuantity = double.tryParse(event.amountChanged) ?? 0;

      String seedsToFiat =
          state.ratesState.fromSeedsToFiat(parsedQuantity, settingsStorage.selectedFiatCurrency).fiatFormatted;

      if (parsedQuantity > 0) {
        yield state.copyWith(isNextButtonEnabled: true, quantity: parsedQuantity, fiatAmount: seedsToFiat);
      } else {
        yield state.copyWith(isNextButtonEnabled: false, quantity: parsedQuantity, fiatAmount: seedsToFiat);
      }
    } else if (event is OnDescriptionChange) {
      yield state.copyWith(description: event.description);
    } else if (event is OnNextButtonTapped) {
      yield state.copyWith(pageState: PageState.loading);
      Result result = await ReceiveSeedsInvoiceUseCase().run(amount: state.quantity, memo: state.description);
      yield CreateInvoiceResultMapper().mapResultToState(state, result);
    } else if (event is ClearReceiveEnterDataState) {
      yield state.copyWith(
          fiatAmount: 0.toString(),
          isNextButtonEnabled: false,
          quantity: 0,
          seedsAmount: 0.toString(),
          isAutoFocus: false);
    }
  }
}
