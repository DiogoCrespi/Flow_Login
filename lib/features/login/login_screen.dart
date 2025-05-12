import 'package:flutter/material.dart';
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

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Implementar lógica de login
      Navigator.of(context).pushReplacementNamed('/home');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: LoginTextFormField(
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
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: LoginTextFormField(
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
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text('Entrar'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextButton(
                      onPressed: _handleRegister,
                      child: const Text('Registrar-se'),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextButton(
                      onPressed: _handleForgotPassword,
                      child: const Text('Esqueci minha senha'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
