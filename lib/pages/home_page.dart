import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeApi();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const Text('Maleva Vinyl')
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
                  Text(_user?.username ?? 'Maleva Vinyl'),
                ],
              ),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE74C3C)),
            )
          : Center(
              child: Text(
                'Bem-vindo, ${_user?.username ?? 'usuário'}!',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
