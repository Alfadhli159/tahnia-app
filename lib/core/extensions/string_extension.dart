extension StringExtension on String {
  bool get isEmail {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'
    );
    return emailRegExp.hasMatch(this);
  }

  bool get isPhone {
    final phoneRegExp = RegExp(r'^[0-9]{10,15}$');
    return phoneRegExp.hasMatch(this);
  }

  String capitalize() {
    return isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String toArabicNumber() {
    const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
    const englishNumbers = '0123456789';
    
    return split('').map((char) {
      final index = englishNumbers.indexOf(char);
      return index != -1 ? arabicNumbers[index] : char;
    }).join();
  }

  String toEnglishNumber() {
    const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
    const englishNumbers = '0123456789';
    
    return split('').map((char) {
      final index = arabicNumbers.indexOf(char);
      return index != -1 ? englishNumbers[index] : char;
    }).join();
  }

  String get firstLetter {
    return isEmpty ? '' : substring(0, 1);
  }

  String get lastLetter {
    return isEmpty ? '' : substring(length - 1);
  }

  String truncate(int length) {
    if (this.length <= length) return this;
    return '${substring(0, length)}...';
  }

  String get toTitleCase {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}
