import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:chat_flow/core/components/button/button.dart';
import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/components/text_field/custom_text_field.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/constants/enums/lottie_enums.dart';
import 'package:chat_flow/core/init/validator/app_validator.dart';
import 'package:chat_flow/feature/auth/register/viewmodel/register_view_model.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:chat_flow/utils/extension/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

/// Register ekranı
/// Kullanıcının kayıt olmasını sağlayan ekran
class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: Consumer<RegisterViewModel>(
        builder: (context, viewModel, _) => BlocListener<AuthBloc, AuthState>(
          listener: viewModel.onAuthStateChanged,
          child: Scaffold(
            appBar: _buildAppBar(context, viewModel),
            body: _buildBody(context, viewModel),
          ),
        ),
      ),
    );
  }

  /// AppBar widget'ı
  PreferredSizeWidget _buildAppBar(BuildContext context, RegisterViewModel viewModel) {
    return AppBar(
      title: const CustomText(_RegisterViewStrings.title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => viewModel.navigateToLogin(context),
      ),
    );
  }

  /// Body widget'ı
  Widget _buildBody(BuildContext context, RegisterViewModel viewModel) {
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
              _buildNameField(viewModel),
              const SizedBox(height: PaddingConstants.small),
              _buildEmailField(viewModel),
              const SizedBox(height: PaddingConstants.small),
              _buildPasswordField(viewModel),
              30.h.ph,
              _buildRegisterButton(context, viewModel),
              20.h.ph,
              _buildLoginRow(context, viewModel),
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

  /// İsim alanı
  Widget _buildNameField(RegisterViewModel viewModel) {
    return CustomTextField(
      controller: viewModel.nameController,
      labelText: _RegisterViewStrings.nameLabel,
      hintText: _RegisterViewStrings.nameHint,
      keyboardType: TextInputType.name,
      prefixIcon: const Icon(Icons.person_outline),
      validator: AppValidator.name,
    );
  }

  /// Email alanı
  Widget _buildEmailField(RegisterViewModel viewModel) {
    return CustomTextField(
      controller: viewModel.emailController,
      labelText: _RegisterViewStrings.emailLabel,
      hintText: _RegisterViewStrings.emailHint,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
      validator: AppValidator.email,
    );
  }

  /// Şifre alanı
  Widget _buildPasswordField(RegisterViewModel viewModel) {
    return CustomTextField(
      controller: viewModel.passwordController,
      labelText: _RegisterViewStrings.passwordLabel,
      hintText: _RegisterViewStrings.passwordHint,
      obscureText: true,
      prefixIcon: const Icon(Icons.lock_outline),
      validator: AppValidator.password,
    );
  }

  /// Kayıt ol butonu
  Widget _buildRegisterButton(BuildContext context, RegisterViewModel viewModel) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ButtonWidget(
          onTap: state is AuthLoading ? (){} : () => viewModel.register(context),
          text: state is AuthLoading ? 'Kayıt Yapılıyor...' : _RegisterViewStrings.registerButtonText,
        );
      },
    );
  }

  /// Giriş yap satırı
  Widget _buildLoginRow(BuildContext context, RegisterViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(_RegisterViewStrings.hasAccountText),
        TextButton(
          onPressed: () => viewModel.navigateToLogin(context),
          child: CustomText(
            _RegisterViewStrings.loginButtonText,
            textStyle: context.theme.textTheme.bodySmall?.copyWith(
              color: context.theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// Register ekranı için string sabitleri
class _RegisterViewStrings {
  const _RegisterViewStrings._();

  // AppBar
  static const String title = 'Kayıt Ol';

  // Form
  static const String nameLabel = 'Ad Soyad';
  static const String nameHint = 'John Doe';
  static const String emailLabel = 'E-posta';
  static const String emailHint = 'ornek@email.com';
  static const String passwordLabel = 'Şifre';
  static const String passwordHint = '••••••••';
  static const String registerButtonText = 'Kayıt Ol';

  // Login Text
  static const String hasAccountText = 'Zaten hesabın var mı?';
  static const String loginButtonText = 'Giriş Yap';
}
