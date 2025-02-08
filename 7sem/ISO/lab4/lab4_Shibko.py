def knapsack_dp(values, weights, W):
    n = len(values)
    f = [0] * (W + 1)  # Таблица для хранения максимальной стоимости

    # Заполняем таблицу динамического программирования
    for i in range(n):
        for w in range(weights[i], W + 1):
            f[w] = max(f[w], f[w - weights[i]] + values[i])

    return f[W]

# Данные задачи
values = [4, 8, 13]  # Стоимость предметов
weights = [3, 4, 5]  # Масса предметов
W = 10  # Ограничение по массе

# Поиск максимальной стоимости
result = knapsack_dp(values, weights, W)
print(f"Оптимальная стоимость: {result}")

def knapsack_solution(values, weights, W):
    n = len(values)
    f = [0] * (W + 1)
    p = [-1] * (W + 1)

    for i in range(n):
        for w in range(weights[i], W + 1):
            if f[w] < f[w - weights[i]] + values[i]:
                f[w] = f[w - weights[i]] + values[i]
                p[w] = i

    # Обратный ход для поиска количества предметов
    w = W
    solution = [0] * n
    while w > 0 and p[w] != -1:
        item = p[w]
        solution[item] += 1
        w -= weights[item]

    return solution

# Поиск количества предметов
optimal_solution = knapsack_solution(values, weights, W)
print(f"Количество предметов: {optimal_solution}")
