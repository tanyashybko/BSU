param W;  # Вместимость рюкзака

set ITEMS;

param weight{ITEMS};
param value{ITEMS};

# Переменные
var x{ITEMS} >= 0, integer;

# Целевая функция
maximize total_value:
    sum{i in ITEMS} value[i] * x[i];

# Ограничение на вес
subject to weight_constraint:
    sum{i in ITEMS} weight[i] * x[i] <= W;
