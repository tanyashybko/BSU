def calculate_dissatisfaction(department1, department2):
    # Сортируем возраста сотрудников
    department1.sort()
    department2.sort()
    
    # Определяем количество сотрудников в каждом отделе
    len1 = len(department1)
    len2 = len(department2)
    
    # Определяем количество пар и одноместных номеров
    pairs = min(len1, len2)
    single_rooms1 = len1 - pairs
    single_rooms2 = len2 - pairs
    
    # Расчет недовольства для двухместных номеров
    dissatisfaction = 0.0
    for i in range(pairs):
        dissatisfaction += abs(department1[i] - department2[i])
    
    # Расчет недовольства для одноместных номеров
    for i in range(single_rooms1):
        dissatisfaction += department1[pairs + i] / 2.0
    for i in range(single_rooms2):
        dissatisfaction += department2[pairs + i] / 2.0
    
    return round(dissatisfaction, 1)

# Ввод данных
department1 = list(map(int, input().strip().split()))
department2 = list(map(int, input().strip().split()))

# Вычисление и вывод результата
result = calculate_dissatisfaction(department1, department2)
print(result)