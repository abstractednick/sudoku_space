import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../theme/custom_colors.dart';

/// Game statistics model
class GameStats {
  final int gamesPlayed;
  final int gamesWon;
  final int totalTime;
  final int bestTime;
  final int winStreak;
  final int longestStreak;
  final Map<GameMode, int> winsPerMode;
  final Map<GameMode, int> lossesPerMode;

  const GameStats({
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.totalTime = 0,
    this.bestTime = 0,
    this.winStreak = 0,
    this.longestStreak = 0,
    this.winsPerMode = const {},
    this.lossesPerMode = const {},
  });

  GameStats copyWith({
    int? gamesPlayed,
    int? gamesWon,
    int? totalTime,
    int? bestTime,
    int? winStreak,
    int? longestStreak,
    Map<GameMode, int>? winsPerMode,
    Map<GameMode, int>? lossesPerMode,
  }) {
    return GameStats(
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
      totalTime: totalTime ?? this.totalTime,
      bestTime: bestTime ?? this.bestTime,
      winStreak: winStreak ?? this.winStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      winsPerMode: winsPerMode ?? this.winsPerMode,
      lossesPerMode: lossesPerMode ?? this.lossesPerMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'totalTime': totalTime,
      'bestTime': bestTime,
      'winStreak': winStreak,
      'longestStreak': longestStreak,
      'winsPerMode': winsPerMode.map((key, value) => MapEntry(key.name, value)),
      'lossesPerMode': lossesPerMode.map((key, value) => MapEntry(key.name, value)),
    };
  }

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      gamesPlayed: json['gamesPlayed'] ?? 0,
      gamesWon: json['gamesWon'] ?? 0,
      totalTime: json['totalTime'] ?? 0,
      bestTime: json['bestTime'] ?? 0,
      winStreak: json['winStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      winsPerMode: (json['winsPerMode'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(GameMode.values.firstWhere((e) => e.name == key), value as int)),
      lossesPerMode: (json['lossesPerMode'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(GameMode.values.firstWhere((e) => e.name == key), value as int)),
    );
  }
}

/// Singleton helper for managing SharedPreferences
class SharedPreferencesHelper {
  static SharedPreferencesHelper? _instance;
  static SharedPreferences? _prefs;

  // Private constructor
  SharedPreferencesHelper._();

