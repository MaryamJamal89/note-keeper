import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/note.dart';
import 'constants.dart';

class DbHelper {
  //private named constructor
  DbHelper._instance();

  //single instance
  static final DbHelper helper = DbHelper._instance();

  //to get note db path
  Future<String> _getDbPath() async {
    String dbPath = await getDatabasesPath();
    String noteDb = join(dbPath, DB_NAME);
    return noteDb;
  }

  //get get instance from db
  Future<Database> getDbInstance() async {
    String path = await _getDbPath();
    return openDatabase(path,
        version: DB_VERSION, onCreate: (db, version) => _onCreate(db));
  }

  void _onCreate(Database db) {
    String sql =
        'create table $TABLE_NAME ($COL_NOTE_ID integer primary key autoincrement, $COL_NOTE_TEXT text, $COL_NOTE_DATE text)';
    db.execute(sql);
  }

  Future<int> insertDb(Note note) async {
    Database db = await getDbInstance();
    return db.insert(TABLE_NAME, note.toMap());
  }

  Future<List<Note>> selectNotes() async {
    Database db = await getDbInstance();
    List<Map<String, dynamic>> query =
        await db.query(TABLE_NAME, orderBy: '$COL_NOTE_DATE desc');
    return query.map((e) => Note.fromMap(e)).toList();
  }
   Future<Note> readNote(int? noteId) async {
    Database db = await getDbInstance();
    final query = await db.query(
      TABLE_NAME,
      where: '${COL_NOTE_ID} = ?',
      whereArgs: [noteId],
    );

    if (query.isNotEmpty) {
      return Note.fromMap(query.first);
    } else {
      throw Exception('ID $noteId not found');
    }
  }

  Future<int> deleteFromDb(int? noteId) async {
    Database db = await getDbInstance();
    return db.delete(TABLE_NAME,where: '$COL_NOTE_ID=?',whereArgs: [noteId]);
  }

  Future<int> updateDb(Note note) async{
    Database db = await getDbInstance();
    return db.update(TABLE_NAME, note.toMap(),where:'$COL_NOTE_ID=?',whereArgs: [note.noteId]);

  }
}
