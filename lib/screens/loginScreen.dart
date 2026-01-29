import 'package:flutter/material.dart';
import 'package:my_home/screens/registerScreen.dart';
import 'package:my_home/services/authService.dart';
import 'package:my_home/widgets/input.dart';
import 'package:my_home/widgets/primaryButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    try {
      await _authService.login(_usernameCtrl.text, _passwordCtrl.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bienvenido!"), backgroundColor: Colors.green,));
        Navigator.pushNamedAndRemoveUntil(context, "/home", (Route<dynamic> route) => false);
      }
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Credenciales incorrectas"), backgroundColor: Colors.red,));
      }
    } finally {
      if (mounted)  setState(() => _isLoading = false);
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text('Bienvenido de nuevo', 
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    // fontWeight: FontWeight.bold, color: Colors.black87
                  )
                ),
                const Text('Ingresa tus credenciales para continuar', 
                  style: TextStyle(color: Colors.grey, fontSize: 16)
                ),
                const SizedBox(height: 40),
                
                CustomInput(
                  label: 'Username',
                  hint: 'Goku',
                  icon: Icons.account_box,
                  controller: _usernameCtrl,
                  keyboardType: TextInputType.emailAddress,
                  // validator: (val) => val != null && val.contains('@') ? null : 'Email inválido',
                  validator: (val) => val != null && val.length > 3 ? null : 'Username inválido',
                ),
                const SizedBox(height: 20),
                CustomInput(
                  label: 'Contraseña',
                  hint: '********',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordCtrl,
                  validator: (val) => val != null && val.length > 5 ? null : 'Mínimo 6 caracteres',
                ),
                
                const SizedBox(height: 40),
                PrimaryButton(
                  text: 'Iniciar Sesión',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),
                
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                    child: RichText(
                      text: TextSpan(
                        text: '¿No tienes cuenta? ',
                        style: const TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'Regístrate',
                            style: TextStyle(
                              color: Theme.of(context).hintColor, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}