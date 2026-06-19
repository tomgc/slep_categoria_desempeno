/* ============================================================================
 * 33_app.jsx — Fuente JSX del cuerpo de la aplicación React del motor.
 * ----------------------------------------------------------------------------
 *   Proyecto : slep_categoria_desempeno
 *   Propósito: fuente editable del motor. El cuerpo de la app vive transpilado
 *              a React.createElement dentro de 33_motor_template.html (el motor
 *              no depende de Babel ni de ninguna red en runtime, ver C3 / s21).
 *              Este archivo es la FUENTE DE VERDAD para editar la UI: se edita
 *              aquí en JSX y se retranspila al template.
 *   Insumos  : ninguno en build (se inyectan datos/inlines en 33_generar_html.R).
 *   Salida   : bloque <script> de la app dentro de 33_motor_template.html.
 *   Origen   : reconstruido (s23) desde el React.createElement del template via
 *              transformación inversa + verificación por AST (retranspila
 *              idéntico con runtime clásico). Ver andamio de reconstrucción.
 *
 *   CÓMO RETRANSPILAR AL TEMPLATE (runtime clásico, sin dependencias de red en
 *   el producto; Babel se usa solo como herramienta de build, fuera del motor):
 *
 *     npx babel 33_app.jsx --out-file app_transpilado.js \
 *       --presets '@babel/preset-react' \
 *       --config-file ./babel.config.json
 *
 *   con babel.config.json:
 *     { "presets": [["@babel/preset-react", { "runtime": "classic" }]] }
 *
 *   El runtime "classic" es obligatorio: emite React.createElement (no el
 *   _jsx del runtime automático, que requeriría un import/resolución de
 *   módulos ausente en el motor autocontenido). El output reemplaza el
 *   contenido del <script> de la app en 33_motor_template.html, entre el
 *   comentario "Aplicación React (...)" y el cierre </script>.
 *
 *   INVARIANTE: el motor publicado NO incluye Babel ni runtime de transpilación.
 *   La transpilación es un paso de build manual; el HTML final queda autocontenido.
 * ========================================================================== */

"use strict";

