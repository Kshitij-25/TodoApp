import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/constants/assets.dart';
import 'package:todo_app/constants/extensions/snack_bar_ext.dart';
import 'package:todo_app/constants/utils/padding_utils.dart';
import 'package:todo_app/constants/utils/sized_box_utils.dart';
import 'package:todo_app/data/models/login_state.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/presentation/notifier/auth_state_notifer.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';
import 'package:todo_app/presentation/widgets/custom_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  static const routeName = '/loginScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(authStateNotifierProvider);
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: PaddingUtils.horizontalLarge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    Assets.appLogo,
                    height: 150,
                    width: 150,
                    color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : null,
                  ),
                  Text(
                    'TaskTrackr',
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBoxUtils.verticalSmall,
                  Text(
                    'Organize your tasks efficiently',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).buttonTheme.colorScheme?.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBoxUtils.verticalLarge,
                  CustomButton(
                    label: 'Sign in with Google',
                    onPressed: () async {
                      await ref.read(authStateNotifierProvider.notifier).loginWithGoogle();
                      if (loginState == LoginState.success) {
                        loginState.log();
                        GoRouter.of(context).goNamed(HomeScreen.routeName);
                        context.showSnackbar('Login Successful');
                      } else {
                        loginState.log();
                        context.showSnackbar('Something went wrong');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        if (loginState == LoginState.loading)
          Container(
            color: Colors.black87,
            child: Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Theme.of(context).indicatorColor,
              ),
            ),
          ),
      ],
    );
  }
}
