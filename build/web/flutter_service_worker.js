'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "5cff2c0a71b07017f0b477ed0a5b1030",
"assets/AssetManifest.bin.json": "2f72da07f7b4431e507b311ec3453041",
"assets/AssetManifest.json": "99aebf4dd7f5717488b2275f285f138b",
"assets/assets/images/Escudo-Bendicion.jpg": "bfe275912f983c6d54a2151c9dd88eab",
"assets/assets/images/Escudo-Borriquita.jpg": "7ed35c3bc22b431f526ba1ccf4a1a3c3",
"assets/assets/images/Escudo-Buena-Muerte.jpg": "46ceee1b7688921922ed780d4d9e3898",
"assets/assets/images/Escudo-Calvario.jpg": "0e7144c1c653178f70666493a96a77d9",
"assets/assets/images/Escudo-Cautivo.jpg": "ff8d6ba3ca5344be3d05cdd080d4f8e5",
"assets/assets/images/Escudo-Cena.jpg": "1ae57a2835e8a18a08e59e5b0709cf09",
"assets/assets/images/Escudo-Descendimiento.jpg": "1582c1a34a5c048608f1e2ed0b58701b",
"assets/assets/images/Escudo-Esperanza.jpg": "eb212c9802f8b3cb2c7ff4ff60b683ef",
"assets/assets/images/Escudo-Estudiantes.jpg": "9a46afc35c88facee77b639020cc29ac",
"assets/assets/images/Escudo-Fe.jpg": "5e723f6d72fbfe4e7f06179b578a2cd4",
"assets/assets/images/Escudo-La-Merced.jpg": "9333a7dd5ffea580905996e9f4ce8c59",
"assets/assets/images/Escudo-Lanzada.jpg": "0a1e0f948b0c3eecd257ad934375ef9d",
"assets/assets/images/Escudo-Misericordia.jpg": "f46ccfa6c302407477fb4364f5aa4849",
"assets/assets/images/Escudo-Mutilados.jpg": "83ba2061a5f72d340184580ab66811ac",
"assets/assets/images/Escudo-Nazareno.jpg": "fa8dafc8447c0ea42e247973c2b51193",
"assets/assets/images/Escudo-Oracion.jpg": "9958ad4885da0bfdf97a7bfa05df9779",
"assets/assets/images/Escudo-Pasion.jpg": "0f6c90514f3cbece7888dc7ed4a3987d",
"assets/assets/images/Escudo-Perdon.jpg": "6962055a148df1ad5629e8dc1261e65e",
"assets/assets/images/Escudo-Prado.jpg": "bb1470dc0c659ccc09bbd5ba93d84d9b",
"assets/assets/images/Escudo-Prendimiento.jpg": "2155c2a5c932215764e5854ca9b6de2f",
"assets/assets/images/Escudo-Redencion.jpg": "7efa291a74594126ce4a87c32514d3e9",
"assets/assets/images/Escudo-Resucitado.jpg": "d2d420dbf11499111ffdf027786d2c35",
"assets/assets/images/Escudo-Salud.jpg": "f1914a0bef4b777f2286568bc9945e8a",
"assets/assets/images/Escudo-Santa-Cruz.jpg": "5d2d17165c445cbca3f528f9f32f1a4e",
"assets/assets/images/Escudo-Santo-Entierro.jpg": "6a01bf45e9ce3f9d5a23a829d73b7a15",
"assets/assets/images/Escudo-Silencio.jpg": "4d4bda3765290958e885ffd45739bbfd",
"assets/assets/images/Escudo-Tres-Caidas.jpg": "587d99da566a49999d69dee380af7535",
"assets/assets/images/Escudo-VeraCruz.jpg": "9958ad4885da0bfdf97a7bfa05df9779",
"assets/assets/images/Escudo-Victoria.jpg": "94ef60394ee66f552e86e063483c7173",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "84dc9e002345364944f3ee8e16f0c1a1",
"assets/NOTICES": "9679dd0ac691ee13c6e76c4db30d973e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "ca2479cb77891c714a1ff41f75321227",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "5d5778487a97efe788f4a06402c9cd02",
"/": "5d5778487a97efe788f4a06402c9cd02",
"main.dart.js": "25070dde62ca59b45b99d08004cff94b",
"manifest.json": "342fd7b8bcbe4bf939666246dc2b7427",
"version.json": "de42affe609055f6089030012bfd1dfb"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
