/* Service worker: hace que la app se instale y funcione sin cobertura.
 *
 * La página se pide primero a la red y se guarda copia; si no hay conexión, se
 * sirve la copia. Así en la cocina la app abre siempre, y cuando hay señal la
 * versión nueva entra sola sin tener que ir cambiando números de versión. */

var CACHE = 'mise-en-place';
var PRECARGA = [
  './',
  './index.html',
  './manifest.webmanifest',
  './iconos/icono-192.png',
  './iconos/icono-512.png',
  './iconos/icono-maskable-512.png',
  './iconos/apple-touch-icon.png'
];

self.addEventListener('install', function(e){
  e.waitUntil(
    caches.open(CACHE)
      .then(function(c){ return c.addAll(PRECARGA) })
      .then(function(){ return self.skipWaiting() })
  );
});

self.addEventListener('activate', function(e){
  e.waitUntil(
    caches.keys().then(function(ks){
      return Promise.all(ks.map(function(k){ if(k!==CACHE) return caches.delete(k) }));
    }).then(function(){ return self.clients.claim() })
  );
});

self.addEventListener('fetch', function(e){
  var req = e.request;
  if(req.method !== 'GET') return;

  if(req.mode === 'navigate'){
    e.respondWith(
      fetch(req).then(function(r){
        var copia = r.clone();
        caches.open(CACHE).then(function(c){ c.put('./index.html', copia) });
        return r;
      }).catch(function(){
        return caches.match('./index.html').then(function(r){ return r || caches.match('./') });
      })
    );
    return;
  }

  e.respondWith(
    caches.match(req).then(function(hit){
      if(hit) return hit;
      return fetch(req).then(function(r){
        if(r && (r.ok || r.type === 'opaque')){
          var copia = r.clone();
          caches.open(CACHE).then(function(c){ c.put(req, copia) });
        }
        return r;
      });
    })
  );
});
