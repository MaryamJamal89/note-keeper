class Note {
  final int? noteId;
  final bool isImportant;
  final int number;
  final String noteTitle;
  final String noteText;
  final DateTime noteDate;

  Note({
    this.noteId, 
    required this.isImportant, 
    required this.number, 
    required this.noteTitle, 
    required this.noteText, 
    required this.noteDate
    });

  Map<String, dynamic> toMap() => {
    'noteId': noteId, 
    'isImportant': isImportant, 
    'number': number, 
    'noteTitle': noteTitle, 
    'noteText': noteText, 
    'noteDate': noteDate
    };

  Note.fromMap(Map<String, dynamic> map) {
    noteId = map['noteId'];
    isImportant = map['isImportant'];
    number = map['number'];
    noteTitle = map['noteTitle'];
    noteText = map['noteText'];
    noteDate = map['noteDate'];
  }
}
