import 'package:equatable/equatable.dart';

/// Game mode enumeration with properties for different Sudoku variants
enum GameMode {
  noob,
  pro,
  beast,
}

/// Extension on GameMode to provide additional properties and methods
extension GameModeExtension on GameMode {
  /// Get the grid size for this game mode
  int get gridSize {
    switch (this) {
      case GameMode.noob:
        return 4;
      case GameMode.pro:
      case GameMode.beast:
        return 9;
    }
  }

  /// Get the box size (sub-grid size) for this game mode
  int get boxSize {
    switch (this) {
      case GameMode.noob:
        return 2; // 2x2 boxes in 4x4 grid
      case GameMode.pro:
      case GameMode.beast:
        return 3; // 3x3 boxes in 9x9 grid
    }
  }

  /// Get the number of boxes per row/column
  int get boxesPerDimension {
    switch (this) {
      case GameMode.noob:
        return 2; // 2x2 boxes
      case GameMode.pro:
      case GameMode.beast:
        return 3; // 3x3 boxes
    }
  }

  /// Get the total number of cells in the grid
  int get totalCells => gridSize * gridSize;

  /// Get the total number of boxes in the grid
  int get totalBoxes => boxesPerDimension * boxesPerDimension;

  /// Get the maximum number that can be placed in cells
  int get maxNumber {
    switch (this) {
      case GameMode.noob:
        return 4;
      case GameMode.pro:
      case GameMode.beast:
        return 9;
    }
  }

  /// Get the display name for this game mode
  String get displayName {
    switch (this) {
      case GameMode.noob:
        return 'Noob Mode';
      case GameMode.pro:
        return 'Pro Mode';
      case GameMode.beast:
        return 'Beast Mode';
    }
  }

  /// Get the short description for this game mode
  String get shortDescription {
    switch (this) {
      case GameMode.noob:
        return '4×4 Grid';
      case GameMode.pro:
        return '9×9 Grid';
      case GameMode.beast:
        return '9×9 Grid';
    }
  }

  /// Get the full description for this game mode
  String get fullDescription {
    switch (this) {
      case GameMode.noob:
        return '4×4 Grid • Perfect for beginners';
      case GameMode.pro:
        return '9×9 Grid • Classic Sudoku challenge';
      case GameMode.beast:
        return '9×9 Grid • Extreme difficulty';
    }
  }

  /// Get the difficulty level (1-3)
  int get difficultyLevel {
    switch (this) {
      case GameMode.noob:
        return 1;
      case GameMode.pro:
        return 2;
      case GameMode.beast:
        return 3;
    }
  }

  /// Get the maximum allowed mistakes
  int get maxMistakes {
    switch (this) {
      case GameMode.noob:
        return 5; // More forgiving for beginners
      case GameMode.pro:
        return 3; // Standard
      case GameMode.beast:
        return 1; // Very strict
    }
  }

  /// Get the maximum hints available
  int get maxHints {
    switch (this) {
      case GameMode.noob:
        return 10; // More hints for beginners
      case GameMode.pro:
        return 5; // Standard
      case GameMode.beast:
        return 2; // Very few hints
    }
  }

  /// Get the time limit in seconds (0 means no limit)
  int get timeLimit {
    switch (this) {
      case GameMode.noob:
        return 0; // No time limit for beginners
      case GameMode.pro:
        return 1800; // 30 minutes
      case GameMode.beast:
        return 900; // 15 minutes
    }
  }

  /// Get the icon data for this game mode
  String get iconName {
    switch (this) {
      case GameMode.noob:
        return 'school';
      case GameMode.pro:
        return 'sports_esports';
      case GameMode.beast:
        return 'whatshot';
    }
  }

  /// Get the color theme for this game mode
  String get colorTheme {
    switch (this) {
      case GameMode.noob:
        return 'cyan';
      case GameMode.pro:
        return 'red';
      case GameMode.beast:
        return 'red';
    }
  }

  /// Check if this is a beginner-friendly mode
  bool get isBeginnerFriendly {
    switch (this) {
      case GameMode.noob:
        return true;
      case GameMode.pro:
      case GameMode.beast:
        return false;
    }
  }

  /// Check if this mode has time pressure
  bool get hasTimeLimit => timeLimit > 0;

  /// Check if this mode is high difficulty
  bool get isHighDifficulty {
    switch (this) {
      case GameMode.noob:
      case GameMode.pro:
        return false;
      case GameMode.beast:
        return true;
    }
  }

  /// Get the recommended cell size for UI
  double get recommendedCellSize {
    switch (this) {
      case GameMode.noob:
        return 60.0; // Larger cells for easier interaction
      case GameMode.pro:
      case GameMode.beast:
        return 40.0; // Standard size
    }
  }

  /// Get the recommended grid padding for UI
  double get recommendedGridPadding {
    switch (this) {
      case GameMode.noob:
        return 16.0;
      case GameMode.pro:
      case GameMode.beast:
        return 12.0;
    }
  }

