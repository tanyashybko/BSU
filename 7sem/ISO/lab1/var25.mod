set COMPONENTS;

param calories {COMPONENTS} >= 0;
param protein {COMPONENTS} >= 0;
param fats {COMPONENTS} >= 0;
param carbs {COMPONENTS} >= 0;
param cholesterol {COMPONENTS} >= 0;
param price {COMPONENTS} >= 0;

var weights {i in COMPONENTS} >= 0;

minimize total_price:
    sum {i in COMPONENTS} price[i] * weights[i];

subject to calorie_min:
    sum {i in COMPONENTS} calories[i] * weights[i] >= 2400;

subject to calorie_max:
    sum {i in COMPONENTS} calories[i] * weights[i] <= 2800;

subject to protein_mass:
    sum {i in COMPONENTS} protein[i] * weights[i] >= 60;

subject to fats_mass:
    sum {i in COMPONENTS} fats[i] * weights[i] <= 30;

subject to carbs_min:
    sum {i in COMPONENTS} carbs[i] * weights[i] >= 10;

subject to carbs_max:
    sum {i in COMPONENTS} carbs[i] * weights[i] <= 40;

subject to cholesterol_mass:
    sum {i in COMPONENTS} cholesterol[i] * weights[i] <= 0.5;