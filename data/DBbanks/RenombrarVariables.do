/* Renombrar variables de indicadores de EfectosCapital por algo significativo */
label variable E3 "Spread para equilibrio anualizado % indicE3 C1"
rename E3 eficSpreadEqAn
label variable E3W "Spread para equilibrio anualizado % indicE3 C1 Winsorizado"
rename E3W eficSpreadEqAnW
rename E7 eficGastoXEmpleado
label variable eficGastoXEmpleado "Gasto mensual promedio por empleado E7"
label variable E7W "Gasto mensual promedio por empleado Wins E7"
rename E7W eficGastoXEmpleadoW
label variable E15 "Gastos en remuneraciones sobre gastos en administraci�n E15"
rename E15 eficSalariosSGAdm
label variable E17 "Dep�sitos y Pr�stamos sobre personal E17"
rename E17 eficVolNgcioXEmpleado
label variable E17W "Dep�sitos y Pr�stamos sobre personal E17 Winsorizado"
rename E17W eficVolNgcioXEmpleadoW
label variable A2 "Incobrabilidad potencial A2 (Total prestamos atrasados/Total Financiaciones)"
rename A2 rieIncobPotencial
rename A2W rieIncobPotencialW
label variable rieIncobPotencial "Incobrabilidad potencial A2 (Prestamos atrasados-Prev/Total Financiaciones)"
label variable A3 "Cartera vencida A3 (PrestamosVencidos-Prev/Financiaciones)"
rename A3 rieVencidos
rename A3W rieVencidosW
label variable rieVencidosW "Cartera vencida A3"
label variable A4 "Previsiones sobre cartera irregular A4"
rename A4 riePrevIrregular
label variable A10 "Cartera irregular sobre financiaciones A10"
rename A10 rieIrregular
label variable C8Est "capApalancaEst (estimado para fechas no disponible)"
rename C8Est capApalancaEst
label variable C8Est_w "PNtotal/Activo Winsorizado"
rename C8Est_w capApalancaEstW
label variable A9 "Activos de riesgo A9"
rename A9 rieActRiesgo