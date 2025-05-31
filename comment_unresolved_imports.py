import os

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
    'relationshiptype',  # لاحتمال وجود كلاس بالاسم
    'official_message_service'
]

def should_comment(line):
    lower = line.lower()
    return (
        lower.strip().startswith('import') and
        any(word in lower for word in KEYWORDS)
    )

changed_files = []

for root, dirs, files in os.walk('./lib'):
    for file in files:
        if file.endswith('.dart'):
            file_path = os.path.join(root, file)
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
            new_lines = []
            changed = False
            for line in lines:
                if should_comment(line):
                    new_lines.append('// تم تعليق هذا الاستيراد تلقائياً: ' + line)
                    changed = True
                else:
                    new_lines.append(line)
            if changed:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.writelines(new_lines)
                changed_files.append(file_path)

if changed_files:
    print("✅ تم تعليق import الملفات غير الموجودة في الملفات التالية:")
    for f in changed_files:
        print(f)
else:
    print("لا يوجد import بحاجة للتعليق.")
