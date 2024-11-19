import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_demo/models/pokemon.dart';
import 'package:pokemon_demo/services/http_service.dart';
import 'package:pokemon_demo/services/shared_preference.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>(
  (ref, url) async {
    final HttpService apiService = HttpService.instance;
    Response? data = await apiService.get(url);
    if (data != null && data.data != null) {
      Pokemon result = Pokemon.fromJson(data.data);
      return result;
    }
    return null;
  },
);

final favouritePokemonProvider =
    StateNotifierProvider<FavouritePokemonProvider, List<String>>(
  (ref) {
    return FavouritePokemonProvider([]);
  },
);

String Favourite_Pokemon_List_key = "Favourite_Pokemon_List_key";

class FavouritePokemonProvider extends StateNotifier<List<String>> {
  SharedPreference sharedPreference = SharedPreference.instance;
  FavouritePokemonProvider(super._state) {
    _setUp();
  }

  Future _setUp() async {
    state = await sharedPreference.getList(Favourite_Pokemon_List_key) ?? [];
  }

  void addFavourite(String url) {
    state = [...state, url];
    sharedPreference.saveList(Favourite_Pokemon_List_key, state);
  }

  void removeFavourite(String url) {
    state = state.where((ele) => ele != url).toList();
    sharedPreference.saveList(Favourite_Pokemon_List_key, state);
  }
}
