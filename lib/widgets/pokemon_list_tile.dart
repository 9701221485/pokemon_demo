import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_demo/models/pokemon.dart';
import 'package:pokemon_demo/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  PokemonListTile({
    super.key,
    required this.pokemonUrl,
  });

  late FavouritePokemonProvider _favouritePokemonProvider;
  late List<String> _favouritePokemons;
  final String pokemonUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favouritePokemonProvider = ref.watch(favouritePokemonProvider.notifier);
    _favouritePokemons = ref.watch(favouritePokemonProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(data: (data) {
      return listTile(context, false, data);
    }, error: (error, stackTrace) {
      return Text("Error: $error");
    }, loading: () {
      return listTile(context, true, null);
    });
  }

  Widget listTile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
              )
            : CircleAvatar(),
        title: Text(pokemon != null
            ? pokemon.name!
            : "Currently loading name of pokemon"),
        subtitle: Text("Has ${pokemon?.moves?.length ?? 0} moves"),
        trailing: IconButton(
            onPressed: () {
              if (_favouritePokemons.contains(pokemonUrl)) {
                _favouritePokemonProvider.removeFavourite(pokemonUrl);
              } else {
                _favouritePokemonProvider.addFavourite(pokemonUrl);
              }
            },
            icon: Icon(
              _favouritePokemons.contains(pokemonUrl)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            )),
      ),
    );
  }
}
