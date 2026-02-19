import 'package:flutter/material.dart';
import 'package:maleva_spins/models/collection_item.dart';

class AlbumDetailsPage extends StatelessWidget {
  final CollectionItem album;

  const AlbumDetailsPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: 'album_${album.id}',
              child: Image.network(
                album.basicInfo.coverImage ?? album.basicInfo.thumb ?? '',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 16),

            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Text(
                album.basicInfo.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
