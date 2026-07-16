import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart' show authServiceProvider;
import '../../core/constants.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUp = false;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _role = 'patient';
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final auth = ref.read(authServiceProvider);
      if (_isSignUp) {
        await auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          role: _role,
        );
      } else {
        await auth.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Icon(Icons.medical_services, size: 72, color: theme.primaryColor),
              const SizedBox(height: 16),
              Text(AppConstants.appName, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              if (_isSignUp)
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'الاسم الكامل')),
              if (_isSignUp) const SizedBox(height: 12),
              if (_isSignUp)
                TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'رقم الهاتف')),
              if (_isSignUp) const SizedBox(height: 12),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'البريد الإلكتروني')),
              const SizedBox(height: 12),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'كلمة المرور'), obscureText: true),
              if (_isSignUp) const SizedBox(height: 12),
              if (_isSignUp)
                DropdownButtonFormField<String>(
                  value: _role,
                  items: const [
                    DropdownMenuItem(value: 'doctor', child: Text('طبيب')),
                    DropdownMenuItem(value: 'secretary', child: Text('سكرتيرة')),
                    DropdownMenuItem(value: 'patient', child: Text('مريض')),
                  ],
                  onChanged: (v) => setState(() => _role = v!),
                  decoration: const InputDecoration(labelText: 'نوع المستخدم'),
                ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading ? const CircularProgressIndicator() : Text(_isSignUp ? 'إنشاء حساب' : 'تسجيل الدخول'),
                ),
              ),
              TextButton(
                onPressed: () => setState(() { _isSignUp = !_isSignUp; _error = null; }),
                child: Text(_isSignUp ? 'لدي حساب بالفعل' : 'إنشاء حساب جديد'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
