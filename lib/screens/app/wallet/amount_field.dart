import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/rate_notiffier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/utils/user_input_number_formatter.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

enum InputMode { fiat, seeds }

class AmountField extends StatefulWidget {
  const AmountField({Key key, this.onChanged}) : super(key: key);

  final Function onChanged;
  @override
  _AmountFieldState createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  final controller = TextEditingController(text: '');
  String inputString = "";
  double seedsValue = 0;
  double fiatValue = 0;
  InputMode inputMode = InputMode.seeds;

  @override
  Widget build(BuildContext context) {
    String balance;

    BalanceNotifier.of(context).balance == null
        ? balance = ''
        : balance = BalanceNotifier.of(context).balance.quantity;

    return Column(
      children: [
        Stack(alignment: Alignment.centerRight, children: [
          TextFormField(
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
            controller: controller,
            autofocus: true,
            inputFormatters: [
              UserInputNumberFormatter(),
            ],
            validator: (val) {
              String error;
              double availableBalance =
                  double.tryParse(balance.replaceFirst(' SEEDS', ''));
              double transferAmount = double.tryParse(val);

              if (transferAmount == 0.0) {
                error = "Transfer amount cannot be 0.".i18n;
              } else if (transferAmount == null || availableBalance == null) {
                error = "Transfer amount is not valid.".i18n;
              } else if (transferAmount > availableBalance) {
                error =
                    "Transfer amount cannot be greater than availabe balance."
                        .i18n;
              }
              return error;
            },
            onChanged: (value) {
              setState(() {
                this.inputString = value;
              });
              widget.onChanged(_getSeedsValue(value));
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Colors.amberAccent)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Colors.redAccent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: AppColors.borderGrey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: AppColors.borderGrey)),
              contentPadding: EdgeInsets.only(left: 15, right: 15),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: OutlineButton(
              onPressed: () {
                _toggleInput();
              },
              child: Text(
                inputMode == InputMode.seeds
                    ? 'SEEDS'
                    : SettingsNotifier.of(context).selectedFiatCurrency,
                style: TextStyle(color: AppColors.grey, fontSize: 16),
              ),
            ),
          )
        ]),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.fromLTRB(16, 5, 0, 0),
                child: Consumer<RateNotifier>(
                  builder: (context, rateNotifier, child) {
                    return Text(
                      inputString == null ? "" : _getOtherString(),
                      style: TextStyle(color: Colors.blue),
                    );
                  },
                ))),
      ],
    );
  }

  // shows the other currency below the input field - either fiat or Seeds.
  String _getOtherString() {
    double fieldValue = inputString != null ? double.tryParse(inputString) : 0;
    if (fieldValue == null) {
      return "";
    } else if (fieldValue == 0) {
      return "0";
    }
    return RateNotifier.of(context).amountToString(
        fieldValue, SettingsNotifier.of(context).selectedFiatCurrency,
        asSeeds: inputMode == InputMode.fiat);
  }

  double _getSeedsValue(String value) {
    double fieldValue = value != null ? double.tryParse(value) : 0;
    if (fieldValue == null || fieldValue == 0) {
      return 0;
    }
    if (inputMode == InputMode.seeds) {
      return fieldValue;
    } else {
      return RateNotifier.of(context).toSeeds(
          fieldValue, SettingsNotifier.of(context).selectedFiatCurrency);
    }
  }

  void _toggleInput() {
    setState(() {
      if (inputMode == InputMode.seeds) {
        inputMode = InputMode.fiat;
      } else {
        inputMode = InputMode.seeds;
      }
      widget.onChanged(_getSeedsValue(inputString));
    });
  }
}