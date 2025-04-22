import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreeSate();
  }
}

class _AddPlaceScreeSate extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  PlaceLocation? _selectedLocation;
  File? _selectedImage;

  void _onSavePlace() {
    final _enteredTitle = _titleController.text;

    if (_enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }
    ref
        .read(userPlacesProvider.notifier)
        .addPlace(_enteredTitle, _selectedImage!, _selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Add  new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ImageInput(onPikImage: (image) => _selectedImage = image),
            const SizedBox(
              height: 10,
            ),
            LocationInput(
              onSelectLocation: (location) => _selectedLocation = location,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: _onSavePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            )
          ],
        ),
      ),
    );
  }
}
