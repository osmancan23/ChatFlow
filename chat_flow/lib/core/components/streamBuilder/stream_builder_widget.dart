import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:flutter/material.dart';

class StreamBuilderWidget<T extends dynamic> extends StatelessWidget {
  const StreamBuilderWidget({
    required this.stream,
    required this.builder,
    super.key,
  });

  final Stream<T> stream;

  final Widget? Function(BuildContext context, T? data) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return CustomText('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return builder.call(context, snapshot.data) ?? const SizedBox();
        } else {
          return const CustomText('Bir hata oluştu');
        }
      },
    );
  }
}
