import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

/// ---------------------------------------------------------------------------
/// Login
/// ---------------------------------------------------------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Success')),
      );
      Navigator.pushReplacementNamed(context, '/learner');
    }
  }

  @override
  Widget build(BuildContext context) => Shell(children: [
        Section(
          vertical: 48,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Panel(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back', style: heading(26)),
                      const SizedBox(height: 6),
                      Text('Login to access your courses, orders and dashboard.',
                          style: body(14, color: Brand.grey)),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined)),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email is required';
                          }
                          final ok = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(v.trim());
                          return ok ? null : 'Invalid email format';
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Password is required'
                            : null,
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: _login, child: const Text('Login')),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/register'),
                          child: const Text("Don't have an account? Register"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]);
}

/// ---------------------------------------------------------------------------
/// Register
/// ---------------------------------------------------------------------------
/// Demonstrates the full assignment requirement set: Form + TextFormField,
/// RadioList (gender), Radio (account type), Dropdown (country),
/// Checkboxes (hobbies) and required-field validation.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _org = TextEditingController();

  String? _gender;               // RadioList
  String _accountType = 'Individual'; // Radio
  String _country = 'Malaysia';  // Dropdown
  final Set<String> _hobbies = {}; // Checkboxes
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _org.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  String? _validEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim());
    return ok ? null : 'Invalid email format';
  }

  void _register() {
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a gender')),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration success')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) => Shell(children: [
        Section(
          vertical: 48,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Panel(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create your account', style: heading(26)),
                      const SizedBox(height: 6),
                      Text('Join MT Alchemy as an individual or organisation.',
                          style: body(14, color: Brand.grey)),
                      const SizedBox(height: 20),

                      // ---- Account type (RadioGroup + RadioListTile) ----
                      Text('I am registering as', style: heading(16)),
                      RadioGroup<String>(
                        groupValue: _accountType,
                        onChanged: (v) => setState(() => _accountType = v!),
                        child: Row(children: [
                          Expanded(
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              value: 'Individual',
                              activeColor: Brand.green,
                              title: const Text('Individual'),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              value: 'Employer',
                              activeColor: Brand.green,
                              title: const Text('Employer'),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                            labelText: 'Full Name *',
                            prefixIcon: Icon(Icons.person_outline)),
                        validator: _required,
                      ),
                      const SizedBox(height: 16),
                      if (_accountType == 'Employer') ...[
                        TextFormField(
                          controller: _org,
                          decoration: const InputDecoration(
                              labelText: 'Organization Name *',
                              prefixIcon: Icon(Icons.apartment_outlined)),
                          validator: _required,
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email Address *',
                            prefixIcon: Icon(Icons.email_outlined)),
                        validator: _validEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Password *',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6)
                            ? 'Password must be at least 6 characters'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirm,
                        obscureText: _obscure,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password *',
                            prefixIcon: Icon(Icons.lock_reset_outlined)),
                        validator: (v) => v != _password.text
                            ? 'Passwords do not match'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // ---- Gender (RadioList) ----
                      Text('Gender *', style: heading(16)),
                      const SizedBox(height: 4),
                      FormField<String>(
                        validator: (_) => _gender == null
                            ? 'Please select a gender'
                            : null,
                        builder: (state) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioGroup<String>(
                              groupValue: _gender,
                              onChanged: (v) => setState(() {
                                _gender = v;
                                state.didChange(v);
                              }),
                              child: Row(children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    value: 'Female',
                                    activeColor: Brand.green,
                                    title: const Text('Female'),
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    value: 'Male',
                                    activeColor: Brand.green,
                                    title: const Text('Male'),
                                  ),
                                ),
                              ]),
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: 12, top: 2),
                                child: Text(state.errorText!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ---- Country (Dropdown) ----
                      DropdownButtonFormField<String>(
                        initialValue: _country,
                        isExpanded: true,
                        decoration: const InputDecoration(
                            labelText: 'Country',
                            prefixIcon: Icon(Icons.public)),
                        items: [
                          for (final c in countries)
                            DropdownMenuItem(value: c, child: Text(c)),
                        ],
                        onChanged: (v) => setState(() => _country = v!),
                      ),
                      const SizedBox(height: 20),

                      // ---- Hobbies (Checkboxes) ----
                      Text('Hobbies', style: heading(16)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: [
                          for (final h in hobbies)
                            SizedBox(
                              width: 160,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Brand.green,
                                value: _hobbies.contains(h),
                                title: Text(h),
                                onChanged: (v) => setState(() {
                                  if (v == true) {
                                    _hobbies.add(h);
                                  } else {
                                    _hobbies.remove(h);
                                  }
                                }),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: _register,
                            child: const Text('Register')),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, '/login'),
                          child:
                              const Text('Already have an account? Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]);
}