// ============================================================
// CatData — adaptador de datos de Categoría de Desempeño.
// Sin ponderación por matrícula, sin GSE: agregación = conteo de EE.
// ============================================================
const CatData = (function () {
  const M = DATA.meta;
  const YEARS = M.anios.slice().sort((a, b) => a - b);
  const ANIO_VIGENTE = M.anio_vigente;
  // Anio vigente de matricula (tamano), separado del de categoria. La tarjeta
  // de tamano de la fila de EE usa este; la trayectoria/serie usan ANIO_VIGENTE.
  const ANIO_MAT_VIGENTE = M.anio_matricula_vigente || M.anio_vigente;
  const CATEGORIAS = M.categorias.slice(); // orden semántico Insuf -> Alto
  const CAT_COLORS = M.cat_colors;
  const CAT_LABELS = M.cat_labels;
  const NIVELES = M.niveles; // {basica, media}
  const MOTIVOS = M.motivos;
  const DEPE_LABELS = M.depe_labels || {};
  const ENSE2_LABELS = M.ense2_labels || {};
  const ENSE2_A_NIVEL = M.ense2_a_nivel || {};

  // ---- Catálogos territoriales ----
  const COMUNA_BY_COD = new Map(DATA.comunas.map((c) => [String(c.cod), c]));
  const REGIONES = (function () {
    const nomReg = {};
    DATA.regiones.forEach((r) => {
      nomReg[String(r.cod)] = r.nom;
    });
    const byReg = new Map();
    DATA.comunas.forEach((c) => {
      const k = String(c.cod_reg);
      if (!byReg.has(k))
        byReg.set(k, {
          cod: k,
          nom: nomReg[k] || c.nom_reg || "Región " + k,
          comunas: [],
        });
      byReg.get(k).comunas.push({
        cod: String(c.cod),
        nom: c.nom,
      });
    });
    return Array.from(byReg.values())
      .sort((a, b) => parseInt(a.cod) - parseInt(b.cod))
      .map((r) => ({
        ...r,
        comunas: r.comunas.sort((a, b) => a.nom.localeCompare(b.nom, "es")),
      }));
  })();
  const SLEPS = (function () {
    if (!DATA.sleps) return [];
    const by = new Map();
    DATA.sleps.forEach((r) => {
      const k = String(r.cod_slep);
      if (!by.has(k))
        by.set(k, {
          cod: k,
          nom: r.nombre_slep,
          anio_traspaso: r.anio_traspaso,
        });
    });
    return Array.from(by.values()).sort((a, b) => a.nom.localeCompare(b.nom, "es"));
  })();

  // ---- Índice territorial: (tipo|cod|nivel|anio) -> {categoria: {n_ee, pct}, total} ----
  const T = DATA.territorial;
  const TER_IX = new Map();
  for (let i = 0; i < T.rows; i++) {
    const k = T.tipo_entidad[i] + "|" + T.cod_entidad[i] + "|" + T.nivel[i] + "|" + T.anio[i];
    if (!TER_IX.has(k))
      TER_IX.set(k, {
        cats: {},
        total: 0,
      });
    const o = TER_IX.get(k);
    o.cats[T.categoria[i]] = {
      n_ee: T.n_ee[i],
      pct: T.pct[i],
    };
    o.total = T.n_categorizados[i]; // mismo denominador en todas las filas de la celda
  }

  // Distribución de un territorio en un nivel/año: 4 categorías + total.
  function getDistribucion(tipo, cod, nivel, anio) {
    const k = tipo + "|" + String(cod) + "|" + nivel + "|" + anio;
    const o = TER_IX.get(k);
    const out = {
      total: o ? o.total : 0,
      cats: {},
    };
    CATEGORIAS.forEach((c) => {
      const v =
        o && o.cats[c]
          ? o.cats[c]
          : {
              n_ee: 0,
              pct: 0,
            };
      out.cats[c] = v;
    });
    return out;
  }

  // ---- Índice sin_vigente: (tipo|cod|nivel|anio) -> {motivo: n_ee} ----
  const SV = DATA.sin_vigente;
  const SV_IX = new Map();
  for (let i = 0; i < SV.rows; i++) {
    const k = SV.tipo_entidad[i] + "|" + SV.cod_entidad[i] + "|" + SV.nivel[i] + "|" + SV.anio[i];
    if (!SV_IX.has(k)) SV_IX.set(k, {});
    SV_IX.get(k)[SV.motivo[i]] = SV.n_ee[i];
  }
  function getSinVigente(tipo, cod, nivel, anio) {
    const k = tipo + "|" + String(cod) + "|" + nivel + "|" + anio;
    return SV_IX.get(k) || {};
  }

  // ---- Índice por establecimiento: rbd|nivel -> [{anio, categoria}] (trayectoria) ----
  const R = DATA.rbd;
  const RBD_TRAJ = new Map(); // rbd|nivel -> Map(anio -> categoria)
  const RBD_MOTIVO = new Map(); // rbd|nivel -> Map(anio -> motivo) (solo s/i)
  const RBD_META = new Map(); // rbd -> {nom, cod_com, cod_reg, cod_depe2}
  const R_MOT = R.motivo || null; // presente solo si el generador exporta motivo
  for (let i = 0; i < R.rows; i++) {
    const rbd = R.rbd[i],
      niv = R.nivel[i];
    const k = rbd + "|" + niv;
    if (!RBD_TRAJ.has(k)) RBD_TRAJ.set(k, new Map());
    RBD_TRAJ.get(k).set(R.anio[i], R.categoria[i]);
    const mot = R_MOT ? R_MOT[i] : null;
    if (mot) {
      if (!RBD_MOTIVO.has(k)) RBD_MOTIVO.set(k, new Map());
      RBD_MOTIVO.get(k).set(R.anio[i], mot);
    }
    if (!RBD_META.has(rbd))
      RBD_META.set(rbd, {
        nom: R.nom_rbd[i],
        cod_com: String(R.cod_com_rbd[i]),
        cod_reg: String(R.cod_reg_rbd[i]),
        cod_depe2: String(R.cod_depe2[i]),
        nom_com: (COMUNA_BY_COD.get(String(R.cod_com_rbd[i])) || {}).nom || null,
      });
  }

  // ---- Índice de matrícula: rbd -> anio -> {ense2: {cod->matricula}, total} ----
  // Grano cod_ense2 (tipo de enseñanza), distinto al de categoría (nivel).
  // ENSE2_A_NIVEL mapea los tipos con categoría (2->básica, 5/7->media); el
  // resto es matrícula de contexto. total_ee = tamaño completo del EE.
  const MAT = DATA.matricula || null;
  const MAT_IX = new Map(); // rbd -> Map(anio -> {porEnse2: Map(cod->mat), total})
  if (MAT) {
    for (let i = 0; i < MAT.rows; i++) {
      const rbd = MAT.rbd[i],
        anio = MAT.anio[i];
      if (!MAT_IX.has(rbd)) MAT_IX.set(rbd, new Map());
      const porAnio = MAT_IX.get(rbd);
      if (!porAnio.has(anio))
        porAnio.set(anio, {
          porEnse2: new Map(),
          total: MAT.matricula_total_ee[i],
        });
      porAnio.get(anio).porEnse2.set(MAT.cod_ense2[i], MAT.matricula[i]);
    }
  }

  // Matrícula de un nivel del motor (básica|media) para un rbd×año.
  // media = suma de cod_ense2 5 y 7; básica = cod_ense2 2. null si no hay dato.
  function matriculaNivel(rbd, nivel, anio) {
    const porAnio = MAT_IX.get(rbd);
    if (!porAnio) return null;
    const reg = porAnio.get(anio);
    if (!reg) return null;
    const e = reg.porEnse2;
    if (nivel === "basica") {
      return e.has("2") ? e.get("2") : null;
    }
    if (nivel === "media") {
      let s = null;
      if (e.has("5")) s = (s || 0) + e.get("5");
      if (e.has("7")) s = (s || 0) + e.get("7");
      return s;
    }
    return null;
  }

  // Matrícula total del EE (todos los tipos de enseñanza) en un año. null si no hay dato.
  function matriculaTotalEE(rbd, anio) {
    const porAnio = MAT_IX.get(rbd);
    if (!porAnio) return null;
    const reg = porAnio.get(anio);
    return reg ? reg.total : null;
  }

  // Desglose completo por tipo de enseñanza de un rbd×año, ordenado por cod_ense2.
  // Cada item: {cod_ense2, label, matricula, nivel} (nivel = básica|media|null).
  function matriculaDesglose(rbd, anio) {
    const porAnio = MAT_IX.get(rbd);
    if (!porAnio) return [];
    const reg = porAnio.get(anio);
    if (!reg) return [];
    const out = [];
    reg.porEnse2.forEach((mat, cod) => {
      out.push({
        cod_ense2: cod,
        label: ENSE2_LABELS[cod] || "Tipo " + cod,
        matricula: mat,
        nivel: ENSE2_A_NIVEL[cod] || null,
      });
    });
    return out.sort((a, b) => a.cod_ense2.localeCompare(b.cod_ense2));
  }

  // Serie de matrícula del nivel (básica|media) a lo largo de todos los años
  // disponibles, ascendente. Cada item: {anio, mat} (mat puede ser null si el EE
  // no tiene ese nivel ese año). Insumo para la evolución de tamaño en la ficha.
  function matriculaSerieNivel(rbd, nivel) {
    return YEARS.map((y) => ({
      anio: y,
      mat: matriculaNivel(rbd, nivel, y),
    }));
  }

  // RBDs que pertenecen a un territorio (para listar EE de la grilla).
  function rbdsDeEntidad(entity) {
    const set = new Set();
    if (entity.kind === "establecimiento") {
      set.add(String(entity.cod));
    } else if (entity.kind === "region") {
      RBD_META.forEach((m, rbd) => {
        if (m.cod_reg === String(entity.cod)) set.add(rbd);
      });
    } else if (entity.kind === "comuna") {
      RBD_META.forEach((m, rbd) => {
        if (m.cod_com === String(entity.cod)) set.add(rbd);
      });
    } else if (entity.kind === "slep") {
      (entity.rbds || []).forEach((r) => set.add(String(r)));
    }
    return set;
  }

  // Catálogo de establecimientos para el buscador (los que tienen alguna medición).
  const ESTAB_CAT = (function () {
    const out = [];
    RBD_META.forEach((m, rbd) => {
      out.push({
        rbd,
        nom: m.nom || "RBD " + rbd,
        nom_com: m.nom_com,
        cod_depe2: m.cod_depe2,
      });
    });
    return out.sort((a, b) => a.nom.localeCompare(b.nom, "es"));
  })();

  // Lista de EE de una entidad en un nivel, con categoría vigente y trayectoria.
  // Solo EE que tienen alguna medición en ese nivel.
  function getEstablecimientos(entity, nivel) {
    const rbds = rbdsDeEntidad(entity);
    const out = [];
    rbds.forEach((rbd) => {
      const traj = RBD_TRAJ.get(rbd + "|" + nivel);
      if (!traj) return; // este EE no rinde este nivel
      const mtraj = RBD_MOTIVO.get(rbd + "|" + nivel) || null;
      const m = RBD_META.get(rbd);
      const serie = YEARS.map((y) => ({
        anio: y,
        categoria: traj.has(y) ? traj.get(y) : null,
        motivo: mtraj && mtraj.has(y) ? mtraj.get(y) : null,
      }));
      const vigente = traj.has(ANIO_VIGENTE) ? traj.get(ANIO_VIGENTE) : null;
      out.push({
        rbd,
        nom: m.nom || "RBD " + rbd,
        nom_com: m.nom_com,
        cod_com: m.cod_com,
        cod_depe2: m.cod_depe2,
        vigente,
        serie,
        nivel,
        mat_nivel_vig: matriculaNivel(rbd, nivel, ANIO_MAT_VIGENTE),
        mat_total_vig: matriculaTotalEE(rbd, ANIO_MAT_VIGENTE),
      });
    });
    return out.sort((a, b) => a.nom.localeCompare(b.nom, "es"));
  }

  // Distribución calculada desde una lista de EE ya filtrada (n_ee por categoría).
  // Útil para entidad = establecimiento y para reflejar filtros activos.
  function distribucionDesdeEE(listaEE) {
    const cats = {};
    CATEGORIAS.forEach((c) => {
      cats[c] = {
        n_ee: 0,
        pct: 0,
      };
    });
    let total = 0,
      matTotalNivel = 0;
    // matTotalNivel: matrícula del nivel mostrado sumada SOLO sobre los EE
    // categorizados (mismo universo que 'total'/pct de EE). Denominador para el
    // % de matrícula por categoría; coherente con el % de establecimientos.
    listaEE.forEach((ee) => {
      if (ee.vigente && cats[ee.vigente]) {
        cats[ee.vigente].n_ee += 1;
        total += 1;
        matTotalNivel += ee.mat_nivel_vig || 0;
      }
    });
    CATEGORIAS.forEach((c) => {
      cats[c].pct = total > 0 ? cats[c].n_ee / total : 0;
    });
    return {
      total,
      cats,
      matTotalNivel,
    };
  }
  return {
    YEARS,
    ANIO_VIGENTE,
    ANIO_MAT_VIGENTE,
    CATEGORIAS,
    CAT_COLORS,
    CAT_LABELS,
    NIVELES,
    MOTIVOS,
    DEPE_LABELS,
    ENSE2_LABELS,
    ENSE2_A_NIVEL,
    REGIONES,
    SLEPS,
    COMUNA_BY_COD,
    ESTAB_CAT,
    getDistribucion,
    getSinVigente,
    getEstablecimientos,
    distribucionDesdeEE,
    matriculaNivel,
    matriculaTotalEE,
    matriculaDesglose,
    matriculaSerieNivel,
  };
})();

// ============================================================
// Utilidades de formato chileno
// ============================================================
function fmtPct1(v) {
  if (v == null) return "—";
  return (v * 100).toFixed(1).replace(".", ",") + "%";
}
function fmtInt(v) {
  if (v == null) return "—";
  return v.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
}

