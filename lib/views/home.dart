import 'package:flutter/material.dart';
import 'package:lab6v2/views/add.dart';

import '../local/db/db_helper.dart';
import '../model/note.dart';
import 'NoteCardWidget.dart';
import 'note_details.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> noteList = [];
  Note futureNote = Note();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : noteList.isEmpty
              ? Center(
                  child: Text(
                    'Empty Stack',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                )
              : buildNotes(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddNote(),
          ));
          getNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void getNotes() {
    setState(() => isLoading = true);
    DbHelper.helper.selectNotes().then((value) {
      setState(() {
        noteList = value;
        isLoading = false;
      });
    });
  }

  void deleteNote(int noteId) {
    DbHelper.helper.deleteFromDb(noteId).then((value) =>
        value > 0 ? print('Note deleted') : print('something went wrong'));
    getNotes();
  }

  void updateNote(Note note) {
    DbHelper.helper.updateDb(note).then((value) =>
        value > 0 ? print('Note updated') : print('something went wrong'));
    getNotes();
  }

  Widget buildNotes() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
            itemCount: noteList.length,
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          NoteDetailPage(noteId: noteList[index].noteId),
                    ));
                    getNotes();
                  },
                  child: NoteCardWidget(note: noteList[index], index: index),
                )),
      );

  openEditDialog(Note note) {
    GlobalKey<FormState> _dialogFormKey = GlobalKey();
    TextEditingController _editController =
        TextEditingController(text: note.noteText);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Update Note'),
              content: SizedBox(
                height: 130,
                child: Form(
                  key: _dialogFormKey,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (value) =>
                        value!.isEmpty ? 'Write your note' : null,
                    controller: _editController,
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                const SizedBox(
                  width: 8,
                ),
                TextButton(
                    onPressed: () {
                      if (_dialogFormKey.currentState!.validate()) {
                        String newText = _editController.value.text;
                        note.noteText = newText;
                        updateNote(note);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Update'))
              ],
            ));
  }
}
