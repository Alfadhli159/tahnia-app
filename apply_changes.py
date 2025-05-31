import os
import tkinter as tk
from tkinter import messagebox

def apply_patch(file_path, new_content):
    folder = os.path.dirname(file_path)
    if not os.path.exists(folder):
        os.makedirs(folder)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)

def show_popup(message):
    root = tk.Tk()
    root.withdraw()  # لإخفاء نافذة Tkinter الأساسية
    messagebox.showinfo("تنبيه التعديل", message)
    root.destroy()

def main():
    changes_file = 'changes.txt'
    if not os.path.exists(changes_file):
        show_popup(f"❌ ملف {changes_file} غير موجود!")
        return

    with open(changes_file, 'r', encoding='utf-8') as patch_file:
        data = patch_file.read()
        patches = data.split('---file:')
        for patch in patches[1:]:
            header, *content = patch.strip().split('\n', 1)
            file_path = header.strip()
            new_code = content[0] if content else ''
            if os.path.exists(file_path):
                status = f"📝 تم تحديث الملف:\n{file_path}"
            else:
                status = f"🟢 تم إنشاء الملف الجديد:\n{file_path}"
            apply_patch(file_path, new_code)
            show_popup(status)
    show_popup("✅ تمت جميع التعديلات بنجاح.")

if __name__ == "__main__":
    main()
