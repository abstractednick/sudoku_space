import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../constants/string_constants.dart';
import '../constants/color_constants.dart';
import '../constants/dimension_constants.dart';
import '../theme/custom_colors.dart';

/// Custom route generator with animated transitions and parameter parsing
class RouteGenerator {
  // Private constructor to prevent instantiation
  RouteGenerator._();

  // Route configurations
  static final Map<String, RouteConfig> _routes = {};

  /// Initialize routes with configurations
  static void initializeRoutes(Map<String, RouteConfig> routes) {
    _routes.clear();
    _routes.addAll(routes);
  }

  /// Generate route based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? AppRoutes.notFound;
    final Map<String, String> parameters = AppRoutes.parseParameters(settings);

    // Check if route exists
    if (!_routes.containsKey(routeName)) {
      return _generateNotFoundRoute(settings);
    }

    final routeConfig = _routes[routeName]!;

    // Validate route parameters if needed
    if (routeName == AppRoutes.game && !AppRoutes.validateGameRouteParams(parameters)) {
      return _generateInvalidParamsRoute(settings);
    }

    if (routeName == AppRoutes.gameComplete && !AppRoutes.validateGameCompleteParams(parameters)) {
      return _generateInvalidParamsRoute(settings);
    }

    // Create route with appropriate transition
    return _createAnimatedRoute(
      settings: settings,
      builder: routeConfig.builder,
      transitionType: routeConfig.transitionType,
      transitionDuration: routeConfig.transitionDuration,
    );
  }

  /// Create animated route with custom transition
  static Route<dynamic> _createAnimatedRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
    required RouteTransitionType transitionType,
    required Duration transitionDuration,
  }) {
    switch (transitionType) {
      case RouteTransitionType.fade:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

      case RouteTransitionType.slideFromRight:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );

      case RouteTransitionType.slideFromLeft:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );

      case RouteTransitionType.slideFromTop:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, -1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );

      case RouteTransitionType.slideFromBottom:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );

      case RouteTransitionType.scale:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.elasticOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );
          },
        );

      case RouteTransitionType.rotation:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return RotationTransition(
              turns: animation.drive(tween),
              child: child,
            );
          },
        );

      case RouteTransitionType.custom:
        return _createCustomTransition(
          settings: settings,
          builder: builder,
          transitionDuration: transitionDuration,
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: builder,
        );
    }
  }

  /// Create custom transition with multiple effects
  static Route<dynamic> _createCustomTransition({
    required RouteSettings settings,
    required WidgetBuilder builder,
    required Duration transitionDuration,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionDuration: transitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Combine multiple transitions
        const slideBegin = Offset(0.0, 1.0);
        const slideEnd = Offset.zero;
        const slideCurve = Curves.easeInOut;

        final slideTween = Tween(begin: slideBegin, end: slideEnd).chain(
          CurveTween(curve: slideCurve),
        );

        final fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: slideCurve),
        );

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  /// Generate 404 not found route
  static Route<dynamic> _generateNotFoundRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => const NotFoundPage(),
    );
  }

  /// Generate invalid parameters route
  static Route<dynamic> _generateInvalidParamsRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => const InvalidParamsPage(),
    );
  }

  /// Navigate with parameters
  static Future<T?> navigateWithParams<T extends Object?>(
    BuildContext context,
    String routeName, {
    Map<String, String>? parameters,
    bool replace = false,
  }) {
    final route = AppRoutes.buildRoute(routeName, parameters: parameters);
    
    if (replace) {
      return Navigator.pushReplacementNamed(context, route);
    } else {
      return Navigator.pushNamed(context, route);
    }
  }

  /// Navigate to game with mode and difficulty
  static Future<T?> navigateToGame<T extends Object?>(
    BuildContext context, {
    required GameMode mode,
    int difficulty = 1,
    bool resume = false,
    bool replace = false,
  }) {
    final route = AppRoutes.buildGameRoute(
      mode: mode,
      difficulty: difficulty,
      resume: resume,
    );
    
    if (replace) {
      return Navigator.pushReplacementNamed(context, route);
    } else {
      return Navigator.pushNamed(context, route);
    }
  }

  /// Navigate to game complete screen
  static Future<T?> navigateToGameComplete<T extends Object?>(
    BuildContext context, {
    required GameMode mode,
    required int score,
    required int time,
    required int mistakes,
  }) {
    final route = AppRoutes.buildGameCompleteRoute(
      mode: mode,
      score: score,
      time: time,
      mistakes: mistakes,
    );
    
    return Navigator.pushReplacementNamed(context, route);
  }

  /// Navigate to game over screen
  static Future<T?> navigateToGameOver<T extends Object?>(
    BuildContext context, {
    required GameMode mode,
    required int time,
    required int mistakes,
    String? from,
  }) {
    final route = AppRoutes.buildGameOverRoute(
      mode: mode,
      time: time,
      mistakes: mistakes,
      from: from,
    );
    
    return Navigator.pushReplacementNamed(context, route);
  }

  /// Pop to specific route
  static void popToRoute(BuildContext context, String routeName) {
    Navigator.popUntil(context, (route) => route.settings.name == routeName);
  }

  /// Pop to home
  static void popToHome(BuildContext context) {
    popToRoute(context, AppRoutes.home);
  }

  /// Clear navigation stack and go to route
  static Future<T?> clearStackAndNavigate<T extends Object?>(
    BuildContext context,
    String routeName, {
    Map<String, String>? parameters,
  }) {
    final route = AppRoutes.buildRoute(routeName, parameters: parameters);
    
    return Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false,
    );
  }

  /// Go back with result
  static void goBack<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  /// Can go back
  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }
}

/// 404 Not Found Page
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: ColorConstants.background,
        foregroundColor: ColorConstants.textWhite,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(DimensionConstants.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 120,
                color: ColorConstants.error,
              ),
              const SizedBox(height: DimensionConstants.spacingL),
              Text(
                '404',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: ColorConstants.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DimensionConstants.spacingM),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: ColorConstants.textWhite,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DimensionConstants.spacingM),
              Text(
                'The page you are looking for does not exist.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorConstants.textGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DimensionConstants.spacingXL),
              ElevatedButton.icon(
                onPressed: () => RouteGenerator.popToHome(context),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.noobCyan,
                  foregroundColor: ColorConstants.background,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DimensionConstants.spacingXL,
                    vertical: DimensionConstants.spacingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Invalid Parameters Page
class InvalidParamsPage extends StatelessWidget {
  const InvalidParamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      appBar: AppBar(
        title: const Text('Invalid Parameters'),
        backgroundColor: ColorConstants.background,
        foregroundColor: ColorConstants.textWhite,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(DimensionConstants.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_outlined,
                size: 120,
                color: ColorConstants.warning,
              ),
              const SizedBox(height: DimensionConstants.spacingL),
              Text(
                'Invalid Parameters',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: ColorConstants.warning,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DimensionConstants.spacingM),
              Text(
                'The parameters provided for this page are invalid or missing.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorConstants.textGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DimensionConstants.spacingXL),
              ElevatedButton.icon(
                onPressed: () => RouteGenerator.popToHome(context),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.warning,
                  foregroundColor: ColorConstants.background,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DimensionConstants.spacingXL,
                    vertical: DimensionConstants.spacingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
