import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_demo/models/pokemon.dart';
import 'package:pokemon_demo/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonCard extends ConsumerWidget {
  PokemonCard({super.key, required this.pokemonUrl});
  final String pokemonUrl;
  late FavouritePokemonProvider _favouritePokemonProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    _favouritePokemonProvider = ref.watch(favouritePokemonProvider.notifier);
    return pokemon.when(
      data: (data) {
        return card(context, false, data);
      },
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
      loading: () {
        return card(context, true, null);
      },
    );
  }

  Widget card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(blurRadius: 10, spreadRadius: 2, color: Colors.black)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon?.name?.toUpperCase().toString() ?? "Pokemon",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  "#${pokemon?.id}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            Expanded(
              child: CircleAvatar(
                backgroundImage: pokemon != null
                    ? NetworkImage(pokemon.sprites!.frontDefault!)
                    : null,
                radius: MediaQuery.sizeOf(context).width * 0.5,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${pokemon?.moves?.length ?? 0} Moves",
                  style: const TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    _favouritePokemonProvider.removeFavourite(pokemonUrl);
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