// ============================================================
// Narrativa territorial — arma el párrafo de resumen por composición.
// Devuelve frases como arrays de fragmentos JSX (datos dinámicos en
// <strong>). Maneja casos borde: categorías con 0 EE se omiten; el sujeto
// cambia según el tipo de entidad. La matrícula contrasta desempeño "Medio
// o Alto" vs "Insuficiente" (Medio-Bajo se omite del párrafo de matrícula);
// anclada a la matrícula vigente (2025), la categoría sigue siendo 2019.
// Los porcentajes de matrícula se calculan sobre el total del nivel, así que
// al omitir Medio-Bajo los dos tramos no suman 100% (queda implícito).
// ============================================================
function narrativaTerritorial(entity, nivel, dist, porCat) {
  const nivelLbl = CatData.NIVELES[nivel] || nivel;
  const anioCat = CatData.ANIO_VIGENTE; // 2019
  const anioMat = CatData.ANIO_MAT_VIGENTE; // 2025
  const total = dist.total;
  let kk = 0;
  const b = (txt) => (
    <span key={"b" + kk++} className="dato-destacado">
      {txt}
    </span>
  ); // dato dinámico

  // Sujeto según tipo de entidad (el nombre va en negrita).
  const sujetoPre = (function () {
    if (entity.kind === "slep") return "El SLEP ";
    if (entity.kind === "comuna") return "La comuna de ";
    if (entity.kind === "region") return "La región de ";
    if (entity.kind === "establecimiento") return "El establecimiento ";
    return "";
  })();

  // Frase 1: cuántos EE categorizados.
  if (total === 0) {
    return {
      frases: [
        [
          sujetoPre,
          b(entity.nom),
          " no tiene establecimientos con " + nivelLbl + " categorizados al año ",
          b(anioCat),
          " para la selección actual.",
        ],
      ],
      vacio: true,
    };
  }
  const eeLbl = total === 1 ? "establecimiento" : "establecimientos";
  const frase1 = [
    sujetoPre,
    b(entity.nom),
    " tiene ",
    b(fmtInt(total)),
    " " +
      eeLbl +
      " con " +
      nivelLbl +
      " " +
      (total === 1 ? "categorizado" : "categorizados") +
      " al año ",
    b(anioCat),
    ", el año más reciente para el cual existe una clasificación.",
  ];

  // Frase 2: distribución por categoría, omitiendo las de 0 EE.
  // "Un X% de estos establecimientos está en nivel de desempeño Alto, un Y%
  //  en Medio, ...". Orden de presentación Alto -> Insuficiente.
  const ordenPresenta = ["ALTO", "MEDIO", "MEDIO-BAJO", "INSUFICIENTE"];
  const presentes = ordenPresenta.filter((c) => dist.cats[c] && dist.cats[c].n_ee > 0);
  let frase2 = null;
  if (presentes.length === 1) {
    const c = presentes[0];
    frase2 = ["Todos están en nivel de desempeño ", b(CatData.CAT_LABELS[c] || c), "."];
  } else if (presentes.length > 1) {
    const segs = [];
    presentes.forEach((c, i) => {
      const pct = b(fmtPct1(dist.cats[c].pct));
      const lbl = CatData.CAT_LABELS[c] || c;
      if (i === 0) {
        segs.push("Un ", pct, " de estos establecimientos está en nivel de desempeño " + lbl);
      } else {
        const sep = i === presentes.length - 1 ? " y un " : ", un ";
        segs.push(sep, pct, " en " + lbl);
      }
    });
    segs.push(".");
    frase2 = segs;
  }

  // Frase 3: matrícula. Contraste Medio+Alto vs Insuficiente (B2). Suma
  // mat_nivel_vig (2025); denominador = matrícula total del nivel
  // categorizado (incluye Medio-Bajo, aunque no se nombre).
  const sumaMat = (cats) =>
    cats.reduce(
      (acc, c) => acc + (porCat[c] || []).reduce((a, e) => a + (e.mat_nivel_vig || 0), 0),
      0,
    );
  const matMedioAlto = sumaMat(["ALTO", "MEDIO"]);
  const matInsuf = sumaMat(["INSUFICIENTE"]);
  const matTotalNivel = sumaMat(["ALTO", "MEDIO", "MEDIO-BAJO", "INSUFICIENTE"]);
  let frase3 = null;
  if (matTotalNivel > 0) {
    const segs = ["Considerando la matrícula ", b(anioMat), ", "];
    const tramos = [];
    if (matMedioAlto > 0) {
      tramos.push([
        b(fmtInt(matMedioAlto)),
        " " +
          (matMedioAlto === 1 ? "estudiante asiste" : "estudiantes asisten") +
          " a un establecimiento de desempeño Medio o Alto (",
        b(fmtPct1(matMedioAlto / matTotalNivel)),
        " de la matrícula del nivel)",
      ]);
    }
    if (matInsuf > 0) {
      tramos.push([
        b(fmtInt(matInsuf)),
        " " + (matInsuf === 1 ? "asiste" : "asisten") + " a uno de desempeño Insuficiente (",
        b(fmtPct1(matInsuf / matTotalNivel)),
        ")",
      ]);
    }
    tramos.forEach((t, i) => {
      if (i > 0) segs.push(", y ");
      t.forEach((x) => segs.push(x));
    });
    segs.push(".");
    frase3 = segs;
  }

  // Frase de cierre (transición a la tabla); formato normal.
  const cierre = [
    "A continuación se presenta el detalle de los establecimientos y su " +
      "registro histórico de categorizaciones, junto con aquellos sin categoría vigente.",
  ];
  return {
    frases: [frase1, frase2, frase3, cierre].filter(Boolean),
    vacio: false,
  };
}

// ============================================================
// Header
// ============================================================
function Header() {
  return (
    <header className="app-header">
      <div className="app-header-inner">
        <div className="app-header-left">
          <div className="brand-eyebrow-row">
            <span className="brand-eyebrow">SLEP Costa Central</span>
            <span className="brand-divider">·</span>
            <span className="brand-eyebrow brand-eyebrow-muted">Motor de comparación</span>
          </div>
          <h1 className="app-title">
            Categoría de Desempeño
            <span className="app-title-sub"> — distribución de establecimientos</span>
          </h1>
          <p className="app-subtitle">
            Datos 2016–2019 · Sistema de Aseguramiento de la Calidad de la Educación
          </p>
          <p className="app-objective">
            Herramienta de análisis interno del SLEP Costa Central para visualizar cómo se
            distribuyen los establecimientos según su <strong>Categoría de Desempeño</strong> (Alto,
            Medio, Medio-Bajo, Insuficiente), comparando comunas, SLEPs, regiones o un
            establecimiento individual.
          </p>
        </div>
      </div>
    </header>
  );
}
function Segmented({ value, options, onChange }) {
  const opts = options.map((o) =>
    typeof o === "string"
      ? {
          value: o,
          label: o,
        }
      : o,
  );
  return (
    <div className="segmented" role="tablist">
      {opts.map((o) => (
        <button
          key={o.value}
          role="tab"
          aria-selected={value === o.value}
          className={"segmented-btn" + (value === o.value ? " is-active" : "")}
          onClick={() => onChange(o.value)}
        >
          {o.label}
        </button>
      ))}
    </div>
  );
}

