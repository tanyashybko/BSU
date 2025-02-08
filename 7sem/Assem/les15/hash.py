import os

file_path = r"C:\Assem\les15\dist\lab15.exe"
file_size = os.path.getsize(file_path)
print(f"Размер файла: {file_size} байт")
