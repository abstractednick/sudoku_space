import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'route_generator.dart';
import '../theme/custom_colors.dart';

/// Examples and documentation for using the routing system
class NavigationExamples {
  // Private constructor to prevent instantiation
  NavigationExamples._();

  /// Example: Basic navigation to different screens
  static void showBasicNavigationExamples(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Navigation Examples'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Basic Navigation:'),
              Text('• Navigator.pushNamed(context, "/game?mode=noob&difficulty=1")'),
              Text('• Navigator.pushNamed(context, "/settings")'),
              Text('• Navigator.pushNamed(context, "/statistics")'),
              SizedBox(height: 16),
              Text('Programmatic Navigation:'),
              Text('• RouteGenerator.navigateToGame(context, mode: GameMode.pro)'),
              Text('• RouteGenerator.navigateWithParams(context, "/tutorial")'),
              Text('• RouteGenerator.popToHome(context)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Example: Navigate to game with different modes and difficulties
  static Future<void> navigateToGameExample(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Game Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.school, color: CustomColors.getPrimaryColor(GameMode.noob)),
              title: const Text('Noob Mode'),
              subtitle: const Text('4×4 Grid • Easy'),
              onTap: () {
                Navigator.pop(context);
                RouteGenerator.navigateToGame(
                  context,
                  mode: GameMode.noob,
                  difficulty: 1,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.sports_esports, color: CustomColors.getPrimaryColor(GameMode.pro)),
              title: const Text('Pro Mode'),
              subtitle: const Text('9×9 Grid • Medium'),
              onTap: () {
                Navigator.pop(context);
                RouteGenerator.navigateToGame(
                  context,
                  mode: GameMode.pro,
                  difficulty: 2,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.whatshot, color: CustomColors.getPrimaryColor(GameMode.beast)),
              title: const Text('Beast Mode'),
              subtitle: const Text('9×9 Grid • Hard'),
              onTap: () {
                Navigator.pop(context);
                RouteGenerator.navigateToGame(
                  context,
                  mode: GameMode.beast,
                  difficulty: 3,
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Example: Navigate with custom parameters
  static void navigateWithCustomParams(BuildContext context) {
    // Example 1: Game with specific parameters
    RouteGenerator.navigateWithParams(
      context,
      AppRoutes.game,
      parameters: {
        AppRoutes.modeParam: GameMode.pro.name,
        AppRoutes.difficultyParam: '2',
        AppRoutes.resumeParam: 'false',
      },
    );

    // Example 2: Game complete with results
    RouteGenerator.navigateToGameComplete(
      context,
      mode: GameMode.pro,
      score: 950,
      time: 180,
      mistakes: 1,
    );

    // Example 3: Game over with details
    RouteGenerator.navigateToGameOver(
      context,
      mode: GameMode.beast,
      time: 300,
      mistakes: 3,
      from: 'timeout',
    );
  }

  /// Example: Handle navigation results
  static Future<void> handleNavigationResults(BuildContext context) async {
    // Navigate and wait for result
    final result = await RouteGenerator.navigateToGame(
      context,
      mode: GameMode.pro,
      difficulty: 2,
    );

    // Handle the result
    if (result != null) {
      if (result is Map<String, dynamic>) {
        final score = result['score'] as int? ?? 0;
        final time = result['time'] as int? ?? 0;
        final mistakes = result['mistakes'] as int? ?? 0;
        final won = result['won'] as bool? ?? false;

        if (won) {
          // Navigate to game complete screen
          RouteGenerator.navigateToGameComplete(
            context,
            mode: GameMode.pro,
            score: score,
            time: time,
            mistakes: mistakes,
          );
        } else {
          // Navigate to game over screen
          RouteGenerator.navigateToGameOver(
            context,
            mode: GameMode.pro,
            time: time,
            mistakes: mistakes,
          );
        }
      }
    }
  }

  /// Example: Conditional navigation based on user state
  static Future<void> conditionalNavigation(BuildContext context) async {
    // Check if user is first time
    // final isFirstTime = await SharedPreferencesHelper.getInstance().isFirstTime;
    
    // Navigate based on condition
    if (true) { // Replace with actual condition
      // First time user - show tutorial
      RouteGenerator.navigateWithParams(
        context,
        AppRoutes.tutorial,
        replace: true,
      );
    } else {
      // Returning user - go to home
      RouteGenerator.navigateWithParams(
        context,
        AppRoutes.home,
        replace: true,
      );
    }
  }

  /// Example: Deep linking support
  static void handleDeepLink(String deepLink) {
    try {
      final uri = Uri.parse(deepLink);
      final path = uri.path;
      final parameters = uri.queryParameters;

      // Handle different deep link patterns
      switch (path) {
        case '/game':
          if (parameters.containsKey(AppRoutes.modeParam)) {
            final mode = GameMode.values.firstWhere(
              (m) => m.name == parameters[AppRoutes.modeParam],
              orElse: () => GameMode.noob,
            );
            final difficulty = int.tryParse(parameters[AppRoutes.difficultyParam] ?? '1') ?? 1;
            
            // Navigate to game (this would need context from somewhere)
            print('Deep link: Navigate to $mode mode with difficulty $difficulty');
          }
          break;
          
        case '/statistics':
          print('Deep link: Navigate to statistics');
          break;
          
        case '/achievements':
          print('Deep link: Navigate to achievements');
          break;
          
        default:
          print('Deep link: Unknown path - $path');
      }
    } catch (e) {
      print('Error handling deep link: $e');
    }
  }

  /// Example: Navigation with loading states
  static Future<void> navigateWithLoading(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Simulate some async operation
      await Future.delayed(const Duration(seconds: 2));

      // Close loading dialog
      Navigator.pop(context);

      // Navigate to destination
      RouteGenerator.navigateWithParams(context, AppRoutes.statistics);
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Example: Navigation stack management
  static void navigationStackManagement(BuildContext context) {
    // Clear entire stack and go to home
    RouteGenerator.clearStackAndNavigate(context, AppRoutes.home);

    // Pop to specific route
    RouteGenerator.popToRoute(context, AppRoutes.home);

    // Pop to home
    RouteGenerator.popToHome(context);

    // Go back with result
    RouteGenerator.goBack(context, {'result': 'success'});

    // Check if can go back
    if (RouteGenerator.canGoBack(context)) {
      RouteGenerator.goBack(context);
    }
  }

  /// Example: Route validation
  static bool validateRoute(String routeName, Map<String, String> parameters) {
    switch (routeName) {
      case AppRoutes.game:
        return AppRoutes.validateGameRouteParams(parameters);
      case AppRoutes.gameComplete:
        return AppRoutes.validateGameCompleteParams(parameters);
      default:
        return true;
    }
  }

  /// Example: Get route information
  static void showRouteInfo(BuildContext context, String routeName) {
    final displayName = AppRoutes.getRouteDisplayName(routeName);
    final icon = AppRoutes.getRouteIcon(routeName);
    final description = AppRoutes.getRouteDescription(routeName);
    final requiresAuth = AppRoutes.requiresAuthentication(routeName);
    final shouldCache = AppRoutes.shouldCache(routeName);
    final transitionType = AppRoutes.getTransitionType(routeName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(displayName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: $description'),
            const SizedBox(height: 8),
            Text('Requires Auth: $requiresAuth'),
            Text('Should Cache: $shouldCache'),
            Text('Transition: $transitionType'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Example widget showing navigation buttons
class NavigationExampleWidget extends StatelessWidget {
  const NavigationExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Examples'),
        backgroundColor: ColorConstants.background,
        foregroundColor: ColorConstants.textWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => NavigationExamples.navigateToGameExample(context),
              child: const Text('Navigate to Game'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => NavigationExamples.navigateWithCustomParams(context),
              child: const Text('Custom Parameters'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => NavigationExamples.navigateWithLoading(context),
              child: const Text('Navigate with Loading'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => NavigationExamples.showBasicNavigationExamples(context),
              child: const Text('Show Examples'),
            ),
          ],
        ),
      ),
    );
  }
}
