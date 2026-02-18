import 'package:flutter/material.dart';
import 'package:maleva_spins/components/single_album.dart';
import 'package:maleva_spins/models/discogs_collection.dart';

class AlbumList extends StatelessWidget {
  final DiscogsCollection? albums;

  const AlbumList({super.key, this.albums});

  @override
  Widget build(BuildContext context) {
    if (albums == null || albums!.items.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum álbum na coleção, crie uma coleção no Discogs e a deixe pública para ver seus álbuns aqui!',
        ),
      );
    } else {
      return ListView.builder(
        itemCount: albums!.items.length,
        itemBuilder: (context, index) {
          return SingleAlbum(album: albums!.items[index]);
        },
      );
    }
  }
}
