# Mise en Place del Pase

App de una sola página para controlar el mise en place de un pase de cocina:
qué ingredientes y preparaciones previas hacen falta para cada plato, qué hay
que sacar del congelador y qué queda pendiente.

## Estructura

Pases → platos → ingredientes. Los ingredientes viven en una despensa común:
uno usado en varios platos se marca una vez y cambia de color en todos.

Cada ingrediente cicla con un toque entre tres estados:

| Color     | Significado  |
|-----------|--------------|
| 🔴 rojo    | sin empezar  |
| 🟠 naranja | empezado     |
| 🟢 verde   | listo        |

Platos y pases se colorean solos a partir de sus ingredientes: todo verde →
verde, nada tocado → rojo, cualquier mezcla → naranja.

## Pantallas

1. **Pases** — resumen del servicio (pendiente / listo / por sacar del
   congelador) y un pase por fila, con barra segmentada: un segmento por plato.
2. **Platos** del pase seleccionado, con la misma lógica.
3. **Ingredientes** del plato, con cantidad, nota y marca ❄ de congelador.
4. **Todo** — todos los ingredientes del servicio ordenados sin empezar →
   empezado → listo, con buscador y filtros. Dentro de cada bloque, lo de
   congelador sube primero.

El botón ⟳ de la cabecera empieza un servicio nuevo: devuelve todo a rojo,
dejando marcar antes lo que aguanta y sigue en verde.

## Cómo funciona por dentro

Un solo archivo, `mise-en-place.html`, sin dependencias más allá de las
tipografías de Google Fonts (con fallback del sistema si no hay red).

Publicado como Artifact en claude.ai, guarda el estado en la cuenta con la
capacidad `db`, en dos documentos separados a propósito:

- `mep/estructura` — pases, platos y fichas de ingrediente. Cambia poco.
- `mep/estados` — un campo por ingrediente con su color. Se escribe campo a
  campo, de modo que dos cocineros marcando a la vez no se pisan las marcas.

`localStorage` queda como copia local para que la app abra al instante y
funcione sin cobertura. La línea inferior indica en todo momento si lo marcado
se está guardando en la cuenta o solo en el dispositivo.

Un artifact con `db` no se puede compartir por enlace público: el acceso va por
cuenta.
