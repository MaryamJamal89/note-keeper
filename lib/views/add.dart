import 'package:flutter/material.dart';
import 'package:lab6v2/views/home.dart';

import '../local/db/db_helper.dart';
import '../model/note.dart';
import '../util/date_time_manager.dart';
import 'noteform.dart';

class AddNote extends StatefulWidget {
  final Note? note;

  const AddNote({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _noteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? title = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _noteController.dispose();
    title = widget.note?.noteText ?? '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          title: title,
          onChangedTitle: (title) => setState(() => this.title = title),
        ),
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = title?.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.amber,
        ),
        onPressed: addOrUpdateNote,
        child: Text(
          'Save',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = new Note(
      noteId: widget.note!.noteId,
      noteDate: DateTimeManager.getCurrentDate(),
      noteText: title,
    );
    await DbHelper.helper.updateDb(note);
  }

  Future addNote() async {
    final note = Note(
      noteText: title,
      noteDate: DateTimeManager.getCurrentDate(),
    );

    await DbHelper.helper.insertDb(note);
  }
}
