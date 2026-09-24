import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/helper/api_response_helper.dart';

void main() {
  group('Magento error messages (86d4b0zyu)', () {
    test('substitutes positional parameters instead of showing %1 and 400', () {
      // The body behind the "contact %1. [hello@example.com]: 400" QA saw.
      const body = '{"message":"We received too many requests for password '
          'resets. Please wait and try again later or contact %1.",'
          '"parameters":["hello@example.com"]}';

      expect(
        magentoErrorMessage(body),
        'We received too many requests for password resets. Please wait and '
        'try again later or contact hello@example.com.',
      );
    });

    test('substitutes named parameters', () {
      const body = '{"message":"\\"%fieldName\\" is required. Enter and try '
          'again.","parameters":{"fieldName":"email"}}';

      expect(magentoErrorMessage(body), '"email" is required. Enter and try again.');
    });

    test('does not let %1 eat the start of %10', () {
      final parameters = List.generate(10, (i) => '"p${i + 1}"').join(',');
      final body = '{"message":"%1 and %10","parameters":[$parameters]}';

      expect(magentoErrorMessage(body), 'p1 and p10');
    });

    test('non-JSON bodies such as a CDN error page get a generic message', () {
      expect(magentoErrorMessage('<html>502 Bad Gateway</html>'),
          'Error Communicating with Server');
      expect(magentoErrorText('<html>502 Bad Gateway</html>'), isNull);
    });
  });
}
