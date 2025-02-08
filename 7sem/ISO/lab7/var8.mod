set n;
param A{n, n};
var y{n};
minimize z1: sum{i in n} y[i];
subject to usl1{j in n}: sum{i in n} A[i,j]*y[i] >= 1;
subject to ogranich1{i in n}: 0 <= y[i];