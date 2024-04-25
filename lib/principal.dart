import 'package:flutter/material.dart';
import 'package:fluttersql/database/bd.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  //All journals
  List<Map<String, dynamic>> _lista = [];

  bool _isLoading = true;

  // this function is used to fetch all data from the database
  void _refreshTutorial() async {
    final data = await SqlDb.buscarTodos();
    setState(() {
      _lista = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTutorial(); //Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingTutorial =
          _lista.firstWhere((element) => element['id'] == id);
      _titleController.text = existingTutorial['title'];
      _descriptionController.text = existingTutorial['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        backgroundColor: Colors.white70,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                //this will prevent the soft keyboard from covering the next fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ), // TextField

                  const SizedBox(
                    height: 10,
                  ), // SizedBox
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Descripton'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //save new tutorial
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }
                      // Clear the text fields
                      _titleController.text = '';
                      _descriptionController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Novo' : 'Alterar'),
                  ) // ElevatedButton
                ],
              ), // Column
            )); // Container
  }

  // Insert a new to the database
  Future<void> _addItem() async {
    await SqlDb.insert(_titleController.text, _descriptionController.text);
    _refreshTutorial();
  }

  // Update an existing
  Future<void> _updateItem(int id) async {
    await SqlDb.atualizaItem(
        id, _titleController.text, _descriptionController.text);
    _refreshTutorial();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SqlDb.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Tutorial deletado com sucesso!'),
    )); // SnackBar
    _refreshTutorial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APLICAÇÃO COM SQLITE'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ), // AppBar
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Center
          : ListView.builder(
              itemCount: _lista.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    title: Text(_lista[index]['title']),
                    subtitle: Text(_lista[index]['description']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(_lista[index]['id']),
                          ), // IconButton
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteItem(_lista[index]['id']),
                          ),
                        ], // IconButton
                      ), // Row
                    )), // SizedBox, ListTile
              ), // Card
            ), // ListView.builder
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
        onPressed: () => _showForm(null),
      ),
    );
  }
}
