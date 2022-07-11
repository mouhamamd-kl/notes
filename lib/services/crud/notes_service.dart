import 'package:flutter/cupertino.dart';
import 'package:notes/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class NoteService {
  Database? _db;
  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();
    await getnote(id: note.id);
    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWitCloudColumn: 0,
    });
    if (updatesCount == 0) {
      throw CoudldNotupdateNote();
    } else {
      return await getnote(id: note.id);
    }
  }

  Future<Iterable<DatabaseNote>> getallnote() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> getnote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id=?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CoudldNotFindNote();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  Future<int> deleteallnote() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      noteTable,
      where: 'id=?',
      whereArgs: [id],
    );
    if (deleteCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    //make sure owner exists in the data base with the correct id

    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    const text = '';
    //create the note
    final noteid = await db.insert(
      noteTable,
      {userIdColumn: owner.id, textColumn: text, isSyncedWitCloudColumn: 1},
    );
    final note = DatabaseNote(
      id: noteid,
      isSyncedWitCloud: true,
      text: text,
      userId: owner.id,
    );
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userID =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});
    return DatabaseUser(email: email, id: userID);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw Couldnotdeleteuser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docspath = await getApplicationDocumentsDirectory();
      final dbpath = join(docspath.path, dbName);
      final db = await openDatabase(dbpath);
      _db = db;
      await db.execute(CreateUserTable);

      await db.execute(CreateNotesTable);
    } on MissingPlatformDirectoryException {
      throw UnabletoGetDocumentsdirecotyr();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.email,
    required this.id,
  });
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person,ID=$id,email=$email';

  @override
  operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWitCloud;

  DatabaseNote({
    required this.id,
    required this.isSyncedWitCloud,
    required this.text,
    required this.userId,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWitCloud =
            (map[isSyncedWitCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note , ID=$id,userID=$userId,isSyncedWithCloud=$isSyncedWitCloud';
  @override
  operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = "note";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const isSyncedWitCloudColumn = "is_synced_with_cloud";
const CreateNotesTable = ''' 
        CREATE TABLE "note" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT NOT NULL,
        "is_synced_with_cloud"	INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
            ''';
const CreateUserTable = '''  CREATE TABLE IF NOT EXISTS "user" (
	        "id"	INTEGER NOT NULL,
	        "email"	TEXT NOT NULL UNIQUE,
          	PRIMARY KEY("id" AUTOINCREMENT)
            );
            ''';
