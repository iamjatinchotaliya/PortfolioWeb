import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_form_event.dart';
import 'contact_form_state.dart';

class ContactFormBloc extends Bloc<ContactFormEvent, ContactFormState> {
  ContactFormBloc() : super(const ContactFormInitial()) {
    on<SubmitContactForm>(_onSubmitContactForm);
    on<ResetContactForm>(_onResetContactForm);
  }

  Future<void> _onSubmitContactForm(
    SubmitContactForm event,
    Emitter<ContactFormState> emit,
  ) async {
    emit(const ContactFormSubmitting());

    try {
      // Simulate form submission
      await Future.delayed(const Duration(seconds: 2));

      emit(const ContactFormSuccess(
        'Thank you for reaching out! I\'ll get back to you within 24 hours.',
      ));

      // Reset form after 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      emit(const ContactFormInitial());
    } catch (e) {
      emit(ContactFormError(
        'Oops! Something went wrong. Please try again or email me directly.',
      ));
    }
  }

  void _onResetContactForm(
    ResetContactForm event,
    Emitter<ContactFormState> emit,
  ) {
    emit(const ContactFormInitial());
  }
}
