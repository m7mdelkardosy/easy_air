import 'package:flutter/services.dart';

// 💳 فلتر لتنسيق رقم الفيزا (كل 4 أرقام يحط مسافة)
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    // لو يمسح نخليه يمسح عادي
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // بنشيل أي مسافات قديمة
    var buffer = StringBuffer();
    String cleanText = text.replaceAll(' ', '');

    for (int i = 0; i < cleanText.length; i++) {
      buffer.write(cleanText[i]);
      var nonZeroIndex = i + 1;
      // تحط مسافة بعد كل 4 أرقام بشرط متكونش في آخر الرقم
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != cleanText.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}