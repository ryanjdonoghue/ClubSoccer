(function () {
  var origin = window.location.origin;
  var prefetched = Object.create(null);
  function prefetch(url) {
    if (prefetched[url]) return;
    prefetched[url] = true;
    var link = document.createElement('link');
    link.rel = 'prefetch';
    link.href = url;
    document.head.appendChild(link);
  }
  var sitePages = [
    'index.html',
    'about.html',
    'team.html',
    'schedule.html',
    'register.html',
    'donate.html',
  ];
  function prefetchSitePages() {
    sitePages.forEach(function (name) {
      try {
        var u = new URL(name, window.location.href);
        if (u.origin !== origin) return;
        if (u.href === window.location.href) return;
        prefetch(u.href);
      } catch (err) {}
    });
  }
  if (window.requestIdleCallback) {
    window.requestIdleCallback(prefetchSitePages, { timeout: 2500 });
  } else {
    window.setTimeout(prefetchSitePages, 1);
  }
  document.addEventListener(
    'pointerenter',
    function (e) {
      var el = e.target.closest('a[href]');
      if (!el || el.target === '_blank') return;
      var raw = el.getAttribute('href');
      if (!raw || raw.charAt(0) === '#' || raw.indexOf('mailto:') === 0 || raw.indexOf('tel:') === 0) return;
      try {
        var u = new URL(raw, window.location.href);
        if (origin && u.origin !== origin) return;
        if (u.href === window.location.href) return;
        prefetch(u.href);
      } catch (err) {}
    },
    { passive: true, capture: true }
  );
})();
