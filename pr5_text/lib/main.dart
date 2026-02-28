import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PR5 Text',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final 
   _textController = TextEditingController();
  final List<String> _notes = [];
  int? _editingIndex; // Индекс редактируемой заметки

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      if (_editingIndex != null) {
        // Обновление существующей
        _notes[_editingIndex!] = _textController.text;
        _editingIndex = null;
      } else {
        // Создание новой
        _notes.add(_textController.text);
      }
      _textController.clear();
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
      // Если удалили редактируемую заметку, сбрасываем режим редактирования
      if (_editingIndex == index) {
        _editingIndex = null;
        _textController.clear();
      } else if (_editingIndex != null && index < _editingIndex!) {
        // Корректировка индекса редактирования, если удалён элемент выше
        _editingIndex = _editingIndex! - 1;
      }
    });
  }

  void _editNote(int index) {
    setState(() {
      _editingIndex = index;
      _textController.text = _notes[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле ввода и кнопка
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: _editingIndex != null
                          ? 'Редактировать заметку'
                          : 'Введите заметку',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _saveNote,
                  child: Text(_editingIndex != null ? 'Обновить' : 'Сохранить'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Список заметок
            Expanded(
              child: _notes.isEmpty
                  ? const Center(child: Text('Нет заметок'))
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(_notes[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editNote(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteNote(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
