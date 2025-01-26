import 'package:chat_flow/core/components/button/button.dart';
import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/components/text_field/custom_text_field.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/constants/enums/lottie_enums.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:chat_flow/core/init/validator/app_validator.dart';
import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:chat_flow/feature/auth/register/view/register_view.dart';
import 'package:chat_flow/feature/main/view/main_view.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:chat_flow/utils/extension/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
part '../mixin/login_view_mixin.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with _LoginViewMixin {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => _listenBloc(state, context),
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(_LoginViewStrings.title),
        ),
        body: Padding(
          padding: PaddingConstants.paddingAllSmall,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  LottieEnums.login.path,
                  width: 300.h,
                ),
                20.h.ph,
                CustomTextField(
                  controller: _emailController,
                  labelText: _LoginViewStrings.emailLabel,
                  hintText: _LoginViewStrings.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: AppValidator.email,
                ),
                const SizedBox(height: PaddingConstants.small),
                CustomTextField(
                  controller: _passwordController,
                  labelText: _LoginViewStrings.passwordLabel,
                  hintText: _LoginViewStrings.passwordHint,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: AppValidator.password,
                ),
                30.h.ph,
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ButtonWidget(
                      onTap: state is AuthLoading
                          ? () {}
                          : () {
                              _login(context);
                            },
                      text: state is AuthLoading ? 'Giriş Yapılıyor...' : _LoginViewStrings.loginButtonText,
                    );
                  },
                ),
                20.h.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(_LoginViewStrings.noAccountText),
                    TextButton(
                      onPressed: () {
                        _goToRegisterView(context);
                      },
                      child: CustomText(
                        _LoginViewStrings.registerButtonText,
                        textStyle: context.theme.textTheme.bodySmall?.copyWith(
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
