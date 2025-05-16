import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/controllers/auth_controller.dart';
import '../../shared/widgets/login_text_form_field.dart';
import '../../shared/widgets/theme_toggle_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authController = context.read<AuthController>();
      final success = await authController.login(
        _emailController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authController.error ?? 'Erro ao fazer login'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  void _handleForgotPassword() {
    Navigator.of(context).pushNamed('/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 32),
                LoginTextFormField(
                  controller: _emailController,
                  label: 'E-mail',
                  hintText: 'Digite seu e-mail',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite seu e-mail';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Digite um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                LoginTextFormField(
                  controller: _passwordController,
                  label: 'Senha',
                  hintText: 'Digite sua senha',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite sua senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: authController.isLoading ? null : _handleLogin,
                  child: authController.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Entrar'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _handleRegister,
                  child: const Text('Registrar-se'),
                ),
                TextButton(
                  onPressed: _handleForgotPassword,
                  child: const Text('Esqueci minha senha'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
