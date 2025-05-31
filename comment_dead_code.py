import os
import re

KEYWORDS = [
    "RelationshipType",
    "SmartGreeting",
    "Sticker",
    "MessageCategory",
    "OfficialMessage",
    "OfficialMessageService",
    "CondolenceService",
    "SmartGreetingService",
    "SmartGreetingSettingsScreen",
    "OpenAIService",
    "AnimatedButton",
    "StickerPicker",
    "Greeting"
]

def should_comment(line):
    return any(re.search(r'\b{}\b'.format(kw), line) for kw in KEYWORDS)

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
                    new_lines.append('// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:\n// ' + line)
                    changed = True
                else:
                    new_lines.append(line)
            if changed:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.writelines(new_lines)
                changed_files.append(file_path)

if changed_files:
    print("✅ تم تعطيل الأكواد غير المعتمدة في الملفات التالية:")
    for f in changed_files:
        print(f)
else:
    print("لا يوجد سطور بحاجة للتعليق.")