  /// Get the recommended font size for cell numbers
  double get recommendedFontSize {
    switch (this) {
      case GameMode.noob:
        return 24.0;
      case GameMode.pro:
      case GameMode.beast:
        return 18.0;
    }
  }

  /// Check if this mode supports notes
  bool get supportsNotes => true;

  /// Check if this mode supports undo
  bool get supportsUndo => true;

  /// Get the maximum undo steps allowed
  int get maxUndoSteps {
    switch (this) {
      case GameMode.noob:
        return 20; // More forgiving
      case GameMode.pro:
        return 10; // Standard
      case GameMode.beast:
        return 5; // Limited
    }
  }

  /// Get the achievement category for this mode
  String get achievementCategory {
    switch (this) {
      case GameMode.noob:
        return 'noob_master';
      case GameMode.pro:
        return 'pro_champion';
      case GameMode.beast:
        return 'beast_slayer';
    }
  }

  /// Get the score multiplier for this mode
  double get scoreMultiplier {
    switch (this) {
      case GameMode.noob:
        return 1.0;
      case GameMode.pro:
        return 1.5;
      case GameMode.beast:
        return 2.0;
    }
  }

  /// Check if this mode is unlocked (always true for now)
  bool get isUnlocked => true;

  /// Get the unlock condition description
  String get unlockCondition {
    switch (this) {
      case GameMode.noob:
        return 'Available from start';
      case GameMode.pro:
        return 'Complete 5 Noob mode games';
      case GameMode.beast:
        return 'Complete 10 Pro mode games';
    }
  }

  /// Get the next game mode in progression
  GameMode? get nextMode {
    switch (this) {
      case GameMode.noob:
        return GameMode.pro;
      case GameMode.pro:
        return GameMode.beast;
      case GameMode.beast:
        return null; // Highest mode
    }
  }

  /// Get the previous game mode in progression
  GameMode? get previousMode {
    switch (this) {
      case GameMode.noob:
        return null; // Lowest mode
      case GameMode.pro:
        return GameMode.noob;
      case GameMode.beast:
        return GameMode.pro;
    }
  }

  /// Get all available numbers for this mode
  List<int> get availableNumbers {
    return List.generate(maxNumber, (index) => index + 1);
  }

  /// Get all possible positions in the grid
  List<GridPosition> get allPositions {
    final positions = <GridPosition>[];
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        positions.add(GridPosition(row: row, col: col));
      }
    }
    return positions;
  }

  /// Check if a position is valid for this mode
  bool isValidPosition(int row, int col) {
    return row >= 0 && row < gridSize && col >= 0 && col < gridSize;
  }

  /// Get the box index for a given position
  int getBoxIndex(int row, int col) {
    final boxRow = row ~/ boxSize;
    final boxCol = col ~/ boxSize;
    return boxRow * boxesPerDimension + boxCol;
  }

  /// Get all positions in the same box as the given position
  List<GridPosition> getBoxPositions(int row, int col) {
    final boxIndex = getBoxIndex(row, col);
    final boxRow = boxIndex ~/ boxesPerDimension;
    final boxCol = boxIndex % boxesPerDimension;
    
    final positions = <GridPosition>[];
    for (int r = boxRow * boxSize; r < (boxRow + 1) * boxSize; r++) {
      for (int c = boxCol * boxSize; c < (boxCol + 1) * boxSize; c++) {
        positions.add(GridPosition(row: r, col: c));
      }
    }
    return positions;
  }
}

/// Represents a position in the grid
class GridPosition extends Equatable {
  final int row;
  final int col;

  const GridPosition({
    required this.row,
    required this.col,
  });

  @override
  List<Object> get props => [row, col];

  /// Get the box index for this position
  int getBoxIndex(GameMode mode) {
    return mode.getBoxIndex(row, col);
  }

  /// Get all positions in the same row
  List<GridPosition> getRowPositions(GameMode mode) {
    final positions = <GridPosition>[];
    for (int col = 0; col < mode.gridSize; col++) {
      positions.add(GridPosition(row: row, col: col));
    }
    return positions;
  }

  /// Get all positions in the same column
  List<GridPosition> getColumnPositions(GameMode mode) {
    final positions = <GridPosition>[];
    for (int row = 0; row < mode.gridSize; row++) {
      positions.add(GridPosition(row: row, col: col));
    }
    return positions;
  }

  /// Get all positions in the same box
  List<GridPosition> getBoxPositions(GameMode mode) {
    return mode.getBoxPositions(row, col);
  }

  /// Check if this position is valid for the given mode
  bool isValid(GameMode mode) {
    return mode.isValidPosition(row, col);
  }

  /// Get a string representation of this position
  String get stringRepresentation => '($row, $col)';

  /// Create a copy with new values
  GridPosition copyWith({
    int? row,
    int? col,
  }) {
    return GridPosition(
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }
}
