import 'package:flutter/material.dart';
import 'package:maleva_spins/models/collection_item.dart';

class SingleAlbum extends StatelessWidget {
  const SingleAlbum({super.key, required this.album});

  final CollectionItem album;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        album.basicInfo.thumb ?? '',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(album.basicInfo.title),
      subtitle: Text(
        '${album.basicInfo.artists.map((artist) => artist.name).join(', ')} • ${album.basicInfo.year.toString() == '0' ? 'Ano desconhecido' : album.basicInfo.year.toString()}',
      ),
    );
  }
}
