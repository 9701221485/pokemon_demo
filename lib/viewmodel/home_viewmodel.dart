import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_demo/models/page_data.dart';
import 'package:pokemon_demo/models/pokemon.dart';
import 'package:pokemon_demo/services/http_service.dart';

class HomePageController extends StateNotifier<HomePageData> {
  HomePageController(super.state) {
    setUp();
  }
  final HttpService _httpService = HttpService.instance;

  Future<void> setUp() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? response = await _httpService
          .get("https://pokeapi.co/api/v2/pokemon?limit=20&offset=0");
      if (response != null && response.data != null) {
        PokemonListData data = PokemonListData.fromJson(response.data);
        state = state.copyWith(data: data);
      }
      print(response?.data);
    } else {
      if (state.data?.next != null) {
        Response? response = await _httpService.get(state.data!.next!);
        PokemonListData data = PokemonListData.fromJson(response!.data);
        if (data.results != null) {
          state = state.copyWith(
              data: data.copyWith(results: [
            ...?state.data?.results,
            ...?data.results,
          ]));
        }
      }
    }
  }
}
