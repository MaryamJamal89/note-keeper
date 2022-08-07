import 'package:flutter/material.dart';
import 'package:lab6v2/local/db/db_helper.dart';
import '../model/note.dart';
import 'add.dart';

class NoteDetailPage extends StatefulWidget {
  int? noteId;

  NoteDetailPage({
    Key? key,
    this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getNote();
  }

  Future getNote() async {
    setState(() => isLoading = true);
    this.note = await DbHelper.helper
        .readNote(widget.noteId)
        .then((value) => this.note = value);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      '${note.noteText}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${note.noteDate}',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddNote(note: note),
        ));

        getNote();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await DbHelper.helper.deleteFromDb(widget.noteId);
          Navigator.of(context).pop();
        },
      );
}
