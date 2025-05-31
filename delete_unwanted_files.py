import os

# قائمة الكلمات المفتاحية للملفات غير المرغوبة
KEYWORDS = [
    'sticker',
    'auto_reply',
    'greeting_history',
    'greeting_templates',
    'openai_service',
    'favorite_stickers',
    'smart_greeting',
    'condolence_service',
    'animated_text_field',
    'animated_dropdown',
    'animated_button',
    'notification_service',
]

def should_delete(filename):
    filename_lower = filename.lower()
    return any(keyword in filename_lower for keyword in KEYWORDS)

deleted_files = []

for root, dirs, files in os.walk('.', topdown=False):
    for file in files:
        if file.endswith('.dart') and should_delete(file):
            filepath = os.path.join(root, file)
            try:
                os.remove(filepath)
                deleted_files.append(filepath)
            except Exception as e:
                print(f"فشل حذف الملف {filepath}: {e}")

print("\n=== تم حذف الملفات التالية بنجاح ===\n")
if deleted_files:
    for f in deleted_files:
        print(f)
else:
    print("لا يوجد ملفات لحذفها.")

print("\n✅ تم الانتهاء من عملية الحذف.\n")