  /// Get singleton instance
  static Future<SharedPreferencesHelper> getInstance() async {
    _instance ??= SharedPreferencesHelper._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// Initialize SharedPreferences
  static Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _instance = SharedPreferencesHelper._();
    } catch (e) {
      throw Exception('Failed to initialize SharedPreferences: $e');
    }
  }

  // Keys for different data types
  static const String _keyFirstTime = 'first_time_flag';
  static const String _keyGameStats = 'game_stats';
  static const String _keyRatingStatus = 'rating_status';
  static const String _keySelectedMode = 'selected_mode';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyMusicEnabled = 'music_enabled';
  static const String _keyVibrationEnabled = 'vibration_enabled';
  static const String _keyLastPlayedDate = 'last_played_date';
  static const String _keyTutorialCompleted = 'tutorial_completed';
  static const String _keyHintsUsed = 'hints_used';
  static const String _keyTotalPlayTime = 'total_play_time';

  /// Check if this is the first time the app is launched
  Future<bool> get isFirstTime async {
    try {
      return _prefs?.getBool(_keyFirstTime) ?? true;
    } catch (e) {
      print('Error getting first time flag: $e');
      return true;
    }
  }

  /// Set first time flag to false
  Future<bool> setFirstTimeCompleted() async {
    try {
      return await _prefs?.setBool(_keyFirstTime, false) ?? false;
    } catch (e) {
      print('Error setting first time flag: $e');
      return false;
    }
  }

  /// Get game statistics
  Future<GameStats> getGameStats() async {
    try {
      final statsJson = _prefs?.getString(_keyGameStats);
      if (statsJson != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(statsJson);
        return GameStats.fromJson(jsonMap);
      }
      return const GameStats();
    } catch (e) {
      print('Error getting game stats: $e');
      return const GameStats();
    }
  }

  /// Save game statistics
  Future<bool> saveGameStats(GameStats stats) async {
    try {
      final statsJson = jsonEncode(stats.toJson());
      return await _prefs?.setString(_keyGameStats, statsJson) ?? false;
    } catch (e) {
      print('Error saving game stats: $e');
      return false;
    }
  }

  /// Update game statistics after game completion
  Future<bool> updateGameStats({
    required bool won,
    required GameMode mode,
    required int gameTime,
  }) async {
    try {
      final currentStats = await getGameStats();
      
      final newWinsPerMode = Map<GameMode, int>.from(currentStats.winsPerMode);
      final newLossesPerMode = Map<GameMode, int>.from(currentStats.lossesPerMode);
      
      if (won) {
        newWinsPerMode[mode] = (newWinsPerMode[mode] ?? 0) + 1;
      } else {
        newLossesPerMode[mode] = (newLossesPerMode[mode] ?? 0) + 1;
      }

      final updatedStats = currentStats.copyWith(
        gamesPlayed: currentStats.gamesPlayed + 1,
        gamesWon: currentStats.gamesWon + (won ? 1 : 0),
        totalTime: currentStats.totalTime + gameTime,
        bestTime: currentStats.bestTime == 0 || (won && gameTime < currentStats.bestTime) 
            ? gameTime 
            : currentStats.bestTime,
        winStreak: won ? currentStats.winStreak + 1 : 0,
        longestStreak: won ? 
            (currentStats.winStreak + 1 > currentStats.longestStreak ? 
                currentStats.winStreak + 1 : currentStats.longestStreak) : 
            currentStats.longestStreak,
        winsPerMode: newWinsPerMode,
        lossesPerMode: newLossesPerMode,
      );

      return await saveGameStats(updatedStats);
    } catch (e) {
      print('Error updating game stats: $e');
      return false;
    }
  }

  /// Get rating status
  Future<String> getRatingStatus() async {
    try {
      return _prefs?.getString(_keyRatingStatus) ?? 'never_asked';
    } catch (e) {
      print('Error getting rating status: $e');
      return 'never_asked';
    }
  }

  /// Set rating status
  Future<bool> setRatingStatus(String status) async {
    try {
      return await _prefs?.setString(_keyRatingStatus, status) ?? false;
    } catch (e) {
      print('Error setting rating status: $e');
      return false;
    }
  }

  /// Get selected game mode
  Future<GameMode> getSelectedMode() async {
    try {
      final modeString = _prefs?.getString(_keySelectedMode) ?? 'noob';
      return GameMode.values.firstWhere(
        (mode) => mode.name == modeString,
        orElse: () => GameMode.noob,
      );
    } catch (e) {
      print('Error getting selected mode: $e');
      return GameMode.noob;
    }
  }

  /// Set selected game mode
  Future<bool> setSelectedMode(GameMode mode) async {
    try {
      return await _prefs?.setString(_keySelectedMode, mode.name) ?? false;
    } catch (e) {
      print('Error setting selected mode: $e');
      return false;
    }
  }

  /// Get sound enabled status
  Future<bool> getSoundEnabled() async {
    try {
      return _prefs?.getBool(_keySoundEnabled) ?? true;
    } catch (e) {
      print('Error getting sound enabled: $e');
      return true;
    }
  }

  /// Set sound enabled status
  Future<bool> setSoundEnabled(bool enabled) async {
    try {
      return await _prefs?.setBool(_keySoundEnabled, enabled) ?? false;
    } catch (e) {
      print('Error setting sound enabled: $e');
      return false;
    }
  }

  /// Get music enabled status
  Future<bool> getMusicEnabled() async {
    try {
      return _prefs?.getBool(_keyMusicEnabled) ?? true;
    } catch (e) {
      print('Error getting music enabled: $e');
      return true;
    }
  }

  /// Set music enabled status
  Future<bool> setMusicEnabled(bool enabled) async {
    try {
      return await _prefs?.setBool(_keyMusicEnabled, enabled) ?? false;
    } catch (e) {
      print('Error setting music enabled: $e');
      return false;
    }
  }

  /// Get vibration enabled status
  Future<bool> getVibrationEnabled() async {
    try {
      return _prefs?.getBool(_keyVibrationEnabled) ?? true;
    } catch (e) {
      print('Error getting vibration enabled: $e');
      return true;
    }
  }

  /// Set vibration enabled status
  Future<bool> setVibrationEnabled(bool enabled) async {
    try {
      return await _prefs?.setBool(_keyVibrationEnabled, enabled) ?? false;
    } catch (e) {
      print('Error setting vibration enabled: $e');
      return false;
    }
  }

  /// Get last played date
  Future<DateTime?> getLastPlayedDate() async {
    try {
      final timestamp = _prefs?.getInt(_keyLastPlayedDate);
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      print('Error getting last played date: $e');
      return null;
    }
  }

  /// Set last played date
  Future<bool> setLastPlayedDate(DateTime date) async {
    try {
      return await _prefs?.setInt(_keyLastPlayedDate, date.millisecondsSinceEpoch) ?? false;
    } catch (e) {
      print('Error setting last played date: $e');
      return false;
    }
  }

  /// Check if tutorial is completed
  Future<bool> getTutorialCompleted() async {
    try {
      return _prefs?.getBool(_keyTutorialCompleted) ?? false;
    } catch (e) {
      print('Error getting tutorial completed: $e');
      return false;
    }
  }

  /// Set tutorial completed
  Future<bool> setTutorialCompleted(bool completed) async {
    try {
      return await _prefs?.setBool(_keyTutorialCompleted, completed) ?? false;
    } catch (e) {
      print('Error setting tutorial completed: $e');
      return false;
    }
  }

  /// Get total hints used
  Future<int> getHintsUsed() async {
    try {
      return _prefs?.getInt(_keyHintsUsed) ?? 0;
    } catch (e) {
      print('Error getting hints used: $e');
      return 0;
    }
  }

  /// Increment hints used
  Future<bool> incrementHintsUsed() async {
    try {
      final currentHints = await getHintsUsed();
      return await _prefs?.setInt(_keyHintsUsed, currentHints + 1) ?? false;
    } catch (e) {
      print('Error incrementing hints used: $e');
      return false;
    }
  }

  /// Get total play time
  Future<int> getTotalPlayTime() async {
    try {
      return _prefs?.getInt(_keyTotalPlayTime) ?? 0;
    } catch (e) {
      print('Error getting total play time: $e');
      return 0;
    }
  }

  /// Add to total play time
  Future<bool> addToTotalPlayTime(int seconds) async {
    try {
      final currentTime = await getTotalPlayTime();
      return await _prefs?.setInt(_keyTotalPlayTime, currentTime + seconds) ?? false;
    } catch (e) {
      print('Error adding to total play time: $e');
      return false;
    }
  }

  /// Clear all data (for testing or reset)
  Future<bool> clearAllData() async {
    try {
      return await _prefs?.clear() ?? false;
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }

  /// Reset game statistics only
  Future<bool> resetGameStats() async {
    try {
      return await _prefs?.remove(_keyGameStats) ?? false;
    } catch (e) {
      print('Error resetting game stats: $e');
      return false;
    }
  }
}
