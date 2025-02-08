from pulp import LpProblem, LpMaximize, LpVariable, lpSum, LpBinary, LpStatus, value

# Создаем задачу
problem = LpProblem("Flight_Schedule_Optimization", LpMaximize)

# Задаем переменные
cities = ['Columbia', 'Denver', 'Los_Angeles', 'New_York']
times = ['08:00', '10:00', '12:00']

# Бинарные переменные: x[i][j] = 1, если вылет в город i в время j
x = LpVariable.dicts("x", [(i, j) for i in cities for j in times], cat=LpBinary)

# Ожидаемый доход от полетов (в тыс. у.е.)
revenues = {
    ('Columbia', '08:00'): 10, ('Columbia', '10:00'): 6, ('Columbia', '12:00'): 0,
    ('Denver', '08:00'): 9, ('Denver', '10:00'): 10, ('Denver', '12:00'): 0,
    ('Los_Angeles', '08:00'): 14, ('Los_Angeles', '10:00'): 11, ('Los_Angeles', '12:00'): 10,
    ('New_York', '08:00'): 18, ('New_York', '10:00'): 15, ('New_York', '12:00'): 10,
}

# Целевая функция: максимизация прибыли
problem += lpSum(revenues[i, j] * x[i, j] for i in cities for j in times), "Total_Profit"

# Ограничение на количество рейсов (не более 2 в одно время)
for j in times:
    problem += lpSum(x[i, j] for i in cities) <= 2, f"Max_Flights_at_{j}"

# Ограничение: если вылет в Нью-Йорк, то должен быть вылет в Лос-Анджелес
for j in times:
    problem += x['New_York', j] <= x['Los_Angeles', j], f"NY_to_LA_at_{j}"

# Ограничение: ровно один вылет в каждый город
for i in cities:
    problem += lpSum(x[i, j] for j in times) == 1, f"One_Flight_to_{i}"

# Решаем задачу
problem.solve()

# Выводим результаты
print("Status:", LpStatus[problem.status])
for i in cities:
    for j in times:
        if value(x[i, j]) == 1:
            print(f"Flight to {i} at {j}")
print("Total Profit:", value(problem.objective), "thousand currency units")








