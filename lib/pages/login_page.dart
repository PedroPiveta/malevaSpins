import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maleva_spins/services/discogs_auth_service.dart';
import 'package:maleva_spins/storage/auth_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  final _authService = DiscogsAuthService();

  bool _isLoading = false;
  String? _error;

  Future<void> _checkLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final loggedIn = await AuthStorage.isLoggedIn();
      if (loggedIn) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, "/home");
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao verificar login';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final credentials = await _authService.login();

      await AuthStorage.saveCredentials(credentials);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/home");
    } on PlatformException catch (e) {
      if (!mounted) return;

      if (e.code == 'CANCELED') {
        setState(() {
          _error = 'Login cancelado';
        });
      } else {
        setState(() {
          _error = 'Erro: ${e.message}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro durante login';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.album, size: 80),
              const SizedBox(height: 24),

              const Text(
                "Maleva Spins",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Conecte sua coleção do Discogs",
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 40),

              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Entrar com Discogs",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              if (_error != null) ...[
                const SizedBox(height: 20),
                Text(_error!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
