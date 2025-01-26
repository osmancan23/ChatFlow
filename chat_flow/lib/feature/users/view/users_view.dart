import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';

import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/feature/users/viewmodel/users_view_model.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
part '../widget/users_appbar_widget.dart';
part '../widget/users_body_widget.dart';
part '../widget/user_list_tile_widget.dart';

/// Kullanıcılar ekranı
/// Tüm kullanıcıların listelendiği ve arama yapılabildiği ekran
class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsersViewModel(),
      child: Consumer<UsersViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: const _UsersAppBarWidget(),
          body: _UsersBodyWidget(viewModel: viewModel),
        ),
      ),
    );
  }
}

/// Users ekranı için string sabitleri
class _UsersViewStrings {
  const _UsersViewStrings._();

  static const String title = 'Kullanıcılar';
  static const String noUsers = 'Kullanıcı bulunamadı';
}
