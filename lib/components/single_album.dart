import 'package:flutter/material.dart';
import 'package:maleva_spins/models/collection_item.dart';
import 'package:maleva_spins/pages/album_details_page.dart';

class SingleAlbum extends StatelessWidget {
  const SingleAlbum({super.key, required this.album});

  final CollectionItem album;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, animation, secondaryAnimation) =>
                AlbumDetailsPage(album: album),
            transitionsBuilder: (_, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              );

              return FadeTransition(opacity: curved, child: child);
            },
          ),
        );
      },
      leading: Hero(
        tag: 'album_${album.id}',
        child: Image.network(
          album.basicInfo.coverImage ?? album.basicInfo.thumb ?? '',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        album.basicInfo.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        '${album.basicInfo.artists.map((artist) => artist.name).join(', ')} • ${album.basicInfo.year.toString() == '0' ? 'Ano desconhecido' : album.basicInfo.year.toString()}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
