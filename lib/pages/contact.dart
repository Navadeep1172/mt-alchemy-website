import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

/// Contact / Enquiry page - demonstrates the Flutter [Form] widget with
/// [TextFormField], a [DropdownButtonFormField] and basic required validation.
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _org = TextEditingController();
  final _message = TextEditingController();
  String _type = 'Corporate Training';

  static const enquiryTypes = [
    'Individual Coaching',
    'Corporate Training',
    'Leadership Development',
    'Team Development',
    'Products',
    'Partnership',
    'Other',
  ];

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _org.dispose();
    _message.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  String? _validEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim());
    return ok ? null : 'Invalid email format';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.reset();
      _name.clear();
      _email.clear();
      _phone.clear();
      _org.clear();
      _message.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you! Your enquiry has been noted.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Shell(children: [
        const PageHero(
          eyebrow: 'Contact',
          title: "Let's build a thriving workplace together.",
          subtitle: 'Tell us what you need and we will get back to you.',
        ),
        Section(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Send us an enquiry', style: heading(24)),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                          labelText: 'Name *',
                          prefixIcon: Icon(Icons.person_outline)),
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email *',
                          prefixIcon: Icon(Icons.email_outlined)),
                      validator: _validEmail,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone_outlined)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _org,
                      decoration: const InputDecoration(
                          labelText: 'Organization',
                          prefixIcon: Icon(Icons.apartment_outlined)),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _type,
                      isExpanded: true,
                      decoration: const InputDecoration(
                          labelText: 'Enquiry type',
                          prefixIcon: Icon(Icons.category_outlined)),
                      items: [
                        for (final t in enquiryTypes)
                          DropdownMenuItem(value: t, child: Text(t)),
                      ],
                      onChanged: (v) => setState(() => _type = v!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _message,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          labelText: 'Message *',
                          alignLabelWithHint: true),
                      validator: _required,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.send),
                        label: const Text('Send Enquiry'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]);
}
