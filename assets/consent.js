/* ============================================================
   Bordo · Cookie Consent + Google Consent Mode v2
   ------------------------------------------------------------
   - Defaults: all denied (GDPR-compliant)
   - Banner + settings modal (PL/UK)
   - Persists choice in localStorage ('bordo_consent') for 180 days
   - Loads GTM only after a choice is recorded
   - Re-open via any element with [data-bc-open] (e.g. footer link)
   ============================================================ */
(function () {
  'use strict';

  var GTM_ID = 'GTM-NJHS8Z3L';
  var STORAGE_KEY = 'bordo_consent';
  var STORAGE_VERSION = 1;
  var TTL_DAYS = 180;

  var lang = (document.documentElement.lang || 'pl').toLowerCase().indexOf('uk') === 0 ? 'uk' : 'pl';

  var I18N = {
    pl: {
      title: 'Dbamy o Twoją prywatność',
      body: 'Używamy plików cookie, aby strona działała poprawnie, mierzyć ruch i pokazywać Ci dopasowane reklamy. Niezbędne cookies są zawsze włączone. Analityczne i marketingowe — tylko za Twoją zgodą. Szczegóły w <a href="/polityka-prywatnosci.html">Polityce prywatności</a>.',
      acceptAll: 'Akceptuj wszystkie',
      rejectAll: 'Tylko niezbędne',
      settings: 'Ustawienia',
      modalTitle: 'Ustawienia plików cookie',
      modalBody: 'Wybierz, na jakie kategorie cookies się zgadzasz. Swój wybór możesz w każdej chwili zmienić w stopce strony.',
      catNecessary: 'Niezbędne',
      catNecessaryDesc: 'Wymagane do działania strony (np. zapisanie Twojego wyboru cookies). Zawsze włączone.',
      catAnalytics: 'Analityka',
      catAnalyticsDesc: 'Anonimowe statystyki ruchu (Google Analytics 4) — pomagają nam poprawiać studio i stronę.',
      catMarketing: 'Marketing',
      catMarketingDesc: 'Pliki Google Ads i Meta (Facebook/Instagram) — pozwalają pokazywać reklamy i mierzyć ich skuteczność.',
      save: 'Zapisz wybór',
      acceptAllShort: 'Akceptuj wszystkie',
      reopen: 'Ustawienia cookies'
    },
    uk: {
      title: 'Дбаємо про вашу приватність',
      body: 'Ми використовуємо файли cookie, щоб сайт працював коректно, аналізувати трафік і показувати релевантну рекламу. Необхідні cookies увімкнені завжди. Аналітика та маркетинг — лише за вашою згодою. Деталі — у <a href="/uk/polityka-konfidentsiynosti.html">Політиці конфіденційності</a>.',
      acceptAll: 'Прийняти всі',
      rejectAll: 'Лише необхідні',
      settings: 'Налаштування',
      modalTitle: 'Налаштування файлів cookie',
      modalBody: 'Оберіть, на які категорії cookies ви погоджуєтесь. Свій вибір ви можете будь-коли змінити у футері сайту.',
      catNecessary: 'Необхідні',
      catNecessaryDesc: 'Потрібні для роботи сайту (наприклад, збереження вашого вибору cookies). Завжди увімкнені.',
      catAnalytics: 'Аналітика',
      catAnalyticsDesc: 'Анонімна статистика відвідувань (Google Analytics 4) — допомагає покращувати студію та сайт.',
      catMarketing: 'Маркетинг',
      catMarketingDesc: 'Файли Google Ads та Meta (Facebook/Instagram) — дозволяють показувати рекламу та вимірювати її ефективність.',
      save: 'Зберегти вибір',
      acceptAllShort: 'Прийняти всі',
      reopen: 'Налаштування cookies'
    }
  };
  var t = I18N[lang];

  /* ---------- Google Consent Mode v2 — default DENIED ---------- */
  window.dataLayer = window.dataLayer || [];
  function gtag() { window.dataLayer.push(arguments); }
  window.gtag = window.gtag || gtag;

  gtag('consent', 'default', {
    ad_storage: 'denied',
    ad_user_data: 'denied',
    ad_personalization: 'denied',
    analytics_storage: 'denied',
    functionality_storage: 'granted',
    personalization_storage: 'denied',
    security_storage: 'granted',
    wait_for_update: 2000
  });
  gtag('set', 'ads_data_redaction', true);
  gtag('set', 'url_passthrough', true);

  /* ---------- Storage helpers ---------- */
  function readConsent() {
    try {
      var raw = localStorage.getItem(STORAGE_KEY);
      if (!raw) return null;
      var data = JSON.parse(raw);
      if (data.v !== STORAGE_VERSION) return null;
      var ageDays = (Date.now() - data.ts) / (1000 * 60 * 60 * 24);
      if (ageDays > TTL_DAYS) return null;
      return data;
    } catch (e) { return null; }
  }
  function writeConsent(state) {
    var payload = {
      v: STORAGE_VERSION,
      ts: Date.now(),
      analytics: !!state.analytics,
      marketing: !!state.marketing
    };
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(payload)); } catch (e) {}
    // Mirror to cookie for server-side awareness (180d)
    var d = new Date(); d.setTime(d.getTime() + TTL_DAYS * 864e5);
    document.cookie = STORAGE_KEY + '=' + encodeURIComponent(
      (payload.analytics ? 'a' : '') + (payload.marketing ? 'm' : '') || 'n'
    ) + ';expires=' + d.toUTCString() + ';path=/;SameSite=Lax';
  }

  function applyConsent(state) {
    gtag('consent', 'update', {
      ad_storage: state.marketing ? 'granted' : 'denied',
      ad_user_data: state.marketing ? 'granted' : 'denied',
      ad_personalization: state.marketing ? 'granted' : 'denied',
      analytics_storage: state.analytics ? 'granted' : 'denied',
      personalization_storage: state.analytics ? 'granted' : 'denied'
    });
    window.dataLayer.push({
      event: 'bordo_consent_update',
      bordo_consent_analytics: !!state.analytics,
      bordo_consent_marketing: !!state.marketing
    });
  }

  /* ---------- GTM loader (fires once, after consent default is set) ---------- */
  var gtmLoaded = false;
  function loadGTM() {
    if (gtmLoaded || !GTM_ID) return;
    gtmLoaded = true;
    window.dataLayer.push({ 'gtm.start': Date.now(), event: 'gtm.js' });
    var s = document.createElement('script');
    s.async = true;
    s.src = 'https://www.googletagmanager.com/gtm.js?id=' + GTM_ID;
    document.head.appendChild(s);
  }

  /* ---------- UI ---------- */
  function el(tag, attrs, html) {
    var n = document.createElement(tag);
    if (attrs) Object.keys(attrs).forEach(function (k) { n.setAttribute(k, attrs[k]); });
    if (html != null) n.innerHTML = html;
    return n;
  }

  function buildBanner() {
    var b = el('div', { class: 'bc-banner', role: 'dialog', 'aria-live': 'polite', 'aria-label': t.title });
    b.innerHTML =
      '<h3>' + t.title + '</h3>' +
      '<p>' + t.body + '</p>' +
      '<div class="bc-actions">' +
        '<button type="button" class="bc-btn bc-btn-primary" data-bc-act="all">' + t.acceptAll + '</button>' +
        '<button type="button" class="bc-btn bc-btn-secondary" data-bc-act="none">' + t.rejectAll + '</button>' +
        '<button type="button" class="bc-btn bc-btn-link" data-bc-act="open">' + t.settings + '</button>' +
      '</div>';
    return b;
  }

  function buildModal(state) {
    var bd = el('div', { class: 'bc-modal-backdrop', role: 'dialog', 'aria-modal': 'true', 'aria-label': t.modalTitle });
    bd.innerHTML =
      '<div class="bc-modal">' +
        '<h3>' + t.modalTitle + '</h3>' +
        '<p>' + t.modalBody + '</p>' +
        '<div class="bc-cat">' +
          '<div class="bc-cat-head"><span class="bc-cat-title">' + t.catNecessary + '</span>' +
            '<label class="bc-switch"><input type="checkbox" checked disabled><span class="bc-slider"></span></label>' +
          '</div>' +
          '<p class="bc-cat-desc">' + t.catNecessaryDesc + '</p>' +
        '</div>' +
        '<div class="bc-cat">' +
          '<div class="bc-cat-head"><span class="bc-cat-title">' + t.catAnalytics + '</span>' +
            '<label class="bc-switch"><input type="checkbox" data-bc-cat="analytics"' + (state.analytics ? ' checked' : '') + '><span class="bc-slider"></span></label>' +
          '</div>' +
          '<p class="bc-cat-desc">' + t.catAnalyticsDesc + '</p>' +
        '</div>' +
        '<div class="bc-cat">' +
          '<div class="bc-cat-head"><span class="bc-cat-title">' + t.catMarketing + '</span>' +
            '<label class="bc-switch"><input type="checkbox" data-bc-cat="marketing"' + (state.marketing ? ' checked' : '') + '><span class="bc-slider"></span></label>' +
          '</div>' +
          '<p class="bc-cat-desc">' + t.catMarketingDesc + '</p>' +
        '</div>' +
        '<div class="bc-modal-actions">' +
          '<button type="button" class="bc-btn bc-btn-secondary" data-bc-act="save">' + t.save + '</button>' +
          '<button type="button" class="bc-btn bc-btn-primary" data-bc-act="all">' + t.acceptAllShort + '</button>' +
        '</div>' +
      '</div>';
    return bd;
  }

  var bannerEl = null;
  var modalEl = null;

  function showBanner() {
    if (bannerEl) return;
    bannerEl = buildBanner();
    document.body.appendChild(bannerEl);
    requestAnimationFrame(function () { bannerEl.classList.add('bc-show'); });
  }
  function hideBanner() {
    if (!bannerEl) return;
    bannerEl.classList.remove('bc-show');
    setTimeout(function () { if (bannerEl && bannerEl.parentNode) bannerEl.parentNode.removeChild(bannerEl); bannerEl = null; }, 350);
  }
  function openModal() {
    var current = readConsent() || { analytics: false, marketing: false };
    if (modalEl && modalEl.parentNode) modalEl.parentNode.removeChild(modalEl);
    modalEl = buildModal(current);
    document.body.appendChild(modalEl);
    requestAnimationFrame(function () { modalEl.classList.add('bc-show'); });
  }
  function closeModal() {
    if (!modalEl) return;
    modalEl.classList.remove('bc-show');
    if (modalEl.parentNode) modalEl.parentNode.removeChild(modalEl);
    modalEl = null;
  }

  function handleClick(e) {
    var target = e.target.closest('[data-bc-act], [data-bc-open]');
    if (!target) {
      // Clicking modal backdrop (outside .bc-modal) closes it
      if (modalEl && e.target === modalEl) closeModal();
      return;
    }
    if (target.hasAttribute('data-bc-open')) { e.preventDefault(); openModal(); return; }
    var act = target.getAttribute('data-bc-act');
    if (act === 'all') {
      var s = { analytics: true, marketing: true };
      writeConsent(s); applyConsent(s); loadGTM(); hideBanner(); closeModal();
    } else if (act === 'none') {
      var s2 = { analytics: false, marketing: false };
      writeConsent(s2); applyConsent(s2); loadGTM(); hideBanner(); closeModal();
    } else if (act === 'open') {
      openModal();
    } else if (act === 'save') {
      var a = modalEl ? !!modalEl.querySelector('[data-bc-cat="analytics"]').checked : false;
      var m = modalEl ? !!modalEl.querySelector('[data-bc-cat="marketing"]').checked : false;
      var s3 = { analytics: a, marketing: m };
      writeConsent(s3); applyConsent(s3); loadGTM(); hideBanner(); closeModal();
    }
  }

  function init() {
    document.addEventListener('click', handleClick, false);
    var saved = readConsent();
    if (saved) {
      applyConsent(saved);
      loadGTM();
    } else {
      // Show banner — GTM stays unloaded until user decides
      showBanner();
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  /* Public helper for conversion events from buttons
     Usage:  bordoTrack('book_click', { source: 'sticky' })
     Fires only when GTM is loaded (i.e. after any consent decision). */
  window.bordoTrack = function (eventName, params) {
    window.dataLayer = window.dataLayer || [];
    var payload = { event: eventName };
    if (params && typeof params === 'object') {
      Object.keys(params).forEach(function (k) { payload[k] = params[k]; });
    }
    window.dataLayer.push(payload);
  };

  /* Optional: auto-track CTA clicks already marked with data-cta in the HTML */
  document.addEventListener('click', function (e) {
    var c = e.target.closest('[data-cta]');
    if (!c) return;
    window.bordoTrack('cta_click', { cta_id: c.getAttribute('data-cta'), cta_text: (c.textContent || '').trim().slice(0, 60) });
  }, true);
})();
