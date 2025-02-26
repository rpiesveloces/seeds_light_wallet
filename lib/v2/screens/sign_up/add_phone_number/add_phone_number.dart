import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/phone_number.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';
import 'package:seeds/v2/utils/formatters.dart';

class AddPhoneNumber extends StatefulWidget {
  const AddPhoneNumber({Key? key}) : super(key: key);

  @override
  _AddPhoneNumberState createState() => _AddPhoneNumberState();
}

class _AddPhoneNumberState extends State<AddPhoneNumber> {
  late SignupBloc _bloc;
  final TextEditingController _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SignupBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _navigateBack,
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormFieldCustom(
                    labelText: "Add Phone Number (optional)".i18n,
                    keyboardType: TextInputType.phone,
                    controller: _keyController,
                    inputFormatters: [
                      phoneNumberInternationalFormatter,
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Text(
                      "Note: Your phone number is encrypted and never shared with anyone.",
                      style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
                    ),
                  ),
                  FlatButtonLong(
                    title: 'Create account'.i18n,
                    onPressed: _onCreateAccountPressed(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  VoidCallback? _onCreateAccountPressed() {
    return () {
      // TODO(Farzad): implement the create account logic
    };
  }

  Future<bool> _navigateBack() {
    _bloc.add(OnBackPressed());
    return Future.value(false);
  }
}
