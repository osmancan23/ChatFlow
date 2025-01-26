import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/components/text_field/custom_text_field.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/models/message_model.dart';
import 'package:chat_flow/feature/chat/viewmodel/chat_view_model.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:chat_flow/utils/extension/num_extensions.dart';
import 'package:chat_flow/utils/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
part '../widget/chat_appbar_widget.dart';
part '../widget/message_bubble_widget.dart';
part '../widget/message_input_widget.dart';
part '../widget/message_list_widget.dart';

/// Chat ekranı
/// Kullanıcıların mesajlaşmasını sağlayan ekran
class ChatView extends StatelessWidget {
  const ChatView({
    required this.chatId,
    super.key,
  });

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = ChatViewModel();
        viewModel.initChat(chatId);
        return viewModel;
      },
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: _ChatAppbarWidget(chatViewModel: viewModel),
          body: Column(
            children: [
              Expanded(
                child: _MessageListWidget(viewModel: viewModel),
              ),
              _MessageInputWidget(viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chat ekranı için string sabitleri
class _ChatViewStrings {
  const _ChatViewStrings._();

  static const String typingText = 'Yazıyor...';
  static const String onlineText = 'Çevrimiçi';
  static const String messageHint = 'Mesajınızı yazın...';
  static const String readText = 'Görüldü';
  static const String sentText = 'Gönderildi';
}
