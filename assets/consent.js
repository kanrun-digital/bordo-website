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
  var META_PIXEL_ID = '417578251392902';
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
    if (state.marketing) loadMetaPixel();
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

  /* ---------- Meta Pixel loader (only with marketing consent) ---------- */
  var metaPixelLoaded = false;
  function loadMetaPixel() {
    if (metaPixelLoaded || !META_PIXEL_ID) return;
    metaPixelLoaded = true;
    !function (f, b, e, v, n, t, s) {
      if (f.fbq) return; n = f.fbq = function () {
        n.callMethod ? n.callMethod.apply(n, arguments) : n.queue.push(arguments);
      };
      if (!f._fbq) f._fbq = n; n.push = n; n.loaded = !0; n.version = '2.0';
      n.queue = []; t = b.createElement(e); t.async = !0;
      t.src = v; s = b.getElementsByTagName(e)[0];
      s.parentNode.insertBefore(t, s);
    }(window, document, 'script', 'https://connect.facebook.net/en_US/fbevents.js');
    window.fbq('init', META_PIXEL_ID);
    window.fbq('track', 'PageView');
  }

  /* Mirror dataLayer events to Meta Pixel. No-op if pixel not yet loaded. */
  function fbqTrack(eventName, params) {
    if (!window.fbq) return;
    var p = params || {};
    switch (eventName) {
      case 'book_click':
        window.fbq('track', 'Lead', { content_name: p.cta_id || 'booksy', content_category: 'booking' });
        window.fbq('trackCustom', 'BookClick', p);
        break;
      case 'whatsapp_click':
      case 'phone_click':
      case 'email_click':
        window.fbq('track', 'Contact', { content_name: p.cta_id, channel: eventName.replace('_click', '') });
        break;
      case 'cta_click':
        window.fbq('trackCustom', 'CTAClick', p);
        break;
      case 'pricing_view':
        window.fbq('track', 'ViewContent', { content_category: 'pricing' });
        break;
      case 'gallery_view':
        window.fbq('trackCustom', 'GalleryView');
        break;
      case 'faq_open':
        window.fbq('trackCustom', 'FAQOpen', p);
        break;
      case 'engaged_60s':
        window.fbq('trackCustom', 'Engaged60s');
        break;
      case 'scroll_50':
      case 'scroll_75':
      case 'scroll_90':
        window.fbq('trackCustom', 'ScrollDepth', { depth: eventName.replace('scroll_', '') });
        break;
    }
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
    try { fbqTrack(eventName, params); } catch (e) {}
  };

  /* ---------- Auto-track CTA clicks (semantic event + generic) ----------
     For every [data-cta] click we fire:
       1) A specific event based on href: book_click | whatsapp_click | phone_click | email_click
          → used as Google Ads conversion triggers (primary goals).
       2) A generic cta_click with cta_id → used in GA4 for funnel analysis.
     Tracked only after a consent decision (GTM is loaded). */
  function classifyHref(href) {
    if (!href) return null;
    var h = href.toLowerCase();
    if (h.indexOf('booksy.com') !== -1) return 'book_click';
    if (h.indexOf('wa.me/') !== -1 || h.indexOf('whatsapp.com') !== -1) return 'whatsapp_click';
    if (h.indexOf('tel:') === 0) return 'phone_click';
    if (h.indexOf('mailto:') === 0) return 'email_click';
    return null;
  }
  document.addEventListener('click', function (e) {
    var c = e.target.closest('[data-cta], a[href^="tel:"], a[href^="mailto:"], a[href*="booksy.com"], a[href*="wa.me/"]');
    if (!c) return;
    var ctaId = c.getAttribute('data-cta') || 'unmarked';
    var ctaText = (c.textContent || '').trim().slice(0, 60);
    var href = c.getAttribute('href') || '';
    var specific = classifyHref(href);
    if (specific) {
      window.bordoTrack(specific, { cta_id: ctaId, cta_text: ctaText, link_url: href });
    }
    window.bordoTrack('cta_click', { cta_id: ctaId, cta_text: ctaText, link_url: href });
  }, true);

  /* ---------- Engagement: scroll depth, time, FAQ, section views ---------- */
  // Scroll depth (25/50/75/90)
  var scrollMarks = [25, 50, 75, 90];
  var scrollFired = {};
  function onScroll() {
    var doc = document.documentElement;
    var max = (doc.scrollHeight - doc.clientHeight) || 1;
    var pct = Math.round((window.scrollY / max) * 100);
    for (var i = 0; i < scrollMarks.length; i++) {
      var m = scrollMarks[i];
      if (pct >= m && !scrollFired[m]) {
        scrollFired[m] = true;
        window.bordoTrack('scroll_' + m);
      }
    }
  }
  window.addEventListener('scroll', onScroll, { passive: true });

  // 60s engagement (only if tab visible & user interacted)
  var engaged = false;
  var visibleSeconds = 0;
  var lastInteraction = Date.now();
  ['mousemove', 'keydown', 'scroll', 'touchstart', 'click'].forEach(function (ev) {
    window.addEventListener(ev, function () { lastInteraction = Date.now(); }, { passive: true });
  });
  setInterval(function () {
    if (document.hidden) return;
    if (Date.now() - lastInteraction > 30000) return; // idle
    visibleSeconds += 1;
    if (visibleSeconds >= 60 && !engaged) {
      engaged = true;
      window.bordoTrack('engaged_60s');
    }
  }, 1000);

  // FAQ open
  document.addEventListener('click', function (e) {
    var q = e.target.closest('.faq-q');
    if (!q) return;
    var item = q.closest('.faq-item');
    var wasOpen = item && item.classList.contains('open');
    // FAQ toggle handler in HTML runs after this (event capture order); detect "will open"
    if (!wasOpen) {
      var qText = (q.textContent || '').trim().slice(0, 80);
      window.bordoTrack('faq_open', { faq_question: qText });
    }
  }, true);

  // Section view tracking (pricing, before/after gallery)
  function watchSection(selector, eventName) {
    var el = document.querySelector(selector);
    if (!el || !('IntersectionObserver' in window)) return;
    var fired = false;
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (en) {
        if (en.isIntersecting && !fired) {
          fired = true;
          window.bordoTrack(eventName);
          io.disconnect();
        }
      });
    }, { threshold: 0.4 });
    io.observe(el);
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function () {
      watchSection('#pricing', 'pricing_view');
      watchSection('#ba, .ba-track, [data-section="before-after"]', 'gallery_view');
    });
  } else {
    watchSection('#pricing', 'pricing_view');
    watchSection('#ba, .ba-track, [data-section="before-after"]', 'gallery_view');
  }
})();
