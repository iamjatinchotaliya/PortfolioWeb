import 'package:equatable/equatable.dart';

abstract class ContactFormState extends Equatable {
  const ContactFormState();

  @override
  List<Object?> get props => [];
}

class ContactFormInitial extends ContactFormState {
  const ContactFormInitial();
}

class ContactFormSubmitting extends ContactFormState {
  const ContactFormSubmitting();
}

class ContactFormSuccess extends ContactFormState {
  final String message;

  const ContactFormSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactFormError extends ContactFormState {
  final String message;

  const ContactFormError(this.message);

  @override
  List<Object?> get props => [message];
}
