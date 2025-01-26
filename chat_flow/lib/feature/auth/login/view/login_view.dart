import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:chat_flow/core/components/button/button.dart';
import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/components/text_field/custom_text_field.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/constants/enums/lottie_enums.dart';
import 'package:chat_flow/core/init/validator/app_validator.dart';
import 'package:chat_flow/feature/auth/login/viewmodel/login_view_model.dart';

import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:chat_flow/utils/extension/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

/// Login ekranı
/// Kullanıcının giriş yapmasını sağlayan ekran
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, _) => BlocListener<AuthBloc, AuthState>(
          listener: viewModel.onAuthStateChanged,
          child: Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(context, viewModel),
          ),
        ),
      ),
    );
  }

  /// AppBar widget'ı
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const CustomText(_LoginViewStrings.title),
    );
  }

  /// Body widget'ı
  Widget _buildBody(BuildContext context, LoginViewModel viewModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: PaddingConstants.paddingAllSmall,
        child: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLottieAnimation(),
              20.h.ph,
              _buildEmailField(viewModel),
              const SizedBox(height: PaddingConstants.small),
              _buildPasswordField(viewModel),
              30.h.ph,
              _buildLoginButton(context, viewModel),
              20.h.ph,
              _buildRegisterRow(context, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  /// Lottie animasyonu
  Widget _buildLottieAnimation() {
    return Lottie.asset(
      LottieEnums.login.path,
      width: 300.h,
    );
  }

  /// Email alanı
  Widget _buildEmailField(LoginViewModel viewModel) {
    return CustomTextField(
      controller: viewModel.emailController,
      labelText: _LoginViewStrings.emailLabel,
      hintText: _LoginViewStrings.emailHint,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
      validator: AppValidator.email,
    );
  }

  /// Şifre alanı
  Widget _buildPasswordField(LoginViewModel viewModel) {
    return CustomTextField(
      controller: viewModel.passwordController,
      labelText: _LoginViewStrings.passwordLabel,
      hintText: _LoginViewStrings.passwordHint,
      obscureText: true,
      prefixIcon: const Icon(Icons.lock_outline),
      validator: AppValidator.password,
    );
  }

  /// Giriş yap butonu
  Widget _buildLoginButton(BuildContext context, LoginViewModel viewModel) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ButtonWidget(
          onTap: state is AuthLoading ? () {} : () => viewModel.login(context),
          text: state is AuthLoading ? 'Giriş Yapılıyor...' : _LoginViewStrings.loginButtonText,
        );
      },
    );
  }

  /// Kayıt ol satırı
  Widget _buildRegisterRow(BuildContext context, LoginViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(_LoginViewStrings.noAccountText),
        TextButton(
          onPressed: () => viewModel.navigateToRegister(context),
          child: CustomText(
            _LoginViewStrings.registerButtonText,
            textStyle: context.theme.textTheme.bodySmall?.copyWith(
              color: context.theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// Login ekranı için string sabitleri
class _LoginViewStrings {
  const _LoginViewStrings._();

  // AppBar
  static const String title = 'Giriş Yap';

  // Form
  static const String emailLabel = 'E-posta';
  static const String emailHint = 'ornek@email.com';
  static const String passwordLabel = 'Şifre';
  static const String passwordHint = '••••••••';
  static const String loginButtonText = 'Giriş Yap';

  // Register Text
  static const String noAccountText = 'Hesabın yok mu?';
  static const String registerButtonText = 'Kayıt Ol';
}
