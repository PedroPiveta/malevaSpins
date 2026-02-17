import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maleva_spins/services/discogs_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = DiscogsAuthService();

  bool _isLoading = false;
  String? _error;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _authService.login();

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
      backgroundColor: const Color(0xFF0F0F12),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.album, size: 80, color: Colors.white),
              const SizedBox(height: 24),

              const Text(
                "Maleva Vinyl",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Conecte sua coleção do Discogs",
                style: TextStyle(fontSize: 16, color: Colors.white70),
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
                      backgroundColor: const Color(0xFFE74C3C),
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
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
