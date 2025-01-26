import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/models/chat_model.dart';
import 'package:chat_flow/feature/home/viewmodel/home_view_model.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:chat_flow/utils/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
part '../widget/chat_list_tile_widget.dart';
part '../widget/home_appbar_widget.dart';
part '../widget/home_body_widget.dart';
part '../widget/home_fab_widget.dart';

/// Ana ekran
/// Kullanıcının mevcut sohbetlerini görüntülediği ve yönettiği ekran
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: _HomeAppBarWidget(viewModel: viewModel),
          body: _HomeBodyWidget(viewModel: viewModel),
          floatingActionButton: _HomeFABWidget(viewModel: viewModel),
        ),
      ),
    );
  }
}

/// Home ekranı için string sabitleri
class _HomeViewStrings {
  const _HomeViewStrings._();

  static const String title = 'Sohbetler';
  static const String noChats = 'Henüz sohbet yok';
}
