import os
import signal
import psutil

# Задайте путь к папке
folder_path = r"C:\Assem\lab11"

# Список зараженных расширений
infected_extensions = {".obj", ".com", ".exe", ".map", ".asm", ".ovl", ".dll", ".txt", ".lib"}

# Функция для завершения процессов HOG и ANTIDHOG
def kill_priority_processes():
    print("Попытка завершения процессов HOG и ANTIDHOG...")
    for proc in psutil.process_iter(attrs=['pid', 'name']):
        if "HOG" in proc.info['name'] or "ANTIDHOG" in proc.info['name']:
            try:
                os.kill(proc.info['pid'], signal.SIGTERM)
                print(f"Завершен процесс: {proc.info['name']} (PID: {proc.info['pid']})")
            except Exception as e:
                print(f"Не удалось завершить процесс {proc.info['name']}. Ошибка: {e}")

# Функция для приоритетного уничтожения файлов HOG и ANTIDHOG
def destroy_priority_files():
    priority_files = ["HOG.COM", "ANTIDHOG.COM"]
    print("Попытка уничтожения приоритетных файлов HOG и ANTIDHOG...")
    for file_name in priority_files:
        file_path = os.path.join(folder_path, file_name)
        if os.path.exists(file_path):
            try:
                os.chmod(file_path, 0o777)  # Снятие защиты от записи
                with open(file_path, 'r+b') as f:
                    f.seek(0)
                    f.write(os.urandom(os.path.getsize(file_path)))  # Перезапись случайными данными
                os.remove(file_path)
                print(f"Уничтожен приоритетный файл: {file_path}")
            except Exception as e:
                print(f"Не удалось уничтожить файл {file_path}. Ошибка: {e}")

# Функция для уничтожения всех зараженных файлов по расширениям
def destroy_infected_files():
    print("Попытка уничтожения всех зараженных файлов...")
    all_files_normal = True  # Флаг для отслеживания, были ли зараженные файлы

    for root, dirs, files in os.walk(folder_path):
        for file_name in files:
            file_path = os.path.join(root, file_name)
            # Проверка расширения файла
            if any(file_name.endswith(ext) for ext in infected_extensions):
                try:
                    os.chmod(file_path, 0o777)
                    with open(file_path, 'r+b') as f:
                        f.seek(0)
                        f.write(os.urandom(os.path.getsize(file_path)))
                    os.remove(file_path)
                    print(f"Уничтожен файл: {file_path}")
                    all_files_normal = False  # Найден зараженный файл
                except Exception as e:
                    print(f"Не удалось уничтожить файл: {file_path}. Ошибка: {e}")
            else:
                print(f"Файл в норме: {file_path}")  # Файл не заражен

    if all_files_normal:
        print("Все файлы в норме, зараженных файлов не найдено.")

# Основная функция
def main():
    # Завершение процессов HOG и ANTIDHOG
    kill_priority_processes()
    
    # Уничтожение приоритетных файлов HOG и ANTIDHOG
    destroy_priority_files()
    
    # Уничтожение всех остальных зараженных файлов
    destroy_infected_files()

if __name__ == "__main__":
    main()
