import 'package:chat_flow/core/components/button/button.dart';
import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/components/text_field/custom_text_field.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/constants/enums/lottie_enums.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:chat_flow/core/init/validator/app_validator.dart';
import 'package:chat_flow/feature/auth/bloc/auth_bloc.dart';
import 'package:chat_flow/feature/main/view/main_view.dart';
import 'package:chat_flow/utils/extension/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
part '../mixin/register_view_mixin.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with _RegisterViewMixin {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          locator<NavigationService>().navigateToPageClear(context: context, page: const MainView());
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(_RegisterViewStrings.title),
        ),
        body: Padding(
          padding: PaddingConstants.paddingAllSmall,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    LottieEnums.login.path,
                    width: 300.h,
                  ),
                  const SizedBox(height: PaddingConstants.small),
                  CustomTextField(
                    controller: _nameController,
                    labelText: _RegisterViewStrings.nameLabel,
                    hintText: _RegisterViewStrings.nameHint,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: AppValidator.name,
                  ),
                  const SizedBox(height: PaddingConstants.small),
                  CustomTextField(
                    controller: _emailController,
                    labelText: _RegisterViewStrings.emailLabel,
                    hintText: _RegisterViewStrings.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: AppValidator.email,
                  ),
                  const SizedBox(height: PaddingConstants.small),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: _RegisterViewStrings.passwordLabel,
                    hintText: _RegisterViewStrings.passwordHint,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: AppValidator.password,
                  ),
                  const SizedBox(height: PaddingConstants.large),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ButtonWidget(
                        onTap: state is AuthLoading
                            ? () {}
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        AuthRegisterRequested(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text.trim(),
                                          fullName: _nameController.text.trim(),
                                        ),
                                      );
                                }
                              },
                        text: state is AuthLoading ? 'Kayıt Yapılıyor...' : _RegisterViewStrings.registerButtonText,
                      );
                    },
                  ),
                  10.h.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(_RegisterViewStrings.hasAccountText),
                      TextButton(
                        onPressed: () {
                          locator<NavigationService>().navigateToBack(context);
                        },
                        child: const Text(
                          _RegisterViewStrings.loginButtonText,
                          style: TextStyle(
                            color: Colors.deepPurple,
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
      ),
    );
  }
}
