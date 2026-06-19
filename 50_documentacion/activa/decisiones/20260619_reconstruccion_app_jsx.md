# Andamio — Reconstrucción de 33_app.jsx desde el motor transpilado (s23)

Registro congelado del procedimiento que reconstruyó la fuente JSX del motor a
partir del React.createElement embebido en 33_motor_template.html. Ejecutado una
sola vez; no se re-ejecuta. Documenta cómo se obtuvo 30_procesamiento/33_app.jsx
y cómo se verificó su fidelidad.

## Contexto
C3 (s21) transpiló el JSX original a React.createElement y eliminó Babel del
motor, pero no versionó la fuente JSX: quedó sin fuente editable (deuda A34).
La s23 reconstruyó esa fuente por transformación inversa verificada.

## Procedimiento
1. Extracción del cuerpo de la app: bloque <script> de 33_motor_template.html
   (entre el comentario "Aplicación React (...)" y </script>), 1462 líneas,
   195 nodos React.createElement.
2. Reversa createElement -> JSX con el plugin Babel
   `babel-plugin-transform-react-createelement-to-jsx`.
3. Formato con Prettier (parser babel, printWidth 100).
4. Limpieza de anotaciones /*#__PURE__*/ (artefactos de transpilación).
5. Cabecera de proyecto + instrucciones de retranspilación.

## Verificación de fidelidad (criterio de éxito B.4)
Se retranspiló 33_app.jsx con @babel/preset-react { runtime: "classic" } y se
comparó el resultado contra el React.createElement original del template,
normalizando por AST (no por texto): fusión de StringLiterals hijos adyacentes
(coalescing de text-nodes, inocuo en render), decodificación de escapes Unicode
(\xB7 == ·) y literales numéricos (0.10 == 0.1). Resultado: EQUIVALENCIA TOTAL.

Las únicas diferencias entre la reconstrucción y el original eran cosméticas:
representación Unicode, fragmentación de text-nodes y grafía de un decimal.
Ninguna altera el render ni el output transpilado. El motor en producción no
cambia: 33_app.jsx es fuente para ediciones FUTURAS, no se inyecta todavía.

## Invariante
El motor publicado nunca incluye Babel ni runtime de transpilación. La
transpilación JSX -> createElement es un paso de build manual (herramienta de
desarrollo), externo al producto. El HTML final queda autocontenido (C3).
