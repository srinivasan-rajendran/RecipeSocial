import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class GroceryItemScreen extends StatefulWidget {
  final Function(GroceryItem) onCreate;
  final Function(GroceryItem) onUpdate;
  final GroceryItem? originalItem;
  final bool isUpdating;

  const GroceryItemScreen(
      {Key? key,
      required this.onCreate,
      required this.onUpdate,
      this.originalItem})
      : isUpdating = (originalItem != null),
        super(key: key);

  @override
  _GroceryItemScreenState createState() => _GroceryItemScreenState();
}

class _GroceryItemScreenState extends State<GroceryItemScreen> {
  final _nameController = TextEditingController();
  String _name = '';
  Importance _importance = Importance.low;
  DateTime _dueDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green;
  int _currentSliderValue = 0;

  @override
  void initState() {
    final originalItem = widget.originalItem;
    if (originalItem != null) {
      _nameController.text = originalItem.name;
      _name = originalItem.name;
      _currentSliderValue = originalItem.quantity;
      _importance = originalItem.importance;
      _currentColor = originalItem.color;
      final date = originalItem.date;
      _timeOfDay = TimeOfDay(hour: date.hour, minute: date.minute);
      _dueDate = date;
    }

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // TODO: add callback handler
            },
          )
        ],
        elevation: 0.0, // removes the shadow from the app bar
        title: Text(
          'Grocery Item',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildNameField(),
            buildImportanceField(),
            buildDateField(),
            buildTimeField(),
            // add color picker
            // add slider
            // aadd grocery title
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Name',
          style: GoogleFonts.lato(fontSize: 28),
        ),
        TextField(
          controller: _nameController,
          cursorColor: _currentColor,
          decoration: InputDecoration(
              hintText: 'Eg. Apples, Oranges, Banana, 1 bag of salt',
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _currentColor)),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: _currentColor))),
        )
      ],
    );
  }

  Widget buildImportanceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Importance', style: GoogleFonts.lato(fontSize: 28.0)),
        Wrap(
          spacing: 10.0,
          children: [
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == Importance.low,
              label: const Text('low', style: TextStyle(color: Colors.white)),
              onSelected: (selected) {
                setState(() {
                  _importance = Importance.low;
                });
              },
            ),
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == Importance.medium,
              label:
                  const Text('medium', style: TextStyle(color: Colors.white)),
              onSelected: (selected) {
                setState(() {
                  _importance = Importance.medium;
                });
              },
            ),
            ChoiceChip(
              selectedColor: Colors.black,
              selected: _importance == Importance.high,
              label: const Text('high', style: TextStyle(color: Colors.white)),
              onSelected: (selected) {
                setState(() {
                  _importance = Importance.high;
                });
              },
            )
          ],
        )
      ],
    );
  }

  Widget buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () async {
                final currentDate = DateTime.now();
                final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: currentDate,
                    firstDate: currentDate,
                    lastDate: DateTime(currentDate.year + 5));
                setState(() {
                  if (selectedDate != null) {
                    _dueDate = selectedDate;
                  }
                });
              },
            )
          ],
        ),
        Text('${DateFormat('yyyy-MM-dd').format(_dueDate)}')
      ],
    );
  }

  Widget buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time of Day',
              style: GoogleFonts.lato(fontSize: 28.0),
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () async {
                final timeOfDay = await showTimePicker(
                    initialTime: TimeOfDay.now(), context: context);
                setState(() {
                  if (timeOfDay != null) {
                    _timeOfDay = timeOfDay;
                  }
                });
              },
            )
          ],
        ),
        Text('${_timeOfDay.format(context)}')
      ],
    );
  }

  // TODO: Add buildColor picker

  // TODO: Add buildQuantity Field

}