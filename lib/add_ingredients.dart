import 'package:flutter/material.dart';


class AddIngredient extends StatefulWidget {

  final String name;

  const AddIngredient({Key? key, required this.name}) : super(key: key);

  @override
  _AddIngredientState createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  final _formKey = GlobalKey<FormState>();
  final _ingredientData = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildIngredientName(),
            _buildIngredientCategory(),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientName() {
    return Expanded(
        child: TextFormField(
          initialValue: widget.name,
          decoration: InputDecoration(labelText: 'Name'),
          onSaved: (String? value) {
            _ingredientData['ingredient'] = value;
          },
        ),
      flex: 2,
    );
  }

  Widget _buildIngredientCategory() {
    return Expanded(
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Category'),
          onSaved: (String? value) {
            _ingredientData['category'] = value;
          },
        ),
      flex: 2,
    );
  }


}