// ============================================================
// Selector de entidad (modal: comuna / SLEP / región / establecimiento)
// ============================================================
function EntityModal({ onSelect, onCancel, multiple = false, yaElegidas = [], limite = 10 }) {
  const [tab, setTab] = React.useState("comuna");
  const [q, setQ] = React.useState("");
  const [sel, setSel] = React.useState([]); // selección acumulada (solo modo múltiple)
  const ql = q.trim().toLowerCase();
  const claveDe = (it) => it.kind + "|" + it.cod;
  const yaSet = new Set(yaElegidas.map(claveDe));
  const selSet = new Set(sel.map(claveDe));
  const cupo = limite - yaElegidas.length; // cuántas más caben

  const toggleSel = (item) => {
    const k = claveDe(item);
    if (yaSet.has(k)) return; // ya está en la comparativa
    setSel((prev) => {
      if (prev.some((p) => claveDe(p) === k)) return prev.filter((p) => claveDe(p) !== k);
      if (prev.length >= cupo) return prev; // respeta el tope de 10
      return [...prev, item];
    });
  };
  let list = [];
  if (tab === "comuna") {
    list = DATA.comunas
      .filter((c) => !ql || c.nom.toLowerCase().includes(ql))
      .map((c) => ({
        kind: "comuna",
        cod: String(c.cod),
        nom: c.nom,
        sub: c.nom_reg,
      }));
  } else if (tab === "slep") {
    list = CatData.SLEPS.filter((s) => !ql || s.nom.toLowerCase().includes(ql)).map((s) => ({
      kind: "slep",
      cod: s.cod,
      nom: s.nom,
      rbds: DATA.sleps.filter((r) => String(r.cod_slep) === s.cod).map((r) => String(r.rbd)),
      sub: "Traspaso " + s.anio_traspaso,
    }));
  } else if (tab === "region") {
    list = CatData.REGIONES.filter((r) => !ql || r.nom.toLowerCase().includes(ql)).map((r) => ({
      kind: "region",
      cod: r.cod,
      nom: r.nom,
      sub: r.comunas.length + " comunas",
    }));
  } else {
    // establecimiento: requiere búsqueda (catálogo grande); limitar resultados.
    list = ql
      ? CatData.ESTAB_CAT.filter(
          (e) => e.nom.toLowerCase().includes(ql) || String(e.rbd).includes(ql),
        )
          .slice(0, 60)
          .map((e) => ({
            kind: "establecimiento",
            cod: e.rbd,
            nom: e.nom,
            sub: (e.nom_com || "") + " · RBD " + e.rbd,
          }))
      : [];
  }
  const tabs = [
    ["comuna", "Comuna"],
    ["slep", "SLEP"],
    ["region", "Región"],
    ["establecimiento", "Establecimiento"],
  ];
  return (
    <div className="modal-backdrop" onClick={onCancel}>
      <div className="modal" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h2 className="modal-title">
            {multiple ? "Agregar territorios" : "Seleccionar territorio"}
          </h2>
        </div>
        <div className="modal-tabs">
          {tabs.map(([k, lbl]) => (
            <button
              key={k}
              className={"modal-tab" + (tab === k ? " is-active" : "")}
              onClick={() => {
                setTab(k);
                setQ("");
              }}
            >
              {lbl}
            </button>
          ))}
        </div>
        <div className="modal-body">
          <input
            className="input-search"
            placeholder={tab === "establecimiento" ? "Buscar por nombre o RBD…" : "Buscar…"}
            value={q}
            onChange={(e) => setQ(e.target.value)}
            autoFocus={true}
            style={{
              width: "100%",
              padding: "8px 10px",
              marginBottom: 10,
              border: "1px solid var(--border-2)",
              borderRadius: "var(--radius-2)",
              fontFamily: "var(--font-body)",
              fontSize: "var(--fs-base)",
            }}
          />
          {multiple && (
            <div className="modal-hint-multi">
              {cupo <= 0
                ? "Ya alcanzaste el máximo de " + limite + " territorios."
                : "Selecciona hasta " +
                  cupo +
                  " " +
                  (cupo === 1 ? "territorio más" : "territorios más") +
                  " · marcados: " +
                  sel.length}
            </div>
          )}
          <div
            className="comuna-checklist"
            style={{
              maxHeight: 320,
            }}
          >
            {list.length === 0 && (
              <div className="empty-state">
                {tab === "establecimiento" && !ql
                  ? "Escribe para buscar un establecimiento"
                  : "Sin resultados"}
              </div>
            )}
            {list.map((item) => {
              const k = claveDe(item);
              const yaEsta = yaSet.has(k);
              const marcado = selSet.has(k);
              const bloqueado = !multiple ? false : yaEsta || (!marcado && sel.length >= cupo);
              return (
                <div
                  key={k}
                  className={
                    "check-row" +
                    (multiple && marcado ? " is-checked" : "") +
                    (bloqueado ? " is-disabled" : "")
                  }
                  onClick={() => {
                    if (!multiple) {
                      onSelect(item);
                      return;
                    }
                    if (bloqueado) return;
                    toggleSel(item);
                  }}
                >
                  {multiple && (
                    <span
                      className={"check-box" + (marcado ? " is-on" : "") + (yaEsta ? " is-ya" : "")}
                    >
                      {(marcado || yaEsta) && (
                        <svg
                          viewBox="0 0 16 16"
                          width="12"
                          height="12"
                          fill="none"
                          stroke="currentColor"
                          strokeWidth="2.5"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        >
                          <polyline points="3 8 7 12 13 4" />
                        </svg>
                      )}
                    </span>
                  )}
                  <span className="check-name">{item.nom}</span>
                  <span className="check-region">{yaEsta ? "ya agregado" : item.sub}</span>
                </div>
              );
            })}
          </div>
        </div>
        <div className="modal-footer">
          <button className="estab-popup-btn" onClick={onCancel}>
            Cancelar
          </button>
          {multiple && (
            <button
              className="estab-popup-btn is-primary"
              disabled={sel.length === 0}
              onClick={() => onSelect(sel)}
            >
              Agregar{sel.length > 0 ? " (" + sel.length + ")" : ""}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

// ============================================================
// Trayectoria (año arriba, marca de color abajo; reciente -> antiguo)
// ============================================================
function Trayectoria({ serie }) {
  // Orden descendente: el año más reciente primero.
  const ordenada = serie.slice().sort((a, b) => b.anio - a.anio);
  return (
    <span className="traj">
      {ordenada.map((p, idx) => {
        const esSi = p.categoria == null || p.categoria === "s/i";
        const color = esSi ? null : CatData.CAT_COLORS[p.categoria];
        const esVigente = p.anio === CatData.ANIO_VIGENTE;
        return (
          <span key={p.anio} className="traj-year">
            <span className={"traj-year-lbl" + (esVigente ? " is-vigente" : "")}>{p.anio}</span>
            <span
              className={"traj-mark" + (esSi ? " is-si" : "") + (esVigente ? " is-vigente" : "")}
              style={
                esSi
                  ? null
                  : {
                      background: color,
                    }
              }
              title={
                p.anio +
                ": " +
                (esSi
                  ? "Sin categoría" +
                    (p.motivo ? " — " + (CatData.MOTIVOS[p.motivo] || p.motivo) : "")
                  : CatData.CAT_LABELS[p.categoria]) +
                (esVigente ? " (vigente)" : "")
              }
            />
          </span>
        );
      })}
    </span>
  );
}

// ============================================================
// Fila de establecimiento (clickeable: despliega trayectoria en texto)
// ============================================================
// Item de un tipo de enseñanza en el desglose de la ficha. Si el tipo tiene
// desglose por grado (básica 2, media 5/7), muestra un control colapsable con
// el reparto por grado; colapsado por defecto. Si no hay grado, solo la cifra.
function EnseItem({ d }) {
  return (
    <li className={"ee-ense-item" + (d.nivel ? " has-cat" : "")}>
      <div className="ee-ense-head">
        <span className="ee-ense-label">{d.label + ":"}</span>
        <span className="ee-ense-mat">{fmtInt(d.matricula)}</span>
      </div>
    </li>
  );
}
function EeRow({ ee }) {
  const [open, setOpen] = React.useState(false);
  const serieDesc = ee.serie.slice().sort((a, b) => b.anio - a.anio);
  return (
    <li className="ee-row-li">
      <div
        className={"ee-row" + (open ? " is-open" : "")}
        role="button"
        tabIndex={0}
        aria-expanded={open}
        onClick={() => setOpen((o) => !o)}
        onKeyDown={(e) => {
          if (e.key === "Enter" || e.key === " ") {
            e.preventDefault();
            setOpen((o) => !o);
          }
        }}
      >
        <span className="ee-row-main">
          <span className="ee-row-name">{ee.nom}</span>
          <span className="ee-row-meta">
            {ee.nom_com && <span>{ee.nom_com}</span>}
            {ee.nom_com && <span className="ee-row-sep">·</span>}
            <span>{CatData.DEPE_LABELS[ee.cod_depe2] || "Dependencia s/i"}</span>
            <span className="ee-row-sep">·</span>
            <span className="ee-row-rbd">RBD {ee.rbd}</span>
            {ee.mat_nivel_vig != null && (
              <React.Fragment>
                <span className="ee-row-sep">·</span>
                <span className="ee-row-matricula">
                  {"Matrícula " +
                    CatData.ANIO_MAT_VIGENTE +
                    ": " +
                    fmtInt(ee.mat_nivel_vig) +
                    " en " +
                    (CatData.NIVELES[ee.nivel] || ee.nivel)}
                  {ee.mat_total_vig != null &&
                    ee.mat_total_vig !== ee.mat_nivel_vig &&
                    " · " + fmtInt(ee.mat_total_vig) + " en total"}
                </span>
              </React.Fragment>
            )}
          </span>
        </span>
        <Trayectoria serie={ee.serie} />
      </div>
      {open && (
        <div className="ee-detail">
          <span className="ee-detail-title">Trayectoria y matrícula por año</span>
          <ul className="ee-detail-list">
            {serieDesc.map((p) => {
              const sinMedicion = p.categoria == null;
              const esSi = sinMedicion || p.categoria === "s/i";
              const color = esSi ? null : CatData.CAT_COLORS[p.categoria];
              const esVigente = p.anio === CatData.ANIO_VIGENTE;
              let txt;
              if (sinMedicion) txt = "Sin medición";
              else if (p.categoria === "s/i")
                txt =
                  "Sin categoría" +
                  (p.motivo ? " · " + (CatData.MOTIVOS[p.motivo] || p.motivo) : "");
              else txt = CatData.CAT_LABELS[p.categoria];
              const matNivel = CatData.matriculaNivel(ee.rbd, ee.nivel, p.anio);
              const desglose = CatData.matriculaDesglose(ee.rbd, p.anio);
              const totalEE = CatData.matriculaTotalEE(ee.rbd, p.anio);
              return (
                <li
                  key={p.anio}
                  className={"ee-detail-row" + (esVigente ? " is-vigente" : "")}
                >
                  <div className="ee-detail-head">
                    <span className="ee-detail-year">
                      {p.anio}
                      {esVigente ? " (vigente)" : ""}
                    </span>
                    <span
                      className="ee-detail-mark"
                      style={
                        color
                          ? {
                              background: color,
                            }
                          : null
                      }
                      data-si={esSi ? "1" : null}
                    />
                    <span className="ee-detail-cat">{txt}</span>
                  </div>
                  {matNivel != null && (
                    <div className="ee-detail-matnivel">
                      {fmtInt(matNivel) +
                        " matriculados en " +
                        (CatData.NIVELES[ee.nivel] || ee.nivel)}
                    </div>
                  )}
                  {desglose.length > 0 && (
                    <React.Fragment>
                      <div className="ee-detail-ense-head">
                        <span className="ee-detail-ense-col-nivel">Nivel</span>
                        <span className="ee-detail-ense-col-mat">N° de estudiantes</span>
                      </div>
                      <ul className="ee-detail-ense-list">
                        {desglose.map((d) => (
                          <EnseItem key={d.cod_ense2} d={d} />
                        ))}
                      </ul>
                    </React.Fragment>
                  )}
                  {totalEE != null && (
                    <div className="ee-detail-ense-total">
                      <span className="ee-ense-label">Total establecimiento:</span>
                      <span className="ee-ense-mat">{fmtInt(totalEE)}</span>
                    </div>
                  )}
                </li>
              );
            })}
          </ul>
          {(() => {
            // Evolución de la matrícula del nivel mostrado a lo largo de los años
            // disponibles. Dato de tamaño, separado de la trayectoria de categoría.
            const serieMat = CatData.matriculaSerieNivel(ee.rbd, ee.nivel);
            const conDato = serieMat.filter((s) => s.mat != null);
            if (conDato.length < 2) return null; // sin evolución que mostrar
            const ini = conDato[0],
              fin = conDato[conDato.length - 1];
            const delta = fin.mat - ini.mat;
            const signo = delta > 0 ? "+" : "";
            const pctVar = ini.mat > 0 ? delta / ini.mat : null;
            const dirCls = delta > 0 ? " is-up" : delta < 0 ? " is-down" : "";
            return (
              <div className="ee-detail-evol">
                <span className="ee-detail-evol-title">
                  {"Evolución de la matrícula en " + (CatData.NIVELES[ee.nivel] || ee.nivel)}
                </span>
                <ul className="ee-evol-list">
                  {serieMat.map((s) => (
                    <li key={s.anio} className="ee-evol-item">
                      <span className="ee-evol-year">{s.anio}</span>
                      <span className="ee-evol-val">{s.mat != null ? fmtInt(s.mat) : "—"}</span>
                    </li>
                  ))}
                </ul>
                <div className={"ee-detail-evol-delta" + dirCls}>
                  {ini.anio +
                    "→" +
                    fin.anio +
                    ": " +
                    signo +
                    fmtInt(delta) +
                    (pctVar != null ? " (" + signo + fmtPct1(pctVar) + ")" : "")}
                </div>
              </div>
            );
          })()}
        </div>
      )}
    </li>
  );
}

// ============================================================
// Columna de categoría
// ============================================================
function CatColumn({ categoria, stat, establecimientos, matTotal }) {
  const color = CatData.CAT_COLORS[categoria];
  const label = CatData.CAT_LABELS[categoria];
  // pct autoritativo desde el territorial (n_ee/n_categorizados ya calculado en R).
  const pct = stat.pct != null ? stat.pct : stat.total > 0 ? stat.n_ee / stat.total : 0;
  // Matrícula del nivel mostrado, sumada sobre los EE de esta categoría. Dato de
  // contexto aditivo; NO interviene en el pct (que es conteo de EE). mat_nivel_vig
  // puede ser null (EE sin ese nivel ese año) -> cuenta 0.
  const matNivel = establecimientos.reduce((s, ee) => s + (ee.mat_nivel_vig || 0), 0);
  // % de matrícula: fracción de estudiantes del nivel del territorio (solo EE
  // categorizados, mismo universo que el % de establecimientos) que asiste a EE
  // de esta categoría. No pondera la categoría; es lectura paralela al % de EE.
  const matPct = matTotal > 0 ? matNivel / matTotal : null;
  return (
    <div className="cat-col">
      <div
        className="cat-col-head"
        style={{
          background: color,
        }}
      >
        <span className="cat-col-title">{label}</span>
        <span className="cat-col-stat">
          <strong>{fmtInt(stat.n_ee)}</strong>{" "}
          {stat.n_ee === 1 ? "establecimiento" : "establecimientos"}
          {pct != null && " (" + fmtPct1(pct) + " del total del nivel para el territorio)"}
        </span>
        <span className="cat-col-mat">
          <strong>{fmtInt(matNivel)}</strong> estudiantes
          {matPct != null && " (" + fmtPct1(matPct) + " del total del nivel para el territorio)"}
        </span>
      </div>
      <div className="cat-col-bar">
        <div
          className="cat-col-bar-fill"
          style={{
            width: (pct * 100).toFixed(1) + "%",
          }}
        />
      </div>
      {establecimientos.length === 0 ? (
        <div className="cat-col-empty">Sin establecimientos en esta categoría</div>
      ) : (
        <ul className="cat-col-list">
          {establecimientos.map((ee) => (
            <EeRow key={ee.rbd} ee={ee} />
          ))}
        </ul>
      )}
    </div>
  );
}

// ============================================================
// Sección sin categoría vigente
// ============================================================
function SinVigente({ sv, listaEE, listaSinMedicion }) {
  const motivos = Object.keys(sv);
  const total = motivos.reduce((a, m) => a + sv[m], 0);
  const lista = listaEE || [];
  const listaSM = listaSinMedicion || [];
  if (motivos.length === 0 && lista.length === 0 && listaSM.length === 0) return null;
  return (
    <div className="sin-vigente">
      <h3 className="sin-vigente-title">Sin categoría vigente</h3>
      <p className="sin-vigente-sub">
        {fmtInt(total)} establecimientos sin categoría en {CatData.ANIO_VIGENTE} (conteo oficial).
        No entran en la distribución de las cuatro categorías.
      </p>
      {motivos.length > 0 && (
        <div className="sin-vigente-motivos">
          {motivos.map((m) => (
            <div key={m} className="sin-vigente-motivo">
              <span className="sin-vigente-n">{fmtInt(sv[m])}</span>
              <span className="sin-vigente-lbl">{CatData.MOTIVOS[m] || m}</span>
            </div>
          ))}
        </div>
      )}
      {lista.length > 0 && (
        <div className="sin-vigente-lista">
          <span className="sin-vigente-lista-head">
            Establecimientos identificados ({fmtInt(lista.length)}) · click para ver su trayectoria
          </span>
          <ul className="cat-col-list sin-vigente-ul">
            {lista.map((ee) => (
              <EeRow key={ee.rbd} ee={ee} />
            ))}
          </ul>
        </div>
      )}
      {listaSM.length > 0 && (
        <div className="sin-vigente-lista">
          <span className="sin-vigente-lista-head">
            Sin categoría de desempeño en {CatData.ANIO_VIGENTE} ({fmtInt(listaSM.length)}) · click
            para ver su trayectoria
          </span>
          <ul className="cat-col-list sin-vigente-ul">
            {listaSM.map((ee) => (
              <EeRow key={ee.rbd} ee={ee} />
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}

// ============================================================
// Filtro de chips multi-select (comuna, dependencia); todas activas por defecto.
// ============================================================
function ChipFilter({ titulo, items, activas, onToggle }) {
  if (items.length <= 1) return null; // sin filtro si hay un solo valor
  return (
    <div className="chip-filter">
      <span className="chip-filter-title">{titulo}</span>
      <div className="chip-filter-chips">
        {items.map((it) => {
          const on = activas.has(it.cod);
          return (
            <button
              key={it.cod}
              className={"filter-chip" + (on ? " is-on" : "")}
              onClick={() => onToggle(it.cod)}
            >
              {it.nom}
            </button>
          );
        })}
      </div>
    </div>
  );
}

// ============================================================
// Hoja comparativa: comparación entre territorios (segunda hoja)
// ============================================================

// Filtro de dependencia para la comparativa: ofrece el universo de
// dependencias del catálogo (no las presentes en una entidad puntual,
// porque el conjunto de entidades es heterogéneo). "Todas" = sin filtro.
function CmpDepFilter({ depActiva, onChange }) {
  const items = Object.entries(CatData.DEPE_LABELS)
    .map(([cod, nom]) => ({
      cod,
      nom,
    }))
    .sort((a, b) => a.cod.localeCompare(b.cod));
  return (
    <div className="chip-filter">
      <span className="chip-filter-title">Dependencia</span>
      <div className="chip-filter-chips">
        <button
          className={"filter-chip" + (depActiva === null ? " is-on" : "")}
          onClick={() => onChange(null)}
        >
          Todas
        </button>
        {items.map((it) => (
          <button
            key={it.cod}
            className={"filter-chip" + (depActiva === it.cod ? " is-on" : "")}
            onClick={() => onChange(it.cod)}
          >
            {it.nom}
          </button>
        ))}
      </div>
    </div>
  );
}

// Distribución n/% por categoría + sin-vigente, desde los EE de una
// entidad en un nivel, aplicando el filtro de dependencia global.
// Cuenta EE (sin ponderación, sin GSE); el % es n_categoria / n_categorizados.
function distEntidadComparativa(entity, nivel, depActiva) {
  const todos = CatData.getEstablecimientos(entity, nivel);
  const ee =
    depActiva === null ? todos : todos.filter((e) => String(e.cod_depe2) === String(depActiva));
  const cats = {};
  CatData.CATEGORIAS.forEach((c) => {
    cats[c] = {
      n_ee: 0,
      pct: 0,
      mat: 0,
    };
  });
  let categorizados = 0,
    sinVigente = 0,
    matTotalNivel = 0;
  // mat: suma de la matrícula del nivel mostrado (no el total del EE) sobre los
  // EE de cada categoría. Dato de contexto aditivo; NO altera el pct, que sigue
  // siendo conteo de establecimientos. mat_nivel_vig puede ser null (EE sin ese
  // nivel ese año) -> cuenta 0. matTotalNivel: mismo dato sobre TODOS los EE
  // categorizados (denominador del % de matrícula; mismo universo que el % de EE).
  ee.forEach((e) => {
    if (e.vigente && cats[e.vigente]) {
      cats[e.vigente].n_ee += 1;
      cats[e.vigente].mat += e.mat_nivel_vig || 0;
      matTotalNivel += e.mat_nivel_vig || 0;
      categorizados += 1;
    } else {
      sinVigente += 1;
    }
  });
  CatData.CATEGORIAS.forEach((c) => {
    cats[c].pct = categorizados > 0 ? cats[c].n_ee / categorizados : 0;
  });
  return {
    cats,
    total: categorizados,
    sinVigente,
    matTotalNivel,
  };
}
function ComparativaSheet({ nivel, depActiva, onDepChange }) {
  const [entidades, setEntidades] = React.useState([]); // máx 4
  const [picker, setPicker] = React.useState(false);
  const LIMITE = 10;
  const addEntity = (itemOrList) => {
    const nuevos = Array.isArray(itemOrList) ? itemOrList : [itemOrList];
    setEntidades((prev) => {
      const clave = (e) => e.kind + "|" + e.cod;
      const vistos = new Set(prev.map(clave));
      const acc = [...prev];
      for (const it of nuevos) {
        const k = clave(it);
        if (vistos.has(k)) continue; // sin duplicados
        if (acc.length >= LIMITE) break; // respeta el tope de 10
        acc.push(it);
        vistos.add(k);
      }
      return acc;
    });
    setPicker(false);
  };
  const removeEntity = (item) => {
    const clave = (e) => e.kind + "|" + e.cod;
    setEntidades((prev) => prev.filter((e) => clave(e) !== clave(item)));
  };
  const KIND_LBL = {
    comuna: "Comuna",
    slep: "SLEP",
    region: "Región",
    establecimiento: "Estab.",
  };

  // Distribución por columna (memoizada por entidades, nivel y filtro).
  const cols = React.useMemo(
    () =>
      entidades.map((e) => ({
        entity: e,
        dist: distEntidadComparativa(e, nivel, depActiva),
      })),
    [entidades, nivel, depActiva],
  );

  // % máximo por categoría (para destacar la columna líder en cada fila).
  const maxPctPorCat = {};
  CatData.CATEGORIAS.forEach((c) => {
    maxPctPorCat[c] = Math.max(0, ...cols.map((col) => col.dist.cats[c].pct));
  });

  // Resalte cruzado: índice de fila y columna bajo el cursor.
  const [hl, setHl] = React.useState({
    fila: null,
    col: null,
  });
  const limpiarHl = () =>
    setHl({
      fila: null,
      col: null,
    });

  // Mapa de calor por fila: cada categoría usa SU color; la intensidad del
  // fondo es proporcional al % dentro de la fila, normalizada al máximo de
  // esa fila. La intensidad expresa concentración de la categoría en el
  // territorio (no gravedad: en Alto, más intenso = más establecimientos Alto).
  const hexToRgba = (hex, alfa) => {
    const h = String(hex).replace("#", "");
    const r = parseInt(h.length === 3 ? h[0] + h[0] : h.slice(0, 2), 16);
    const g = parseInt(h.length === 3 ? h[1] + h[1] : h.slice(2, 4), 16);
    const b = parseInt(h.length === 3 ? h[2] + h[2] : h.slice(4, 6), 16);
    return "rgba(" + r + ", " + g + ", " + b + ", " + alfa.toFixed(3) + ")";
  };
  const fondoHeat = (categoria, pct) => {
    if (pct <= 0) return "transparent";
    const t = Math.min(1, pct / Math.max(0.0001, maxPctPorCat[categoria]));
    const alfa = 0.1 + t * 0.55; // de tenue a intenso
    return hexToRgba(CatData.CAT_COLORS[categoria], alfa);
  };
  const clsCol = (ci) => (hl.col === ci ? " is-hl-col" : "");
  const clsCelda = (fi, ci) =>
    hl.col === ci && hl.fila === fi ? " is-hl-cross" : hl.col === ci ? " is-hl-col" : "";
  return (
    <div className="cmp-sheet">
      <div className="cmp-picker">
        <span className="cmp-picker-label">Territorios a comparar</span>
        {entidades.map((e) => (
          <span key={e.kind + e.cod} className="cmp-chip">
            <span className="cmp-chip-kind">{KIND_LBL[e.kind] || e.kind}</span>
            {e.nom}
            <button className="cmp-chip-x" title="Quitar" onClick={() => removeEntity(e)}>
              ×
            </button>
          </span>
        ))}
        <button
          className="cmp-add-btn"
          disabled={entidades.length >= LIMITE}
          onClick={() => setPicker(true)}
        >
          + Agregar
        </button>
        {entidades.length > 0 && (
          <button className="cmp-clear-btn" onClick={() => setEntidades([])}>
            Limpiar
          </button>
        )}
        <span className="cmp-hint">
          {entidades.length >= LIMITE
            ? "Máximo " + LIMITE + " territorios (favorece la comparabilidad)"
            : "Hasta " + LIMITE + " · mezcla comuna, SLEP y región"}
        </span>
      </div>
      <CmpDepFilter depActiva={depActiva} onChange={onDepChange} />
      {entidades.length === 0 ? (
        <div className="cmp-empty">
          Agrega al menos dos territorios para comparar su distribución de establecimientos por
          categoría de desempeño.
        </div>
      ) : (
        <div className="cmp-table-wrap">
          <table className="cmp-table" onMouseLeave={limpiarHl}>
            <thead>
              <tr>
                <th className="cmp-corner">Categoría de desempeño</th>
                {cols.map((col, ci) => (
                  <th
                    key={col.entity.kind + col.entity.cod}
                    className={clsCol(ci)}
                    onMouseEnter={() =>
                      setHl((h) => ({
                        ...h,
                        col: ci,
                      }))
                    }
                  >
                    {col.entity.nom}
                    <span className="cmp-th-kind">
                      {KIND_LBL[col.entity.kind] || col.entity.kind}
                    </span>
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {CatData.CATEGORIAS.map((c, fi) => (
                <tr key={c} className={hl.fila === fi ? "is-hl-row" : ""}>
                  <td className="cmp-cat-cell">
                    {CatData.CAT_LABELS[c]}
                    <span
                      className="cmp-cat-dot"
                      style={{
                        background: CatData.CAT_COLORS[c],
                      }}
                    />
                  </td>
                  {cols.map((col, ci) => {
                    const v = col.dist.cats[c];
                    const esMax = col.dist.total > 0 && v.pct === maxPctPorCat[c] && v.pct > 0;
                    return (
                      <td
                        key={col.entity.kind + col.entity.cod}
                        className={
                          "cmp-cell cmp-cell-heat" + (esMax ? " is-max" : "") + clsCelda(fi, ci)
                        }
                        style={{
                          background: fondoHeat(c, v.pct),
                        }}
                        title={
                          fmtInt(v.mat) +
                          " estudiantes en " +
                          fmtInt(v.n_ee) +
                          (v.n_ee === 1 ? " establecimiento" : " establecimientos") +
                          " · " +
                          fmtPct1(
                            col.dist.matTotalNivel > 0 ? v.mat / col.dist.matTotalNivel : null,
                          ) +
                          " de la matrícula de " +
                          CatData.NIVELES[nivel]
                        }
                        onMouseEnter={() =>
                          setHl({
                            fila: fi,
                            col: ci,
                          })
                        }
                      >
                        <span className="cmp-cell-pct">{fmtPct1(v.pct)}</span>
                        <span className="cmp-cell-n">· {fmtInt(v.n_ee)} EE</span>
                      </td>
                    );
                  })}
                </tr>
              ))}
              <tr className="cmp-row-total">
                <td className="cmp-cat-cell">Total categorizados</td>
                {cols.map((col, ci) => (
                  <td
                    key={col.entity.kind + col.entity.cod}
                    className={clsCol(ci)}
                    onMouseEnter={() =>
                      setHl((h) => ({
                        ...h,
                        col: ci,
                      }))
                    }
                  >
                    <span className="cmp-cell-n">{fmtInt(col.dist.total)}</span>
                  </td>
                ))}
              </tr>
              <tr className="cmp-row-sv">
                <td
                  className="cmp-cat-cell"
                  style={{
                    fontStyle: "italic",
                  }}
                >
                  Sin categoría vigente
                </td>
                {cols.map((col, ci) => (
                  <td
                    key={col.entity.kind + col.entity.cod}
                    className={clsCol(ci)}
                    onMouseEnter={() =>
                      setHl((h) => ({
                        ...h,
                        col: ci,
                      }))
                    }
                  >
                    <span
                      className="cmp-cell-n"
                      style={{
                        fontWeight: "var(--fw-regular)",
                        marginLeft: 0,
                        color: "var(--fg-2)",
                      }}
                    >
                      {fmtInt(col.dist.sinVigente)}
                    </span>
                  </td>
                ))}
              </tr>
            </tbody>
          </table>
        </div>
      )}
      {picker && (
        <EntityModal
          multiple={true}
          yaElegidas={entidades}
          limite={LIMITE}
          onSelect={addEntity}
          onCancel={() => setPicker(false)}
        />
      )}
    </div>
  );
}

// ============================================================
// Notas metodológicas (panel colapsable al pie)
// ============================================================
function NotasMetodologicas() {
  const [abierto, setAbierto] = React.useState(false);
  return (
    <footer className="app-footer">
      <button
        className={"notes-toggle" + (abierto ? " is-open" : "")}
        onClick={() => setAbierto((v) => !v)}
        aria-expanded={abierto}
      >
        <svg
          className="icon"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <circle cx="12" cy="12" r="10" />
          <line x1="12" y1="16" x2="12" y2="12" />
          <line x1="12" y1="8" x2="12.01" y2="8" />
        </svg>
        Notas metodológicas
        <span className="chev">
          <svg
            className="icon"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <polyline points="6 9 12 15 18 9" />
          </svg>
        </span>
      </button>
      {abierto && (
        <div className="notes-body">
          <div className="notes-grid">
            <div className="note">
              <h4>Categoría de Desempeño</h4>
              <p>
                La Categoría de Desempeño es un{" "}
                <b>componente del Sistema de Aseguramiento de la Calidad de la Educación</b> de
                nuestro país, que clasifica a cada establecimiento educacional integrando sus
                resultados de aprendizaje (Simce y otros indicadores){" "}
                <b>junto con el contexto socioeconómico de sus estudiantes</b>. A diferencia del
                Simce por estudiante, es una <b>etiqueta por establecimiento</b>, no un puntaje
                individual, y por eso no se segmenta por GSE. La distribución se calcula sobre los
                establecimientos efectivamente categorizados; los sin categoría vigente se reportan
                aparte.
              </p>
              <p>
                Comprende cuatro categorías, de menor a mayor desempeño, definidas siempre respecto
                de <b>lo esperado para el contexto social</b> de los estudiantes del
                establecimiento:
              </p>
              <p>
                <b>Insuficiente:</b> resultados <b>muy por debajo</b> de lo esperado.
              </p>
              <p>
                <b>Medio-Bajo:</b> resultados <b>por debajo</b> de lo esperado.
              </p>
              <p>
                <b>Medio:</b> resultados <b>similares</b> a lo esperado.
              </p>
              <p>
                <b>Alto:</b> resultados que <b>sobresalen</b> respecto de lo esperado.
              </p>
              <p>
                La clasificación combina varios indicadores: <b>67%</b> proviene de los Estándares
                de Aprendizaje (la distribución de estudiantes en niveles Adecuado, Elemental e
                Insuficiente del Simce) y el <b>33%</b> restante se reparte entre puntaje Simce, su
                tendencia y los Indicadores de Desarrollo Personal y Social. El índice se ajusta
                luego por el contexto de los estudiantes y se calcula{" "}
                <b>por separado para básica y media</b>.
              </p>
            </div>
            <div className="note">
              <h4>Servicios Locales de Educación Pública (SLEP)</h4>
              <p>
                Los SLEP son los organismos públicos que, en el marco de la Ley 21.040 (Sistema de
                Educación Pública), asumen progresivamente la administración de los establecimientos
                que antes dependían de los municipios. Cada SLEP recibe sus establecimientos en un{" "}
                <b>año de traspaso</b> específico.
              </p>
              <p>
                En esta herramienta, los establecimientos se agrupan según su dependencia{" "}
                <b>actual</b>. Un SLEP agrupa a sus establecimientos en toda la serie histórica,
                incluidos los años anteriores a su traspaso, cuando la gestión era municipal. Por lo
                tanto,{" "}
                <b>
                  las cifras previas al año de traspaso no son atribuibles a la gestión del SLEP
                </b>
                , sino a la administración municipal de ese periodo.
              </p>
            </div>
            <div className="note">
              <h4>Conteo de establecimientos, sin ponderación</h4>
              <p>
                La distribución de un territorio (comuna, SLEP, región o nivel nacional) es el{" "}
                <b>conteo de establecimientos educacionales</b> en cada categoría, con su porcentaje
                sobre el total categorizado del territorio.
              </p>
              <p>
                A diferencia del Simce por estudiante,{" "}
                <b>no se promedia ni se pondera por matrícula</b>: cada establecimiento aporta una
                unidad a su categoría, independientemente de su tamaño. El porcentaje de una
                categoría es su número de establecimientos dividido por el total de establecimientos
                categorizados del territorio.
              </p>
              <p>
                Es una <b>elección deliberada</b> de esta herramienta: la pregunta que responde es
                cómo se distribuyen los <i>establecimientos</i> de un territorio entre categorías,
                no cuántos estudiantes hay en cada una. Una agregación ponderada por matrícula
                respondería una pregunta distinta y daría otra lectura.
              </p>
            </div>
            <div className="note">
              <h4>Sin segmentación por GSE</h4>
              <p>
                Esta herramienta <b>no segmenta por grupo socioeconómico (GSE)</b>. La Categoría de
                Desempeño ya incorpora el contexto socioeconómico de cada establecimiento en su
                propia construcción, de modo que volver a segmentar por GSE duplicaría una variable
                que la clasificación ya considera.
              </p>
            </div>
            <div className="note">
              <h4>Categoría vigente</h4>
              <p>
                La categoría que se muestra para cada establecimiento es la de su
                <b> último año disponible</b> ({CatData.ANIO_VIGENTE}). La trayectoria histórica a
                la derecha de cada fila muestra la categoría año a año.
              </p>
              <p>
                Los establecimientos <b>sin categoría en el último año</b> (por ejemplo, los que no
                rindieron las evaluaciones requeridas ese año) se reportan aparte y{" "}
                <b>no entran en el denominador</b> de la distribución. Por eso cada territorio
                informa, junto a su total categorizado, el número de establecimientos sin categoría
                vigente.
              </p>
            </div>
            <div className="note">
              <h4>Cobertura temporal</h4>
              <p>
                La serie cubre <b>2016 a 2019</b>. La Categoría de Desempeño en enseñanza básica
                está disponible desde 2016 y en enseñanza media desde 2017. La enseñanza básica y la
                media <b>nunca se combinan</b> en una misma cifra: el selector de nivel gobierna
                toda la vista.
              </p>
              <p>
                El <b>Simce 2019</b> se aplicó sin condiciones óptimas (estallido social) y se
                mantuvo la última categoría sin consecuencias. En{" "}
                <b>2020 y 2021 no hubo categorización</b> por la suspensión del Simce durante la
                pandemia, y el<b>Simce 2022</b>, aunque se aplicó, no se usó para ordenar. La
                próxima categorización se realizará con los <b>resultados del Simce 2025</b>, una
                vez que la Agencia de Calidad los procese y publique.
              </p>
            </div>
          </div>
          <div className="notes-sources">
            Fuente: Agencia de Calidad de la Educación, Categoría de Desempeño por establecimiento
            (enseñanza básica y media), 2016–2019. Información pública disponible en el portal de la
            Agencia.
          </div>
        </div>
      )}
    </footer>
  );
}

// ============================================================
// App
// ============================================================
function App() {
  const nivelOpts = Object.entries(CatData.NIVELES).map(([k, v]) => ({
    value: k,
    label: v,
  }));
  const [entity, setEntity] = React.useState(() => {
    // Semilla: SLEP Costa Central si existe; si no, el primer SLEP.
    const cc = CatData.SLEPS.find((s) => s.nom === "Costa Central") || CatData.SLEPS[0];
    return {
      kind: "slep",
      cod: cc.cod,
      nom: cc.nom,
      rbds: DATA.sleps.filter((r) => String(r.cod_slep) === cc.cod).map((r) => String(r.rbd)),
    };
  });
  const [nivel, setNivel] = React.useState("basica");
  const [modal, setModal] = React.useState(false);
  const [comunasOff, setComunasOff] = React.useState(() => new Set());
  const [depesOff, setDepesOff] = React.useState(() => new Set());
  const [hoja, setHoja] = React.useState("territorio"); // territorio | comparar
  const [cmpDep, setCmpDep] = React.useState(null); // null = todas las dependencias

  const sv = CatData.getSinVigente(entity.kind, entity.cod, nivel, CatData.ANIO_VIGENTE);
  const establecimientos = CatData.getEstablecimientos(entity, nivel);

  // Comunas presentes en la entidad (para el filtro).
  const comunasEntidad = React.useMemo(() => {
    const map = new Map();
    establecimientos.forEach((ee) => {
      if (ee.cod_com && !map.has(ee.cod_com)) map.set(ee.cod_com, ee.nom_com || ee.cod_com);
    });
    return Array.from(map.entries())
      .map(([cod, nom]) => ({
        cod,
        nom,
      }))
      .sort((a, b) => a.nom.localeCompare(b.nom, "es"));
  }, [establecimientos]);

  // Dependencias presentes en la entidad (para el filtro).
  const depesEntidad = React.useMemo(() => {
    const set = new Set();
    establecimientos.forEach((ee) => {
      if (ee.cod_depe2) set.add(ee.cod_depe2);
    });
    return Array.from(set)
      .map((cod) => ({
        cod,
        nom: CatData.DEPE_LABELS[cod] || "Dependencia " + cod,
      }))
      .sort((a, b) => a.cod.localeCompare(b.cod));
  }, [establecimientos]);

  // Al cambiar de entidad o nivel, resetear ambos filtros (todo activo).
  React.useEffect(() => {
    setComunasOff(new Set());
    setDepesOff(new Set());
  }, [entity, nivel]);
  const comActivas = new Set(comunasEntidad.map((c) => c.cod).filter((c) => !comunasOff.has(c)));
  const depActivas = new Set(depesEntidad.map((d) => d.cod).filter((d) => !depesOff.has(d)));
  const eeVisibles = establecimientos.filter(
    (ee) =>
      (!ee.cod_com || comActivas.has(ee.cod_com)) &&
      (!ee.cod_depe2 || depActivas.has(ee.cod_depe2)),
  );

  // Distribución del header desde los EE visibles (refleja filtros).
  const dist = CatData.distribucionDesdeEE(eeVisibles);

  // Agrupar EE visibles por categoría vigente.
  const porCat = {};
  CatData.CATEGORIAS.forEach((c) => {
    porCat[c] = [];
  });
  eeVisibles.forEach((ee) => {
    if (ee.vigente && porCat[ee.vigente]) porCat[ee.vigente].push(ee);
  });

  // EE evaluados pero sin categoría en el año vigente (s/i), respetando filtros.
  // Población coherente con el conteo del parquet.
  const sinVigenteEE = eeVisibles.filter((ee) => ee.vigente === "s/i");

  // EE sin medición en el año vigente (vigente null: no tienen fila 2019 en su
  // trayectoria). Bucket distinto de "s/i"; no entra en el conteo del parquet
  // ni en la distribución de las cuatro categorías. Solo navegación.
  const sinMedicionEE = eeVisibles.filter((ee) => ee.vigente === null);
  const toggle = (setter) => (cod) =>
    setter((prev) => {
      const next = new Set(prev);
      if (next.has(cod)) next.delete(cod);
      else next.add(cod);
      return next;
    });
  return (
    <div className="app is-comfy">
      <Header />
      <section className="controls-bar">
        <div className="control-group">
          <span className="control-label">Vista</span>
          <Segmented
            value={hoja}
            options={[
              {
                value: "territorio",
                label: "Por territorio",
              },
              {
                value: "comparar",
                label: "Comparar territorios",
              },
            ]}
            onChange={setHoja}
          />
        </div>
        {hoja === "territorio" && (
          <div className="control-group">
            <span className="control-label">Territorio</span>
            <button className="entity-select-btn" onClick={() => setModal(true)}>
              {entity.nom} ▾
            </button>
          </div>
        )}
        <div className="control-group">
          <span className="control-label">Nivel</span>
          <Segmented value={nivel} options={nivelOpts} onChange={setNivel} />
        </div>
      </section>
      {hoja === "territorio" ? (
        <main className="app-main">
          <div className="terr-narrativa">
            <h2 className="terr-narrativa-name">{entity.nom}</h2>
            {narrativaTerritorial(entity, nivel, dist, porCat).frases.map((f, i) => (
              <p key={i} className="terr-narrativa-p">
                {f}
              </p>
            ))}
          </div>
          <ChipFilter
            titulo="Filtra por comuna:"
            items={comunasEntidad}
            activas={comActivas}
            onToggle={toggle(setComunasOff)}
          />
          <ChipFilter
            titulo="Filtra por dependencia:"
            items={depesEntidad}
            activas={depActivas}
            onToggle={toggle(setDepesOff)}
          />
          <div className="traj-legend">
            <span className="traj-legend-head">
              Trayectoria {CatData.YEARS[0]}–{CatData.YEARS[CatData.YEARS.length - 1]}
            </span>
            <div className="traj-legend-items">
              {CatData.CATEGORIAS.map((c) => (
                <span key={c} className="traj-legend-item">
                  <span
                    className="traj-legend-sw"
                    style={{
                      background: CatData.CAT_COLORS[c],
                    }}
                  />
                  {CatData.CAT_LABELS[c]}
                </span>
              ))}
              <span className="traj-legend-item">
                <span className="traj-legend-sw is-si" />
                Sin categoría
              </span>
            </div>
          </div>
          <div className="cat-grid">
            {CatData.CATEGORIAS.map((c) => (
              <CatColumn
                key={c}
                categoria={c}
                stat={dist.cats[c]}
                establecimientos={porCat[c]}
                matTotal={dist.matTotalNivel}
              />
            ))}
          </div>
          <SinVigente sv={sv} listaEE={sinVigenteEE} listaSinMedicion={sinMedicionEE} />
        </main>
      ) : (
        <main className="app-main">
          <div className="terr-summary">
            <span className="terr-summary-name">Comparación entre territorios</span>
            <span className="terr-summary-meta">
              Distribución de establecimientos por categoría · conteo de EE ·{" "}
              {CatData.NIVELES[nivel]} · año {CatData.ANIO_VIGENTE}
            </span>
          </div>
          <ComparativaSheet nivel={nivel} depActiva={cmpDep} onDepChange={setCmpDep} />
        </main>
      )}
      <NotasMetodologicas />
      {modal && (
        <EntityModal
          onSelect={(item) => {
            setEntity(item);
            setModal(false);
          }}
          onCancel={() => setModal(false)}
        />
      )}
    </div>
  );
}
const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(<App />);
