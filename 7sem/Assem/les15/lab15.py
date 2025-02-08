import os
import sys

INITIALS = "STA"

def get_file_size(file_path):
    """Получает размер файла в байтах."""
    return os.path.getsize(file_path)

def main():
    # Проверка корректности среды выполнения
    if not is_proper_environment():
        print("Hello, redish! Go to Hell, ифин!")
        return

    # Получение реального размера файла
    file_path = sys.argv[0]
    module_size = get_file_size(file_path)
    serial_number = f"{INITIALS}{module_size}"

    # Запрос серийного номера
    user_input = input("Введите серийный номер: ")
    if user_input == serial_number:
        print("ДОБРЕ ДОШЛИ")
    else:
        print("Go to sleep!")
        sys.exit()

def is_proper_environment():
    """Проверяет, что программа запускается из нужной папки и с правильным именем."""
    current_file = os.path.basename(sys.argv[0])
    current_directory = os.path.dirname(os.path.abspath(sys.argv[0]))

    if current_file != "lab15.exe" or current_directory != r"C:\Assem\les15\dist":
        return False
    return True

if __name__ == "__main__":
    main()