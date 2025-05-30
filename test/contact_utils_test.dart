import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:tahania_app/services/contact_utils.dart';

void main() {
  group('ContactUtils Tests', () {
    // Helper function to create a test Contact
    Contact createTestContact(String phoneNumber) {
      return Contact(
        displayName: 'Test User',
        phones: [Phone(phoneNumber)],
      );
    }

    group('getCleanPhoneNumber', () {
      test('handles international numbers with +', () {
        final contact = createTestContact('+966501234567');
        expect(ContactUtils.getCleanPhoneNumber(contact), '966501234567');
      });

      test('handles numbers with 00 prefix', () {
        final contact = createTestContact('00966501234567');
        expect(ContactUtils.getCleanPhoneNumber(contact), '966501234567');
      });

      test('handles Saudi local numbers starting with 05', () {
        final contact = createTestContact('0501234567');
        expect(ContactUtils.getCleanPhoneNumber(contact), '966501234567');
      });

      test('handles Saudi local numbers starting with 5', () {
        final contact = createTestContact('501234567');
        expect(ContactUtils.getCleanPhoneNumber(contact), '966501234567');
      });

      test('handles numbers with special characters', () {
        final contact = createTestContact('+966 (50) 123-4567');
        expect(ContactUtils.getCleanPhoneNumber(contact), '966501234567');
      });

      test('returns empty string for invalid Saudi numbers', () {
        final contact = createTestContact('05123'); // Too short
        expect(ContactUtils.getCleanPhoneNumber(contact), '');
      });
    });

    group('isValidSaudiPhoneNumber', () {
      test('validates correct Saudi numbers', () {
        expect(ContactUtils.isValidSaudiPhoneNumber('966501234567'), true);
        expect(ContactUtils.isValidSaudiPhoneNumber('0501234567'), true);
        expect(ContactUtils.isValidSaudiPhoneNumber('501234567'), true);
      });

      test('validates Saudi numbers with formatting', () {
        expect(ContactUtils.isValidSaudiPhoneNumber('+966 50 123 4567'), true);
        expect(ContactUtils.isValidSaudiPhoneNumber('050-123-4567'), true);
      });

      test('rejects invalid Saudi numbers', () {
        expect(ContactUtils.isValidSaudiPhoneNumber('96650123'), false); // Too short
        expect(ContactUtils.isValidSaudiPhoneNumber('966401234567'), false); // Invalid prefix
        expect(ContactUtils.isValidSaudiPhoneNumber('0401234567'), false); // Invalid prefix
      });
    });

    group('formatPhoneNumberForDisplay', () {
      test('formats Saudi numbers starting with 966', () {
        expect(ContactUtils.formatPhoneNumberForDisplay('966501234567'), 
               '+966 50 123 4567');
      });

      test('formats Saudi numbers starting with 05', () {
        expect(ContactUtils.formatPhoneNumberForDisplay('0501234567'), 
               '050 123 4567');
      });

      test('formats Saudi numbers starting with 5', () {
        expect(ContactUtils.formatPhoneNumberForDisplay('512345678'), 
               '050 123 4567');
      });

      test('formats international numbers', () {
        expect(ContactUtils.formatPhoneNumberForDisplay('1234567890'), 
               '123 456 7890');
      });

      test('handles numbers with special characters', () {
        expect(ContactUtils.formatPhoneNumberForDisplay('+966 (50) 123-4567'), 
               '+966 50 123 4567');
      });
    });
  });
}
