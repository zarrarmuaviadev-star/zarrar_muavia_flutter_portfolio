import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_constants.dart';
import '../core/services/contact_service.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/url_helper.dart';
import 'glass_card.dart';
import 'gradient_button.dart';

/// Contact form — sends real emails via Web3Forms.
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final Map<String, bool> _focused = {};
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSending || !(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSending = true);

    final result = await ContactService.sendMessage(
      name: _nameController.text,
      email: _emailController.text,
      message: _messageController.text,
    );

    if (!mounted) return;
    setState(() => _isSending = false);

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Message sent! I\'ll reply to your email soon.',
                  style: GoogleFonts.inter(),
                ),
              ),
            ],
          ),
        ),
      );
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      _formKey.currentState?.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceLight,
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  result.errorMessage ?? 'Failed to send message.',
                  style: GoogleFonts.inter(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'Email me',
            textColor: AppColors.primary,
            onPressed: () => UrlHelper.openEmail(AppConstants.email),
          ),
        ),
      );
    }
  }

  Widget _field({
    required String key,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    final focused = _focused[key] ?? false;
    return Focus(
      onFocusChange: (v) => setState(() => _focused[key] = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: focused
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          enabled: !_isSending,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: focused ? AppColors.primary : AppColors.textMuted),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Send a Message',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Messages are delivered to ${AppConstants.email}.',
              style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 28),
            _field(
              key: 'name',
              controller: _nameController,
              label: 'Name',
              icon: Icons.person_outline_rounded,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            _field(
              key: 'email',
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _field(
              key: 'message',
              controller: _messageController,
              label: 'Message',
              icon: Icons.message_outlined,
              maxLines: 5,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter a message';
                if (v.trim().length < 10) return 'Message must be at least 10 characters';
                return null;
              },
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: 'Send Message',
              icon: Icons.send_rounded,
              expand: true,
              isLoading: _isSending,
              onPressed: _isSending ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
