# Decisión: modelo de publicación en GitHub Pages

**Fecha:** 2026-06-12
**Sesión:** 6 (documentación retroactiva de una decisión tomada en la sesión 4, v04)
**Tipo:** decisión de arquitectura / DevOps
**Estado:** vigente

## Contexto

El producto del proyecto es un motor HTML autocontenido
(`40_salidas/motor_categoria.html`). Publicarlo en GitHub Pages exige decidir qué
carpeta o rama sirve Pages y cómo se mantiene sincronizado lo publicado con lo
que genera el pipeline.

## Decisión

**Modelo B:** GitHub Pages sirve la carpeta `docs/` de la rama `main`. El
generador (`33_generar_html.R`) **copia automáticamente**
`40_salidas/motor_categoria.html` a `docs/index.html` en cada corrida.

## Justificación

1. **Simplicidad:** servir `docs/` desde `main` evita mantener una rama
   `gh-pages` separada y sincronizada a mano.
2. **Fuente de verdad única:** el producto canónico vive en `40_salidas/`;
   `docs/index.html` es una copia derivada que se regenera siempre, lo que
   impide que lo publicado divergir de lo generado.
3. **Reproducibilidad:** la copia es un paso del pipeline, no una acción manual
   propensa a olvido.

## Alternativas consideradas

- **Rama `gh-pages` dedicada.** Descartada: añade una rama que sincronizar a mano
  en cada actualización del motor.
- **Pages desde la raíz del repo.** Descartada: ensucia la raíz con el artefacto
  publicado y mezcla código con producto servido.

## Implicancia

`docs/index.html` **no se edita a mano** (invariante 🔒 de los traspasos):
cualquier cambio del motor pasa por regenerar con el pipeline. `docs/index.html`
sí se versiona en Git (es lo que Pages sirve); `40_salidas/` puede ignorarse como
output. Tras `run_all()` (o `run_all(only = 33)`), `docs/index.html` queda
actualizado y listo para `git push`.
