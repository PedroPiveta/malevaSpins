import 'package:flutter/material.dart';
import 'package:maleva_spins/components/album_list.dart';
import 'package:maleva_spins/components/pill_tab_view.dart';
import 'package:maleva_spins/models/discogs_collection.dart';
import '../services/discogs_api_service.dart';
import '../storage/auth_storage.dart';
import '../models/discogs_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DiscogsApiService? _apiService;
  DiscogsUser? _user;
  bool _isLoading = true;

  DiscogsCollection? _collection;

  @override
  void initState() {
    super.initState();
    _initializeAndFetchAlbums();
  }

  Future<void> _initializeAndFetchAlbums() async {
    await _initializeApi();
    if (_user != null) {
      await _fetchAlbums();
    }
  }

  Future<void> _initializeApi() async {
    final credentials = await AuthStorage.loadCredentials();

    if (credentials == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
      return;
    }

    _apiService = DiscogsApiService(credentials);

    try {
      final user = await _apiService!.getUserIdentity();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await AuthStorage.clearCredentials();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future<void> _fetchAlbums() async {
    setState(() {
      _isLoading = true;
    });

    if (_apiService == null || _user == null) return;
    try {
      final collection = await _apiService!.getUserCollection(_user!.username);
      if (mounted) {
        setState(() {
          _collection = collection;
        });
      }
    } catch (e) {
      debugPrint('Error fetching albums: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const Text('Maleva Spins', style: TextStyle(fontSize: 20))
            : Row(
                spacing: 12,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      _user?.avatarUrl ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.account_circle, size: 32);
                      },
                    ),
                  ),
                  Text('Maleva Spins'),
                ],
              ),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                  child: Text(
                    'Bem-vindo, ${_user?.username ?? 'usuário'}!',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PillTabView(
                      tabs: [
                        (
                          label: 'Coleção',
                          icon: Icons.album,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: AlbumList(albums: _collection),
                          ),
                        ),
                        (
                          label: 'Histórico',
                          icon: Icons.history,
                          child: Center(
                            child: Text(
                              'Histórico em breve',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
