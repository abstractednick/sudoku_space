import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';

/// App route names and configurations
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Route names
  static const String home = '/';
  static const String game = '/game';
  static const String tutorial = '/tutorial';
  static const String settings = '/settings';
  static const String statistics = '/statistics';
  static const String achievements = '/achievements';
  static const String about = '/about';
  static const String gameMode = '/game-mode';
  static const String pause = '/pause';
  static const String gameComplete = '/game-complete';
  static const String gameOver = '/game-over';
  static const String notFound = '/404';

  /// Route parameters
  static const String modeParam = 'mode';
  static const String difficultyParam = 'difficulty';
  static const String scoreParam = 'score';
  static const String timeParam = 'time';
  static const String mistakesParam = 'mistakes';
  static const String fromParam = 'from';
  static const String resumeParam = 'resume';

  /// Game mode values
  static const String noobMode = 'noob';
  static const String proMode = 'pro';
  static const String beastMode = 'beast';

  /// Difficulty levels
  static const String easyDifficulty = '1';
  static const String mediumDifficulty = '2';
  static const String hardDifficulty = '3';

  /// Build route with parameters
  static String buildRoute(String routeName, {Map<String, String>? parameters}) {
    if (parameters == null || parameters.isEmpty) {
      return routeName;
    }

    final uri = Uri(path: routeName, queryParameters: parameters);
    return uri.toString();
  }

  /// Build game route with mode and difficulty
  static String buildGameRoute({
    required GameMode mode,
    int difficulty = 1,
    bool resume = false,
  }) {
    return buildRoute(game, parameters: {
      modeParam: mode.name,
      difficultyParam: difficulty.toString(),
      if (resume) resumeParam: 'true',
    });
  }

  /// Build game complete route with results
  static String buildGameCompleteRoute({
    required GameMode mode,
    required int score,
    required int time,
    required int mistakes,
  }) {
    return buildRoute(gameComplete, parameters: {
      modeParam: mode.name,
      scoreParam: score.toString(),
      timeParam: time.toString(),
      mistakesParam: mistakes.toString(),
    });
  }

  /// Build game over route
  static String buildGameOverRoute({
    required GameMode mode,
    required int time,
    required int mistakes,
    String? from,
  }) {
    return buildRoute(gameOver, parameters: {
      modeParam: mode.name,
      timeParam: time.toString(),
      mistakesParam: mistakes.toString(),
      if (from != null) fromParam: from,
    });
  }

  /// Parse route parameters from route settings
  static Map<String, String> parseParameters(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');
    return uri.queryParameters;
  }

  /// Get game mode from route parameters
  static GameMode getGameModeFromParams(Map<String, String> params) {
    final modeString = params[modeParam] ?? noobMode;
    return GameMode.values.firstWhere(
      (mode) => mode.name == modeString,
      orElse: () => GameMode.noob,
    );
  }

  /// Get difficulty from route parameters
  static int getDifficultyFromParams(Map<String, String> params) {
    final difficultyString = params[difficultyParam] ?? easyDifficulty;
    return int.tryParse(difficultyString) ?? 1;
  }

  /// Get score from route parameters
  static int getScoreFromParams(Map<String, String> params) {
    final scoreString = params[scoreParam] ?? '0';
    return int.tryParse(scoreString) ?? 0;
  }

  /// Get time from route parameters
  static int getTimeFromParams(Map<String, String> params) {
    final timeString = params[timeParam] ?? '0';
    return int.tryParse(timeString) ?? 0;
  }

  /// Get mistakes from route parameters
  static int getMistakesFromParams(Map<String, String> params) {
    final mistakesString = params[mistakesParam] ?? '0';
    return int.tryParse(mistakesString) ?? 0;
  }

  /// Check if route should resume game
  static bool shouldResumeFromParams(Map<String, String> params) {
    return params[resumeParam]?.toLowerCase() == 'true';
  }

  /// Get source route from parameters
  static String? getSourceFromParams(Map<String, String> params) {
    return params[fromParam];
  }

  /// Validate route parameters
  static bool validateGameRouteParams(Map<String, String> params) {
    final mode = getGameModeFromParams(params);
    final difficulty = getDifficultyFromParams(params);
    
    // Validate game mode
    if (!GameMode.values.contains(mode)) {
      return false;
    }
    
    // Validate difficulty (1-3)
    if (difficulty < 1 || difficulty > 3) {
      return false;
    }
    
    return true;
  }

  /// Validate game complete route parameters
  static bool validateGameCompleteParams(Map<String, String> params) {
    final mode = getGameModeFromParams(params);
    final score = getScoreFromParams(params);
    final time = getTimeFromParams(params);
    final mistakes = getMistakesFromParams(params);
    
    // Validate game mode
    if (!GameMode.values.contains(mode)) {
      return false;
    }
    
    // Validate score (0 or positive)
    if (score < 0) {
      return false;
    }
    
    // Validate time (0 or positive)
    if (time < 0) {
      return false;
    }
    
    // Validate mistakes (0-3)
    if (mistakes < 0 || mistakes > 3) {
      return false;
    }
    
    return true;
  }

  /// Get route display name for UI
  static String getRouteDisplayName(String routeName) {
    switch (routeName) {
      case home:
        return 'Home';
      case game:
        return 'Game';
      case tutorial:
        return 'Tutorial';
      case settings:
        return 'Settings';
      case statistics:
        return 'Statistics';
      case achievements:
        return 'Achievements';
      case about:
        return 'About';
      case gameMode:
        return 'Select Mode';
      case pause:
        return 'Paused';
      case gameComplete:
        return 'Game Complete';
      case gameOver:
        return 'Game Over';
      case notFound:
        return 'Page Not Found';
      default:
        return 'Unknown Page';
    }
  }

  /// Get route icon for UI
  static IconData getRouteIcon(String routeName) {
    switch (routeName) {
      case home:
        return Icons.home;
      case game:
        return Icons.games;
      case tutorial:
        return Icons.school;
      case settings:
        return Icons.settings;
      case statistics:
        return Icons.analytics;
      case achievements:
        return Icons.emoji_events;
      case about:
        return Icons.info;
      case gameMode:
        return Icons.play_circle;
      case pause:
        return Icons.pause_circle;
      case gameComplete:
        return Icons.check_circle;
      case gameOver:
        return Icons.cancel;
      case notFound:
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  /// Get route description for UI
  static String getRouteDescription(String routeName) {
    switch (routeName) {
      case home:
        return 'Main menu and game selection';
      case game:
        return 'Play Sudoku with selected mode and difficulty';
      case tutorial:
        return 'Learn how to play Sudoku';
      case settings:
        return 'App settings and preferences';
      case statistics:
        return 'View your game statistics';
      case achievements:
        return 'View unlocked achievements';
      case about:
        return 'About the app and developer';
      case gameMode:
        return 'Select game mode and difficulty';
      case pause:
        return 'Game paused - resume or quit';
      case gameComplete:
        return 'Congratulations! Game completed successfully';
      case gameOver:
        return 'Game over - try again or return to menu';
      case notFound:
        return 'The requested page could not be found';
      default:
        return 'Unknown page description';
    }
  }

  /// Check if route requires authentication
  static bool requiresAuthentication(String routeName) {
    // For now, no routes require authentication
    // This can be extended for future features like cloud sync
    return false;
  }

  /// Check if route should be cached
  static bool shouldCache(String routeName) {
    switch (routeName) {
      case home:
      case settings:
      case statistics:
      case achievements:
      case about:
        return true;
      default:
        return false;
    }
  }

  /// Get route transition type
  static RouteTransitionType getTransitionType(String routeName) {
    switch (routeName) {
      case home:
        return RouteTransitionType.fade;
      case game:
        return RouteTransitionType.slideFromRight;
      case tutorial:
        return RouteTransitionType.slideFromBottom;
      case settings:
        return RouteTransitionType.slideFromRight;
      case statistics:
        return RouteTransitionType.slideFromRight;
      case achievements:
        return RouteTransitionType.slideFromBottom;
      case about:
        return RouteTransitionType.fade;
      case gameMode:
        return RouteTransitionType.slideFromBottom;
      case pause:
        return RouteTransitionType.fade;
      case gameComplete:
        return RouteTransitionType.scale;
      case gameOver:
        return RouteTransitionType.scale;
      case notFound:
        return RouteTransitionType.fade;
      default:
        return RouteTransitionType.slideFromRight;
    }
  }

  /// Get route transition duration
  static Duration getTransitionDuration(String routeName) {
    switch (routeName) {
      case gameComplete:
      case gameOver:
        return const Duration(milliseconds: 600);
      case pause:
        return const Duration(milliseconds: 300);
      default:
        return const Duration(milliseconds: 400);
    }
  }
}

/// Route transition types
enum RouteTransitionType {
  fade,
  slideFromRight,
  slideFromLeft,
  slideFromTop,
  slideFromBottom,
  scale,
  rotation,
  custom,
}

/// Route configuration for navigation
class RouteConfig {
  final String name;
  final WidgetBuilder builder;
  final RouteTransitionType transitionType;
  final Duration transitionDuration;
  final bool requiresAuth;
  final bool shouldCache;
  final String? title;
  final IconData? icon;
  final String? description;

  const RouteConfig({
    required this.name,
    required this.builder,
    this.transitionType = RouteTransitionType.slideFromRight,
    this.transitionDuration = const Duration(milliseconds: 400),
    this.requiresAuth = false,
    this.shouldCache = false,
    this.title,
    this.icon,
    this.description,
  });
}
