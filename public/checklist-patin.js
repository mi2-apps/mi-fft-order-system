/* ==========================================================================
   Checklist de Patín — hoja en blanco para llenar a mano. Sin formulario,
   sin datos capturados: sólo imprime la hoja Carta horizontal en blanco,
   mismo patrón que procesado-vios-hy.js. IIFE aislado, sin dependencias de
   otros módulos.
   ========================================================================== */

(function () {
  'use strict';

  const btnPrint = document.getElementById('cpt-btn-print');

  // ---- Aviso técnico si falta el logo o la imagen del patín ----
  document.querySelectorAll('img.brand-logo, img.cpt-asset').forEach((img) => {
    img.addEventListener('error', () => {
      console.error(`[Checklist de Patín] No se encontró la imagen "${img.getAttribute('src')}" en public/.`);
    }, { once: true });
  });

  btnPrint.addEventListener('click', () => {
    window.print();
  });
})();
