import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPlacesNotifer extends StateNotifier<List<Place>> {
  UserPlacesNotifer() : super(const []);

  void addPlace(String title, File image, PlaceLocation placelocation) {
    final newPlace =
        Place(title: title, image: image, placeLocation: placelocation);
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifer, List<Place>>(
  (ref) => UserPlacesNotifer(),
);
