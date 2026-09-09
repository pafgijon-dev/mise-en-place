#!/bin/sh
# Genera index.html (la web que se sirve en GitHub Pages) a partir de
# mise-en-place.html, que es la fuente y la que se publica como Artifact.
#
# El Artifact envuelve el archivo en su propio esqueleto al publicarlo, así que
# la fuente no lleva doctype ni <head>. Como web suelta sí hacen falta: sin la
# etiqueta viewport, un iPhone renderiza la página a lo ancho de un escritorio.
#
# Uso:  sh build.sh   (desde la raíz del repositorio)

set -e
cd "$(dirname "$0")"

{
cat <<'CABECERA'
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="description" content="Control del mise en place del pase: pases, platos e ingredientes con semáforo rojo, naranja y verde.">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="Mise en Place">
<meta name="apple-mobile-web-app-status-bar-style" content="default">
<meta name="theme-color" content="#E9ECEA" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#101312" media="(prefers-color-scheme: dark)">
<title>Mise en Place del Pase</title>
<link rel="manifest" href="./manifest.webmanifest">
<link rel="icon" href="./iconos/icono-192.png">
<link rel="apple-touch-icon" href="./iconos/apple-touch-icon.png">
<style>html{color-scheme:light dark}body{margin:0;font:14px system-ui,-apple-system,sans-serif}img{max-width:100%}[hidden]{display:none!important}</style>
</head>
<body>
CABECERA

cat mise-en-place.html

cat <<'PIE'
<script>
if('serviceWorker' in navigator){
  window.addEventListener('load',function(){
    navigator.serviceWorker.register('./sw.js').catch(function(){});
  });
}
</script>
</body>
</html>
PIE
} > index.html

echo "index.html generado ($(wc -c < index.html) bytes)"
