import 'package:equatable/equatable.dart';
import 'cell.dart';
import 'game_mode.dart';

/// Game status enumeration
enum GameStatus {
  notStarted,
  playing,
  paused,
  completed,
  failed,
  abandoned,
}

/// Difficulty level for puzzle generation
enum DifficultyLevel {
  easy,
  medium,
  hard,
}

/// Represents the complete Sudoku game state
class SudokuGame extends Equatable {
  final String id;
  final GameMode mode;
  final DifficultyLevel difficulty;
  final GameStatus status;
  final List<List<Cell>> grid;
  final int mistakes;
  final int hints;
  final int score;
  final int elapsedTime; // in seconds
  final DateTime startTime;
  final DateTime? endTime;
  final GridPosition? selectedPosition;
  final List<GridPosition> highlightedPositions;
  final List<Cell> moveHistory;
  final int historyIndex;
  final bool notesMode;
  final Map<String, dynamic> metadata;

  const SudokuGame({
    required this.id,
    required this.mode,
    required this.difficulty,
    this.status = GameStatus.notStarted,
    required this.grid,
    this.mistakes = 0,
    this.hints = 0,
    this.score = 0,
    this.elapsedTime = 0,
    required this.startTime,
    this.endTime,
    this.selectedPosition,
    this.highlightedPositions = const [],
    this.moveHistory = const [],
    this.historyIndex = -1,
    this.notesMode = false,
    this.metadata = const {},
  });

  /// Create a new game with the specified mode and difficulty
  factory SudokuGame.create({
    required GameMode mode,
    required DifficultyLevel difficulty,
    List<List<Cell>>? initialGrid,
  }) {
    final now = DateTime.now();
    final grid = initialGrid ?? _createEmptyGrid(mode);
    
    return SudokuGame(
      id: _generateGameId(),
      mode: mode,
      difficulty: difficulty,
      status: GameStatus.notStarted,
      grid: grid,
      startTime: now,
      metadata: {
        'createdAt': now.toIso8601String(),
        'version': '1.0.0',
      },
    );
  }

  /// Create an empty grid for the given mode
  static List<List<Cell>> _createEmptyGrid(GameMode mode) {
    final grid = <List<Cell>>[];
    for (int row = 0; row < mode.gridSize; row++) {
      final rowCells = <Cell>[];
      for (int col = 0; col < mode.gridSize; col++) {
        rowCells.add(Cell(row: row, col: col));
      }
      grid.add(rowCells);
    }
    return grid;
  }

  /// Generate a unique game ID
  static String _generateGameId() {
    final now = DateTime.now();
    return 'game_${now.millisecondsSinceEpoch}_${now.microsecond}';
  }

  /// Start the game
  SudokuGame start() {
    return copyWith(
      status: GameStatus.playing,
      startTime: DateTime.now(),
    );
  }

  /// Pause the game
  SudokuGame pause() {
    return copyWith(
      status: GameStatus.paused,
    );
  }

  /// Resume the game
  SudokuGame resume() {
    return copyWith(
      status: GameStatus.playing,
    );
  }

  /// Complete the game
  SudokuGame complete({int? finalScore}) {
    final now = DateTime.now();
    final finalElapsedTime = elapsedTime + now.difference(startTime).inSeconds;
    
    return copyWith(
      status: GameStatus.completed,
      endTime: now,
      elapsedTime: finalElapsedTime,
      score: finalScore ?? _calculateScore(),
    );
  }

  /// Fail the game
  SudokuGame fail() {
    final now = DateTime.now();
    final finalElapsedTime = elapsedTime + now.difference(startTime).inSeconds;
    
    return copyWith(
      status: GameStatus.failed,
      endTime: now,
      elapsedTime: finalElapsedTime,
    );
  }

  /// Abandon the game
  SudokuGame abandon() {
    final now = DateTime.now();
    final finalElapsedTime = elapsedTime + now.difference(startTime).inSeconds;
    
    return copyWith(
      status: GameStatus.abandoned,
      endTime: now,
      elapsedTime: finalElapsedTime,
    );
  }

  /// Update the grid with a new cell
  SudokuGame updateCell(Cell newCell) {
    final newGrid = _copyGrid();
    newGrid[newCell.row][newCell.col] = newCell;
    
    // Add to move history
    final newHistory = List<Cell>.from(moveHistory);
    newHistory.add(newCell);
    
    return copyWith(
      grid: newGrid,
      moveHistory: newHistory,
      historyIndex: newHistory.length - 1,
    );
  }

  /// Update multiple cells at once
  SudokuGame updateCells(List<Cell> cells) {
    final newGrid = _copyGrid();
    final newHistory = List<Cell>.from(moveHistory);
    
    for (final cell in cells) {
      newGrid[cell.row][cell.col] = cell;
      newHistory.add(cell);
    }
    
    return copyWith(
      grid: newGrid,
      moveHistory: newHistory,
      historyIndex: newHistory.length - 1,
    );
  }

