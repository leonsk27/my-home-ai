import 'package:flutter/material.dart';
import 'package:my_home/services/authService.dart';
import 'package:my_home/widgets/input.dart';
import 'package:my_home/widgets/primaryButton.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController(); // Username
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    
    // SIMULACIÓN DE API CALL
    try {
      await _authService.register(_userCtrl.text, _emailCtrl.text, _passCtrl.text);
      await _authService.login(_userCtrl.text, _passCtrl.text);
      if (mounted)  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cuenta creada, inicie sesión."), backgroundColor: Colors.green,));
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
    } catch (err) {
      if (mounted)  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Credenciales incorrectas"), backgroundColor: Colors.red,));
    } finally {
      if (mounted)  setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( elevation: 0, iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Crear Cuenta', 
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black87
                  )
                ),
                const Text('Únete para predecir precios con IA', 
                  style: TextStyle(color: Colors.grey, fontSize: 16)
                ),
                const SizedBox(height: 30),
                
                CustomInput(
                  label: 'Usuario',
                  hint: 'Tu nombre de usuario',
                  icon: Icons.person_outline,
                  controller: _userCtrl,
                  validator: (val) => val!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 20),
                CustomInput(
                  label: 'Email',
                  hint: 'ejemplo@correo.com',
                  icon: Icons.email_outlined,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val!.contains('@') ? null : 'Email inválido',
                ),
                const SizedBox(height: 20),
                CustomInput(
                  label: 'Contraseña',
                  hint: '********',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passCtrl,
                  validator: (val) => val!.length > 5 ? null : 'Mínimo 6 caracteres',
                ),
                
                const SizedBox(height: 40),
                PrimaryButton(
                  text: 'Registrarme',
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}