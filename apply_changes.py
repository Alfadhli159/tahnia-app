import os
import re

# قائمة التغييرات (بحث واستبدال)
UPDATES = [
    # تصحيح استيراد shared_preferences الخاطئ
    {
        "pattern": r"import\s+'package:shared_preferences\.dart';",
        "replacement": "import 'package:shared_preferences/shared_preferences.dart';"
    },
    # تعليق استيراد sticker_view
    {
        "pattern": r"import\s+'package:sticker_view/sticker_view\.dart';",
        "replacement": "// import 'package:sticker_view/sticker_view.dart'; // تمت الإزالة آليًا"
    },
    # تعليق استيراد flutter_icons
    {
        "pattern": r"import\s+'package:flutter_icons/flutter_icons\.dart';",
        "replacement": "// import 'package:flutter_icons/flutter_icons.dart'; // تمت الإزالة آليًا"
    },
    # يمكنك إضافة المزيد حسب الحاجة...
]

def apply_updates_to_file(filepath, updates=UPDATES):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    original_content = content
    for update in updates:
        content = re.sub(update["pattern"], update["replacement"], content)
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"✅ تم تعديل الملف: {filepath}")

def scan_and_apply(root_dir):
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                apply_updates_to_file(filepath)

if __name__ == "__main__":
    scan_and_apply(".")
    print("\n✨ تم فحص جميع ملفات .dart وتصحيح الاستيرادات الخاطئة.")

