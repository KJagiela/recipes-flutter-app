import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'add_ingredients.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {'ingredients': [], 'steps': null};
  final Map<String, dynamic> _rowData = {'amount': null, 'unit': null, 'name': null};
  Map<String, dynamic> _currentRowData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kasia\'s Recipe app'),
      ),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildIngredientsRow(),  // TODO: move to next field by clicking 'next'
          _buildIngredientsRow(),  // TODO: add dynamically
          _buildStepsInput(),  // TODO: validation (extract to a component?)
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildIngredientsRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: 'Amount'),
              validator: (String? value) {
                if (value!.isEmpty) return 'Incorrect amount';
                if (int.parse(value) <= 0) return 'Must be a positive number';
              },
              onSaved: (String? value) {
                _currentRowData = Map.from(_rowData);
                _currentRowData['amount'] = int.parse(value!);
              },
            ),
            flex: 2,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Unit'),
              onSaved: (String? value) {
                _currentRowData['unit'] = value;
              },
            ),
            flex: 2,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Ingredient'),
              onSaved: (String? value) {
                _currentRowData['name'] = value;
                _formData['ingredients'].add(_currentRowData);
              },
            ),
            flex: 6,
          )
        ]
      )
    );
  }

  Widget _buildStepsInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Directions'),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onSaved: (String? value) {
          _formData['steps'] = value;
        },
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () { _submitForm(context); },
        child: Text('SEND'),
      ),
    );
  }

  void _showMissingIngredientsDialog(
      BuildContext context,
      List missingIngredients,
  ) {
    showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Some of the ingredients are missing'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _getMissingIngredientsDisplay(missingIngredients),
            ),
          ),
        );
      }
    );
  }

  List<Widget> _getMissingIngredientsDisplay(missingIngredients){
    List<Widget> ingredientsDisplay = [];
    missingIngredients.map((ingredient) => ingredientsDisplay.add(
        AddIngredient(name: ingredient)
    )).toList();
    return ingredientsDisplay;
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      List backendData = await _postDataToBackend();
      int statusCode = backendData[0];
      if (statusCode == 428) {
        _showMissingIngredientsDialog(context, backendData[1]['missing_ingredients']);
      }
      _formData = {'ingredients': [], 'steps': null};
    }
  }

  Future<List> _postDataToBackend() async {
    final url = Uri.http('10.0.2.2:8000', 'recipes/');
    http.Response response = await http.post(
      url,
      body:jsonEncode(_formData),
      headers: {
        HttpHeaders.authorizationHeader: 'Basic a2FzaWE6a2FzaWE=',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
      }
    );
    return [response.statusCode, jsonDecode(response.body)];
  }
}