import 'package:equatable/equatable.dart';

abstract class ContactFormEvent extends Equatable {
  const ContactFormEvent();

  @override
  List<Object?> get props => [];
}

class SubmitContactForm extends ContactFormEvent {
  final String name;
  final String email;
  final String subject;
  final String message;

  const SubmitContactForm({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  @override
  List<Object?> get props => [name, email, subject, message];
}

class ResetContactForm extends ContactFormEvent {
  const ResetContactForm();
}
