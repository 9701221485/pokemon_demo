import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_demo/models/page_data.dart';
import 'package:pokemon_demo/models/pokemon.dart';
import 'package:pokemon_demo/providers/pokemon_data_providers.dart';
import 'package:pokemon_demo/viewmodel/home_viewmodel.dart';
import 'package:pokemon_demo/widgets/pokemon_card.dart';
import 'package:pokemon_demo/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>(
  (ref) {
    return HomePageController(HomePageData.initial());
  },
);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final ScrollController allPokemonScrollListener = ScrollController();
  late HomePageController _homePageController;
  late HomePageData _homePageData;

  late List<String> _favouritePokemons;

  @override
  void initState() {
    allPokemonScrollListener.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    allPokemonScrollListener.removeListener(scrollListener);
    allPokemonScrollListener.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (allPokemonScrollListener.offset >=
            allPokemonScrollListener.position.maxScrollExtent * 1 &&
        !allPokemonScrollListener.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favouritePokemons = ref.watch(favouritePokemonProvider);
    return Scaffold(
      body: bodyUI(context),
    );
  }
}

extension HomePageUI on HomePageState {
  SafeArea bodyUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [favouritePokemonsList(context), allPokemonList(context)],
          ),
        ),
      ),
    );
  }

  favouritePokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Favourites",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: _favouritePokemons.isNotEmpty
                ? GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.6),
                    itemCount: _favouritePokemons.length,
                    itemBuilder: (BuildContext context, int index) {
                      String pokemonUrl = _favouritePokemons[index];
                      return PokemonCard(pokemonUrl: pokemonUrl);
                    },
                  )
                : const Text("No favourite pokemons yet"),
          )
        ],
      ),
    );
  }

  Column allPokemonList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "All Pokemons",
          style: TextStyle(fontSize: 25),
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.6,
          child: ListView.builder(
            controller: allPokemonScrollListener,
            itemBuilder: (context, index) {
              PokemonListResult pokemon = _homePageData.data!.results![index];
              return PokemonListTile(pokemonUrl: pokemon.url!);
            },
            itemCount: _homePageData.data?.results?.length ?? 0,
          ),
        )
      ],
    );
  }
}
