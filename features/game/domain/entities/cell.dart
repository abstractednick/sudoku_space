import 'package:equatable/equatable.dart';
import 'game_mode.dart';

/// Represents a cell in the Sudoku grid
class Cell extends Equatable {
  final int row;
  final int col;
  final int? value;
  final bool isEditable;
  final bool isSelected;
  final bool isInvalid;
  final bool isHint;
  final bool isGiven;
  final bool isHighlighted;
  final bool hasConflict;
  final List<int> notes;
  final DateTime? lastModified;

  const Cell({
    required this.row,
    required this.col,
    this.value,
    this.isEditable = true,
    this.isSelected = false,
    this.isInvalid = false,
    this.isHint = false,
    this.isGiven = false,
    this.isHighlighted = false,
    this.hasConflict = false,
    this.notes = const [],
    this.lastModified,
  });

  /// Create a copy of this cell with new values
  Cell copyWith({
    int? row,
    int? col,
    int? value,
    bool? isEditable,
    bool? isSelected,
    bool? isInvalid,
    bool? isHint,
    bool? isGiven,
    bool? isHighlighted,
    bool? hasConflict,
    List<int>? notes,
    DateTime? lastModified,
  }) {
    return Cell(
      row: row ?? this.row,
      col: col ?? this.col,
      value: value ?? this.value,
      isEditable: isEditable ?? this.isEditable,
      isSelected: isSelected ?? this.isSelected,
      isInvalid: isInvalid ?? this.isInvalid,
      isHint: isHint ?? this.isHint,
      isGiven: isGiven ?? this.isGiven,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      hasConflict: hasConflict ?? this.hasConflict,
      notes: notes ?? this.notes,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  /// Create a cell with a value
  Cell withValue(int newValue, {bool isGiven = false}) {
    return copyWith(
      value: newValue,
      isGiven: isGiven,
      isEditable: !isGiven,
      lastModified: DateTime.now(),
    );
  }

  /// Create an empty cell
  Cell empty() {
    return copyWith(
      value: null,
      isInvalid: false,
      isHint: false,
      hasConflict: false,
      notes: [],
      lastModified: DateTime.now(),
    );
  }

  /// Create a selected cell
  Cell selected() {
    return copyWith(
      isSelected: true,
    );
  }

  /// Create an unselected cell
  Cell unselected() {
    return copyWith(
      isSelected: false,
    );
  }

  /// Create a highlighted cell
  Cell highlighted() {
    return copyWith(
      isHighlighted: true,
    );
  }

  /// Create an unhighlighted cell
  Cell unhighlighted() {
    return copyWith(
      isHighlighted: false,
    );
  }

  /// Create an invalid cell
  Cell invalid() {
    return copyWith(
      isInvalid: true,
    );
  }

  /// Create a valid cell
  Cell valid() {
    return copyWith(
      isInvalid: false,
    );
  }

  /// Create a cell with conflict
  Cell withConflict() {
    return copyWith(
      hasConflict: true,
    );
  }

  /// Create a cell without conflict
  Cell withoutConflict() {
    return copyWith(
      hasConflict: false,
    );
  }

  /// Add a note to the cell
  Cell addNote(int note) {
    if (notes.contains(note)) {
      return this;
    }
    final newNotes = List<int>.from(notes)..add(note);
    return copyWith(
      notes: newNotes,
      lastModified: DateTime.now(),
    );
  }

  /// Remove a note from the cell
  Cell removeNote(int note) {
    if (!notes.contains(note)) {
      return this;
    }
    final newNotes = List<int>.from(notes)..remove(note);
    return copyWith(
      notes: newNotes,
      lastModified: DateTime.now(),
    );
  }

  /// Clear all notes
  Cell clearNotes() {
    return copyWith(
      notes: [],
      lastModified: DateTime.now(),
    );
  }

  /// Toggle a note
  Cell toggleNote(int note) {
    if (notes.contains(note)) {
      return removeNote(note);
    } else {
      return addNote(note);
    }
  }

  /// Check if the cell has a specific note
  bool hasNote(int note) {
    return notes.contains(note);
  }

  /// Check if the cell is empty
  bool get isEmpty => value == null;

  /// Check if the cell has a value
  bool get hasValue => value != null;

  /// Check if the cell is filled
  bool get isFilled => hasValue;

  /// Check if the cell can be edited
  bool get canEdit => isEditable && !isGiven;

  /// Check if the cell is in a valid state
  bool get isValid => !isInvalid && !hasConflict;

  /// Check if the cell is in an invalid state
  bool get isInErrorState => isInvalid || hasConflict;

  /// Get the display value for the cell
  String get displayValue {
    if (hasValue) {
      return value.toString();
    }
    return '';
  }

  /// Get the position of this cell
  GridPosition get position => GridPosition(row: row, col: col);

  /// Get the box index for this cell
  int getBoxIndex(GameMode mode) {
    return mode.getBoxIndex(row, col);
  }

  /// Check if this cell is in the same row as another cell
  bool isSameRow(Cell other) {
    return row == other.row;
  }

  /// Check if this cell is in the same column as another cell
  bool isSameColumn(Cell other) {
    return col == other.col;
  }

  /// Check if this cell is in the same box as another cell
  bool isSameBox(Cell other, GameMode mode) {
    return getBoxIndex(mode) == other.getBoxIndex(mode);
  }

  /// Check if this cell conflicts with another cell
  bool conflictsWith(Cell other, GameMode mode) {
    if (!hasValue || !other.hasValue) {
      return false;
    }
    
    if (value != other.value) {
      return false;
    }

    // Same value, check if they're in conflict
    return isSameRow(other) || isSameColumn(other) || isSameBox(other, mode);
  }

  /// Get all possible values for this cell based on game mode
  List<int> getPossibleValues(GameMode mode) {
    return mode.availableNumbers;
  }

  /// Check if a value is valid for this cell
  bool isValidValue(int value, GameMode mode) {
    return mode.availableNumbers.contains(value);
  }

  /// Get the notes as a sorted list
  List<int> get sortedNotes {
    final sortedNotes = List<int>.from(notes);
    sortedNotes.sort();
    return sortedNotes;
  }

  /// Get the notes as a string representation
  String get notesString {
    if (notes.isEmpty) {
      return '';
    }
    return sortedNotes.join(', ');
  }

  /// Check if this cell has any notes
  bool get hasNotes => notes.isNotEmpty;

  /// Get the number of notes
  int get notesCount => notes.length;

  /// Check if this cell is a hint cell
  bool get isHintCell => isHint;

  /// Check if this cell was given in the initial puzzle
  bool get isGivenCell => isGiven;

  /// Check if this cell was filled by the user
  bool get isUserFilled => hasValue && !isGiven;

  /// Get the age of the last modification in seconds
  int get ageInSeconds {
    if (lastModified == null) {
      return 0;
    }
    return DateTime.now().difference(lastModified!).inSeconds;
  }

  /// Check if this cell was recently modified (within last 5 seconds)
  bool get wasRecentlyModified => ageInSeconds <= 5;

  /// Create a deep copy of this cell
  Cell deepCopy() {
    return Cell(
      row: row,
      col: col,
      value: value,
      isEditable: isEditable,
      isSelected: isSelected,
      isInvalid: isInvalid,
      isHint: isHint,
      isGiven: isGiven,
      isHighlighted: isHighlighted,
      hasConflict: hasConflict,
      notes: List<int>.from(notes),
      lastModified: lastModified,
    );
  }

  /// Create a cell from JSON
  factory Cell.fromJson(Map<String, dynamic> json) {
    return Cell(
      row: json['row'] as int,
      col: json['col'] as int,
      value: json['value'] as int?,
      isEditable: json['isEditable'] as bool? ?? true,
      isSelected: json['isSelected'] as bool? ?? false,
      isInvalid: json['isInvalid'] as bool? ?? false,
      isHint: json['isHint'] as bool? ?? false,
      isGiven: json['isGiven'] as bool? ?? false,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
      hasConflict: json['hasConflict'] as bool? ?? false,
      notes: (json['notes'] as List<dynamic>?)?.cast<int>() ?? [],
      lastModified: json['lastModified'] != null 
          ? DateTime.parse(json['lastModified'] as String)
          : null,
    );
  }

  /// Convert cell to JSON
  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'col': col,
      'value': value,
      'isEditable': isEditable,
      'isSelected': isSelected,
      'isInvalid': isInvalid,
      'isHint': isHint,
      'isGiven': isGiven,
      'isHighlighted': isHighlighted,
      'hasConflict': hasConflict,
      'notes': notes,
      'lastModified': lastModified?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    row,
    col,
    value,
    isEditable,
    isSelected,
    isInvalid,
    isHint,
    isGiven,
    isHighlighted,
    hasConflict,
    notes,
    lastModified,
  ];

  @override
  String toString() {
    return 'Cell($row, $col): ${value ?? "empty"} ${isGiven ? "[given]" : ""} ${isSelected ? "[selected]" : ""} ${isInvalid ? "[invalid]" : ""} ${hasConflict ? "[conflict]" : ""}';
  }
}