  /// Select a cell at the given position
  SudokuGame selectCell(int row, int col) {
    final newGrid = _copyGrid();
    
    // Deselect all cells
    for (int r = 0; r < mode.gridSize; r++) {
      for (int c = 0; c < mode.gridSize; c++) {
        newGrid[r][c] = newGrid[r][c].unselected();
      }
    }
    
    // Select the specified cell
    newGrid[row][col] = newGrid[row][col].selected();
    
    return copyWith(
      grid: newGrid,
      selectedPosition: GridPosition(row: row, col: col),
    );
  }

  /// Clear selection
  SudokuGame clearSelection() {
    final newGrid = _copyGrid();
    
    for (int r = 0; r < mode.gridSize; r++) {
      for (int c = 0; c < mode.gridSize; c++) {
        newGrid[r][c] = newGrid[r][c].unselected();
      }
    }
    
    return copyWith(
      grid: newGrid,
      selectedPosition: null,
    );
  }

  /// Highlight cells with the same value
  SudokuGame highlightCellsWithValue(int value) {
    final newGrid = _copyGrid();
    final highlightedPositions = <GridPosition>[];
    
    for (int r = 0; r < mode.gridSize; r++) {
      for (int c = 0; c < mode.gridSize; c++) {
        final cell = newGrid[r][c];
        if (cell.value == value) {
          newGrid[r][c] = cell.highlighted();
          highlightedPositions.add(GridPosition(row: r, col: c));
        } else {
          newGrid[r][c] = cell.unhighlighted();
        }
      }
    }
    
    return copyWith(
      grid: newGrid,
      highlightedPositions: highlightedPositions,
    );
  }

  /// Clear highlights
  SudokuGame clearHighlights() {
    final newGrid = _copyGrid();
    
    for (int r = 0; r < mode.gridSize; r++) {
      for (int c = 0; c < mode.gridSize; c++) {
        newGrid[r][c] = newGrid[r][c].unhighlighted();
      }
    }
    
    return copyWith(
      grid: newGrid,
      highlightedPositions: [],
    );
  }

  /// Add a mistake
  SudokuGame addMistake() {
    return copyWith(mistakes: mistakes + 1);
  }

  /// Use a hint
  SudokuGame useHint() {
    return copyWith(hints: hints + 1);
  }

  /// Update elapsed time
  SudokuGame updateElapsedTime(int newElapsedTime) {
    return copyWith(elapsedTime: newElapsedTime);
  }

  /// Toggle notes mode
  SudokuGame toggleNotesMode() {
    return copyWith(notesMode: !notesMode);
  }

  /// Undo the last move
  SudokuGame undo() {
    if (historyIndex < 0 || moveHistory.isEmpty) {
      return this;
    }
    
    final newGrid = _copyGrid();
    final cellToUndo = moveHistory[historyIndex];
    newGrid[cellToUndo.row][cellToUndo.col] = newGrid[cellToUndo.row][cellToUndo.col].empty();
    
    return copyWith(
      grid: newGrid,
      historyIndex: historyIndex - 1,
    );
  }

  /// Redo the next move
  SudokuGame redo() {
    if (historyIndex >= moveHistory.length - 1) {
      return this;
    }
    
    final newGrid = _copyGrid();
    final cellToRedo = moveHistory[historyIndex + 1];
    newGrid[cellToRedo.row][cellToRedo.col] = cellToRedo;
    
    return copyWith(
      grid: newGrid,
      historyIndex: historyIndex + 1,
    );
  }

  /// Check if the game is completed
  bool get isCompleted => status == GameStatus.completed;

  /// Check if the game is playing
  bool get isPlaying => status == GameStatus.playing;

  /// Check if the game is paused
  bool get isPaused => status == GameStatus.paused;

  /// Check if the game is finished (completed or failed)
  bool get isFinished => status == GameStatus.completed || status == GameStatus.failed;

  /// Check if the game has reached maximum mistakes
  bool get hasReachedMaxMistakes => mistakes >= mode.maxMistakes;

  /// Check if hints are available
  bool get hasHintsAvailable => hints < mode.maxHints;

  /// Check if time limit is reached
  bool get isTimeLimitReached {
    if (!mode.hasTimeLimit) return false;
    return elapsedTime >= mode.timeLimit;
  }

  /// Check if the grid is complete and valid
  bool get isGridComplete {
    for (int row = 0; row < mode.gridSize; row++) {
      for (int col = 0; col < mode.gridSize; col++) {
        final cell = grid[row][col];
        if (cell.isEmpty || cell.isInvalid || cell.hasConflict) {
          return false;
        }
      }
    }
    return true;
  }

  /// Get the completion percentage
  double get completionPercentage {
    int filledCells = 0;
    for (int row = 0; row < mode.gridSize; row++) {
      for (int col = 0; col < mode.gridSize; col++) {
        if (grid[row][col].hasValue && grid[row][col].isValid) {
          filledCells++;
        }
      }
    }
    return (filledCells / mode.totalCells) * 100;
  }

  /// Get the selected cell
  Cell? get selectedCell {
    if (selectedPosition == null) return null;
    return grid[selectedPosition!.row][selectedPosition!.col];
  }

