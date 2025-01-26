part of '../view/home_view.dart';

/// Home Body widget'ı
class _HomeBodyWidget extends StatelessWidget {
  const _HomeBodyWidget({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.chats.isEmpty) {
      return Center(
        child: CustomText(
          _HomeViewStrings.noChats,
          textStyle: context.theme.textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.chats.length,
      padding: PaddingConstants.paddingAllSmall,
      itemBuilder: (context, index) {
        final chat = viewModel.chats[index];
        return _ChatListTileWidget(
          chat: chat,
          index: index,
        );
      },
    );
  }
} 