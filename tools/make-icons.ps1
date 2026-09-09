# Genera los iconos PNG de la app a partir de código, sin dependencias externas.
# El dibujo son las tres barras del semáforo — sin empezar, empezado, listo —
# sobre el fondo oscuro de la app: se reconoce igual a 32 px que a 512.
#
# Uso:  powershell -ExecutionPolicy Bypass -File tools\make-icons.ps1

Add-Type -AssemblyName System.Drawing

$raiz = Split-Path -Parent $PSScriptRoot
$destino = Join-Path $raiz "iconos"
if (-not (Test-Path $destino)) { New-Item -ItemType Directory -Path $destino | Out-Null }

$fondo = "#171A18"
$barras = @("#F26A5F", "#E8A147", "#6FBE78")

function New-Icono {
    param([int]$tam, [double]$margen, [string]$archivo)

    $bmp = New-Object System.Drawing.Bitmap($tam, $tam)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.ColorTranslator]::FromHtml($fondo))

    $m = [float]($tam * $margen)
    $ancho = [float]($tam - 2 * $m)
    $alto = [float]($tam * 0.135)
    $hueco = [float]($tam * 0.075)
    $y = [float](($tam - (3 * $alto + 2 * $hueco)) / 2)

    foreach ($c in $barras) {
        $br = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml($c))
        # cápsula = dos círculos en los extremos + rectángulo en medio
        $g.FillEllipse($br, $m, $y, $alto, $alto)
        $g.FillEllipse($br, [float]($m + $ancho - $alto), $y, $alto, $alto)
        $g.FillRectangle($br, [float]($m + $alto / 2), $y, [float]($ancho - $alto), $alto)
        $br.Dispose()
        $y = [float]($y + $alto + $hueco)
    }

    $g.Dispose()
    $ruta = Join-Path $destino $archivo
    $bmp.Save($ruta, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "$archivo  ($tam x $tam)"
}

# margen holgado en el maskable: Android recorta hasta un 20% por cada lado
New-Icono -tam 192 -margen 0.17 -archivo "icono-192.png"
New-Icono -tam 512 -margen 0.17 -archivo "icono-512.png"
New-Icono -tam 512 -margen 0.28 -archivo "icono-maskable-512.png"
New-Icono -tam 180 -margen 0.17 -archivo "apple-touch-icon.png"
