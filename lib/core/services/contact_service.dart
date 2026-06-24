import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

/// Sends portfolio contact form submissions via Web3Forms (no backend required).
class ContactService {
  ContactService._();

  static const _endpoint = 'https://api.web3forms.com/submit';

  static Future<ContactSendResult> sendMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    final accessKey = AppConstants.web3FormsAccessKey.trim();
    if (accessKey.isEmpty || accessKey == 'YOUR_WEB3FORMS_ACCESS_KEY') {
      return ContactSendResult.failure(
        'Email is not configured yet. Add your Web3Forms access key in app_constants.dart',
      );
    }

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'access_key': accessKey,
          'name': name.trim(),
          'email': email.trim(),
          'message': message.trim(),
          'subject': 'New portfolio message from $name',
          'from_name': 'Zarrar.dev Portfolio',
          'replyto': email.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['success'] == true) {
          return ContactSendResult.success();
        }
        final apiMessage = body['message']?.toString();
        return ContactSendResult.failure(
          apiMessage ?? 'Could not send message. Please try again.',
        );
      }

      return ContactSendResult.failure(
        'Server error (${response.statusCode}). Please email ${AppConstants.email} directly.',
      );
    } catch (_) {
      return ContactSendResult.failure(
        'Network error. Check your connection or email ${AppConstants.email} directly.',
      );
    }
  }
}

class ContactSendResult {
  const ContactSendResult._({required this.isSuccess, this.errorMessage});

  factory ContactSendResult.success() => const ContactSendResult._(isSuccess: true);

  factory ContactSendResult.failure(String message) =>
      ContactSendResult._(isSuccess: false, errorMessage: message);

  final bool isSuccess;
  final String? errorMessage;
}
