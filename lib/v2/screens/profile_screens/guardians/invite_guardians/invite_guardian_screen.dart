import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/guardians.i18n.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/search_result_row.dart';
import 'package:seeds/v2/components/snack_bar_info.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/interactor/invite_guardians_bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/interactor/viewmodel/invite_guardians_events.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/interactor/viewmodel/invite_guardians_state.dart';

class InviteGuardians extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myGuardians = ModalRoute.of(context)?.settings.arguments as Set<MemberModel>?;

    return BlocProvider(
        create: (_) => InviteGuardiansBloc(myGuardians ?? {}),
        child: BlocListener<InviteGuardiansBloc, InviteGuardiansState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            var pageCommand = state.pageCommand;

            BlocProvider.of<InviteGuardiansBloc>(context).add(InviteGuardianClearPageCommand());
            if (pageCommand is NavigateToRoute) {
              NavigationService.of(context).navigateTo(pageCommand.route);
            } else if (pageCommand is ShowErrorMessage) {
              SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
            }
          },
          child: BlocBuilder<InviteGuardiansBloc, InviteGuardiansState>(builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Invite Guardians"),
                ),
                body: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Image(image: AssetImage('assets/images/guardians/invite_guardian_mail.png')),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "The users below will be sent an invite to become your Guardian.".i18n,
                        style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        children: state.selectedGuardians
                            .map((e) => SearchResultRow(
                                  account: e.account,
                                  name: e.nickname ?? e.account,
                                  imageUrl: e.image,
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FlatButtonLong(
                        title: 'Send Invite',
                        onPressed: () {
                          BlocProvider.of<InviteGuardiansBloc>(context).add(OnSendInviteTapped());
                        },
                      ),
                    ),
                  ],
                ));
          }),
        ));
  }
}
