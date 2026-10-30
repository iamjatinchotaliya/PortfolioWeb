import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolioweb/data/models/contact.dart';
import 'package:portfolioweb/presentation/providers/contact_form_provider.dart';
import 'package:portfolioweb/presentation/widgets/sections/contact_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _form = ContactFormData(
  name: 'Test User',
  email: 'test@example.com',
  subject: 'Project inquiry',
  message: 'I would like to discuss a project.',
);

const _contact = ContactInfo(
  formConfig: FormConfig(
    enabled: true,
    email: 'portfolio@example.com',
    subject: 'Contact',
    successMessage: 'Demo submission completed',
    errorMessage: 'Please try again',
  ),
  contactMethods: [],
  socialLinks: [],
  availability: Availability(
    status: 'available',
    message: '',
    openToWork: true,
    preferredContact: 'email',
    responseTime: '24 hours',
  ),
);

ProviderContainer _createContainer(ContactFormSubmitter submitter) {
  final container = ProviderContainer(
    overrides: [contactFormSubmitterProvider.overrideWithValue(submitter)],
  );
  addTearDown(container.dispose);
  container.listen(contactFormProvider, (_, _) {});
  return container;
}

void main() {
  test('submits form values once and exposes pending and success states', () async {
    final completed = Completer<void>();
    final submissions = <ContactFormData>[];
    final container = _createContainer((form) {
      submissions.add(form);
      return completed.future;
    });
    final notifier = container.read(contactFormProvider.notifier);

    expect(container.read(contactFormProvider).status, ContactFormStatus.initial);
    final submission = notifier.submit(_form);
    expect(container.read(contactFormProvider).status, ContactFormStatus.submitting);

    await notifier.submit(_form);
    expect(submissions, [_form]);

    completed.complete();
    await submission;
    expect(container.read(contactFormProvider).status, ContactFormStatus.success);
  });

  test('a failed submission can be retried', () async {
    var attempts = 0;
    final container = _createContainer((form) async {
      if (++attempts == 1) throw StateError('Submission failed');
    });
    final notifier = container.read(contactFormProvider.notifier);

    await notifier.submit(_form);
    expect(container.read(contactFormProvider).status, ContactFormStatus.error);

    await notifier.submit(_form);
    expect(attempts, 2);
    expect(container.read(contactFormProvider).status, ContactFormStatus.success);
  });

  test('reset ignores the completion of a previous pending submission', () async {
    final completed = Completer<void>();
    final container = _createContainer((form) => completed.future);
    final notifier = container.read(contactFormProvider.notifier);

    final submission = notifier.submit(_form);
    notifier.reset();
    completed.complete();
    await submission;

    expect(container.read(contactFormProvider).status, ContactFormStatus.initial);
  });

  test('a submission can complete safely after its provider is disposed', () async {
    final completed = Completer<void>();
    final container = ProviderContainer(
      overrides: [
        contactFormSubmitterProvider.overrideWithValue((form) => completed.future),
      ],
    );
    container.listen(contactFormProvider, (_, _) {});
    final submission = container.read(contactFormProvider.notifier).submit(_form);

    container.dispose();
    completed.complete();
    await expectLater(submission, completes);
  });

  testWidgets('form validates, keeps failed values and clears a successful retry', (tester) async {
    final previousInterval = VisibilityDetectorController.instance.updateInterval;
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    addTearDown(() {
      VisibilityDetectorController.instance.updateInterval = previousInterval;
    });
    await tester.binding.setSurfaceSize(const Size(1400, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final submissions = <ContactFormData>[];
    var completed = Completer<void>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contactFormSubmitterProvider.overrideWithValue((form) {
            submissions.add(form);
            return completed.future;
          }),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ContactSection(contact: _contact)),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Send Message'));
    await tester.pump();
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(submissions, isEmpty);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), _form.name);
    await tester.enterText(fields.at(1), _form.email);
    await tester.enterText(fields.at(2), _form.subject);
    await tester.enterText(fields.at(3), _form.message);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Send Message'));
    await tester.pump();

    expect(submissions.single.email, _form.email);
    expect(submissions.single.message, _form.message);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed, isNull);
    expect(find.text('Sending...'), findsOneWidget);

    completed.completeError(StateError('Failed to submit'));
    await tester.pump();
    expect(find.text('Please try again'), findsOneWidget);
    expect(tester.widget<TextFormField>(fields.at(3)).controller!.text, _form.message);

    completed = Completer<void>();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Send Message'));
    await tester.pump();
    completed.complete();
    await tester.pump();
    expect(submissions.length, 2);
    for (var index = 0; index < 4; index++) {
      expect(tester.widget<TextFormField>(fields.at(index)).controller!.text, isEmpty);
    }
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed, isNotNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
