import 'package:loading_indicator/loading_indicator.dart';
import 'package:moe/domain/classes/utils.dart';
import 'package:moe/onboarding/features/splash_screen/cubit/splash_screen_cubit.dart';
import 'package:moe/onboarding/features/splash_screen/cubit/splash_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({
    required this.route,
    super.key,
  });

  final Route<dynamic> route;

  @override
  Widget build(BuildContext context) {
    return SplashScreenProvider(
      child: SplashScreenView(
        route: route,
      ),
    );
  }
}

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({required this.route, super.key});

  final Route<dynamic> route;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashScreenCubit, SplashScreenState>(
      listenWhen: (previous, current) {
        return previous.state != InitializationState.successful &&
            current.state == InitializationState.successful;
      },
      listener: (context, _) {
        Navigator.of(context).push(route);
      },
      child: Scaffold(
        backgroundColor: ThemeProperties(context: context).scColor,
        body: Center(
          child: SizedBox(
              height: 150,
              width: 150,
              child: LoadingIndicator(
                indicatorType: Indicator.ballTrianglePathColoredFilled,
                colors: [ThemeProperties(context: context).txColor],
              )),
        ),
      ),
    );
  }
}
