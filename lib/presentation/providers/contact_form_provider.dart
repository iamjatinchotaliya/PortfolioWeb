import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/portfolio_api_client.dart';
import 'portfolio_provider.dart';

class ContactFormData {
  final String name;
  final String email;
  final String subject;
  final String message;

  const ContactFormData({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });
}

typedef ContactFormSubmitter = Future<void> Function(ContactFormData form);

final contactFormSubmitterProvider = Provider<ContactFormSubmitter>((ref) {
  final repository = ref.watch(dataRepositoryProvider);
  return (form) => repository.submitContact(
    name: form.name,
    email: form.email,
    subject: form.subject,
    message: form.message,
  );
});

enum ContactFormStatus { initial, submitting, success, error }

class ContactFormState {
  final ContactFormStatus status;
  final String? errorMessage;

  const ContactFormState(this.status, {this.errorMessage});
}

final contactFormProvider =
    NotifierProvider.autoDispose<ContactFormNotifier, ContactFormState>(
      ContactFormNotifier.new,
    );

class ContactFormNotifier extends Notifier<ContactFormState> {
  int _submissionId = 0;

  @override
  ContactFormState build() {
    return const ContactFormState(ContactFormStatus.initial);
  }

  Future<void> submit(ContactFormData form) async {
    if (state.status == ContactFormStatus.submitting) return;

    final submissionId = ++_submissionId;
    state = const ContactFormState(ContactFormStatus.submitting);

    try {
      await ref.read(contactFormSubmitterProvider)(form);
      if (!ref.mounted || submissionId != _submissionId) return;
      state = const ContactFormState(ContactFormStatus.success);
    } catch (error) {
      if (!ref.mounted || submissionId != _submissionId) return;
      state = ContactFormState(
        ContactFormStatus.error,
        errorMessage: error is PortfolioApiException ? error.message : null,
      );
    }
  }

  void reset() {
    // Ignore an older pending submission if the form is reset in the meantime.
    _submissionId++;
    state = const ContactFormState(ContactFormStatus.initial);
  }
}