  /// Check if undo is available
  bool get canUndo => historyIndex >= 0 && moveHistory.isNotEmpty;

  /// Check if redo is available
  bool get canRedo => historyIndex < moveHistory.length - 1;

  /// Get the current game duration
  Duration get currentDuration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return DateTime.now().difference(startTime);
  }

  /// Get the formatted elapsed time
  String get formattedElapsedTime {
    final duration = Duration(seconds: elapsedTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Calculate the final score
  int _calculateScore() {
    int baseScore = 1000;
    int timeBonus = 0;
    int mistakePenalty = mistakes * 50;
    int hintPenalty = hints * 25;
    
    if (mode.hasTimeLimit) {
      final remainingTime = mode.timeLimit - elapsedTime;
      timeBonus = remainingTime > 0 ? remainingTime ~/ 10 : 0;
    }
    
    final finalScore = baseScore + timeBonus - mistakePenalty - hintPenalty;
    return (finalScore * mode.scoreMultiplier).round().clamp(0, 9999);
  }

  /// Create a deep copy of the grid
  List<List<Cell>> _copyGrid() {
    return grid.map((row) => row.map((cell) => cell.deepCopy()).toList()).toList();
  }

  /// Create a copy of this game with new values
  SudokuGame copyWith({
    String? id,
    GameMode? mode,
    DifficultyLevel? difficulty,
    GameStatus? status,
    List<List<Cell>>? grid,
    int? mistakes,
    int? hints,
    int? score,
    int? elapsedTime,
    DateTime? startTime,
    DateTime? endTime,
    GridPosition? selectedPosition,
    List<GridPosition>? highlightedPositions,
    List<Cell>? moveHistory,
    int? historyIndex,
    bool? notesMode,
    Map<String, dynamic>? metadata,
  }) {
    return SudokuGame(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      grid: grid ?? this.grid,
      mistakes: mistakes ?? this.mistakes,
      hints: hints ?? this.hints,
      score: score ?? this.score,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      selectedPosition: selectedPosition ?? this.selectedPosition,
      highlightedPositions: highlightedPositions ?? this.highlightedPositions,
      moveHistory: moveHistory ?? this.moveHistory,
      historyIndex: historyIndex ?? this.historyIndex,
      notesMode: notesMode ?? this.notesMode,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Create a game from JSON
  factory SudokuGame.fromJson(Map<String, dynamic> json) {
    final gridData = json['grid'] as List<dynamic>;
    final grid = gridData.map((rowData) {
      return (rowData as List<dynamic>).map((cellData) {
        return Cell.fromJson(cellData as Map<String, dynamic>);
      }).toList();
    }).toList();

    return SudokuGame(
      id: json['id'] as String,
      mode: GameMode.values.firstWhere((m) => m.name == json['mode']),
      difficulty: DifficultyLevel.values.firstWhere((d) => d.name == json['difficulty']),
      status: GameStatus.values.firstWhere((s) => s.name == json['status']),
      grid: grid,
      mistakes: json['mistakes'] as int,
      hints: json['hints'] as int,
      score: json['score'] as int,
      elapsedTime: json['elapsedTime'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      selectedPosition: json['selectedPosition'] != null 
          ? GridPosition(row: json['selectedPosition']['row'], col: json['selectedPosition']['col'])
          : null,
      highlightedPositions: (json['highlightedPositions'] as List<dynamic>?)
          ?.map((pos) => GridPosition(row: pos['row'], col: pos['col']))
          .toList() ?? [],
      moveHistory: (json['moveHistory'] as List<dynamic>?)
          ?.map((cell) => Cell.fromJson(cell as Map<String, dynamic>))
          .toList() ?? [],
      historyIndex: json['historyIndex'] as int,
      notesMode: json['notesMode'] as bool,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  /// Convert game to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode': mode.name,
      'difficulty': difficulty.name,
      'status': status.name,
      'grid': grid.map((row) => row.map((cell) => cell.toJson()).toList()).toList(),
      'mistakes': mistakes,
      'hints': hints,
      'score': score,
      'elapsedTime': elapsedTime,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'selectedPosition': selectedPosition != null 
          ? {'row': selectedPosition!.row, 'col': selectedPosition!.col}
          : null,
      'highlightedPositions': highlightedPositions.map((pos) => {'row': pos.row, 'col': pos.col}).toList(),
      'moveHistory': moveHistory.map((cell) => cell.toJson()).toList(),
      'historyIndex': historyIndex,
      'notesMode': notesMode,
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
    id,
    mode,
    difficulty,
    status,
    grid,
    mistakes,
    hints,
    score,
    elapsedTime,
    startTime,
    endTime,
    selectedPosition,
    highlightedPositions,
    moveHistory,
    historyIndex,
    notesMode,
    metadata,
  ];

  @override
  String toString() {
    return 'SudokuGame($mode, $difficulty, $status): ${completionPercentage.toStringAsFixed(1)}% complete, $mistakes mistakes, $hints hints';
  }
}
