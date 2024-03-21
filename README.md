# F1_r_analysis

Paquete de scripts para analizar datos de sesiones de fórmula 1.

## Utilización
```sh
rscript x.r #donde x es uno de los scripts
```
Ejecutará una webapp en la dirección local indicada por la terminal.
Además mostrará por esa terminal logs del programa si fuera necesario.

## Scripts disponibles
* gap_to_leader
  * Visualización en una gráfica de la distancia al líder. Permite elegir entre todos los pilotos y ajustar las alturas del gráfico.
* meeting_app
  * Permite ver la información de los grandes premios en función del año. TO DO: no aparecen todas los gp que deberían, mirar si el problema es de la bbdd
* race_control_app
  * Para ver las notas del director de carrera en directo durante la sesión
* tiempo_vuelta_app
  * Visualización en una gráfica del tiempo por vuelta de los pilotos durante una carrera, permitiendo comparar entre ellos


## Historial de versiones

* 0.0.1
    * Initial commit

