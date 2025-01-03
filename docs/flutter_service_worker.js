'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "e6b2930263fd4627203843a285a58250",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"manifest.json": "5faf77c82f58cbe345fbe8b2fafdf849",
"version.json": "ae6e63ba144ad125011705f995622591",
"assets/packages/my_widgets/assets/lotties/empty.json": "9d8ef85386af65f5600deecfdf76dc7c",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "4e893d88cb5af976bb98afc3b4eeb752",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/AssetManifest.bin": "0796204b1ee61e3d8229321af4d7bb99",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "883fd213616d9db8be27274bd90feb46",
"assets/assets/images/404.png": "25e2cdc432e012308dca5c58b529b636",
"assets/assets/images/bg-1.png": "8de4c38056a16b2968d896256a8bb86a",
"assets/assets/images/noise.png": "93d347cf41e58f16e31a699f614185b6",
"assets/assets/images/empty.json": "fa5417adbe3b0f24066b789674835ed6",
"assets/assets/images/logo.png": "322c0bd2000ccf8df876f0917c276ff0",
"assets/assets/images/placeholder.png": "0add927634959b434ee00d8429c65caf",
"assets/assets/images/update.png": "3f9f8ea75f220ea8d575c50f24ec376c",
"assets/assets/images/question.png": "71352b6417fff2d706dd3ceeaba03333",
"assets/assets/images/bg.png": "a4e3b34c600c3b800df73b95ccda6251",
"assets/assets/images/questionnaire.png": "50a6f83a03af656281c939fd416aeb6a",
"assets/assets/images/empty.png": "b238aab3fa218d44b99d00618a5a9c2e",
"assets/assets/fonts/SevenSegment.ttf": "624871e1b6172da8c089029daf0c632e",
"assets/assets/fonts/Poppins-Light.ttf": "9a8c18bd1dbe8508bc2525be7e07d0ff",
"assets/assets/fonts/Poppins-Regular.ttf": "1b580d980532792578c54897ca387e2c",
"assets/assets/fonts/Poppins-Bold.ttf": "d13db1fed3945c3b8c3293bfcfadb32f",
"assets/assets/icons/diamant.png": "b694607ae81fd4a9d2420003d4546644",
"assets/assets/icons/upload.png": "e8e0ab3ea729ae13b0744056bb10cca9",
"assets/assets/icons/logo.png": "4c8b9b651b6155f2d13b8752a228c3c4",
"assets/assets/icons/account_2.png": "d543ac99a2238f12200dad9e191f16ec",
"assets/assets/icons/user.png": "0f8a9c4c6f6df2294b39d3c1dbb09fab",
"assets/assets/icons/recto-verso.png": "55d53a78dad5bd4ad46c7eb351409c7d",
"assets/assets/icons/warning.png": "eddc52fa9d8e459dce957ea83954259a",
"assets/assets/icons/simple.png": "7182fd622e0e8f3acf08f60284f8f644",
"assets/assets/icons/phone.png": "18b7651636458a8066c70aa13b8de6f4",
"assets/assets/icons/logo-text.png": "85bca62f2d93be049b6dc9369d196f2d",
"assets/assets/icons/launch_icon.png": "d548278f19b400fcf5a60a5c7ba8cf08",
"assets/assets/icons/questionnaires.png": "3e894442318aac8d31a07dea0d0fb6c7",
"assets/assets/icons/account_us.png": "6a84f9c0356f2bb5858c0e3fd6b0b863",
"assets/assets/icons/pdf.png": "10fd085c01e353cf2b35bd287358bc7a",
"assets/assets/icons/view_questions.png": "f896829e90e1c99302cb235aa88142a3",
"assets/assets/icons/import.png": "f45f3b40e103a3c3bdbbe104206ea208",
"assets/assets/icons/documents.png": "9d785a42aad24d383801badbb18756e9",
"assets/assets/icons/home_s.png": "faaf3672ee2fc78b8d2f3ef93712327f",
"assets/assets/icons/aucun.png": "b238aab3fa218d44b99d00618a5a9c2e",
"assets/assets/icons/account_s.png": "ca79585ade85192757b8b8b9f8808a1a",
"assets/assets/icons/ardoise.png": "74627f8cf42cb3577022b441cceaa2e9",
"assets/assets/icons/home_us.png": "92fa75465d7537444884855296db3b2b",
"assets/fonts/MaterialIcons-Regular.otf": "19ec35618b9e09077ca9dff26c680cd0",
"assets/AssetManifest.json": "2ed877fee85c7a3a144d7f4ffd90257c",
"assets/AssetManifest.bin.json": "dc8d7a9e337258312262b4b99dd51365",
"assets/NOTICES": "805bcf077eb26c1a339fe4609a207bf9",
"favicon.png": "227243761c693bc31510f96523c98170",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"main.dart.js": "26ad5453d6294632f07950389f913211",
"index.html": "aeddde715279172d44f6a075b3e5c34a",
"/": "aeddde715279172d44f6a075b3e5c34a",
"icons/Icon-192.png": "065c54a9fa20187317f1b6774bea762b",
"icons/Icon-512.png": "a8acea2d396354b98e5573bae34f45c9",
"icons/Icon-maskable-192.png": "065c54a9fa20187317f1b6774bea762b",
"icons/Icon-maskable-512.png": "a8acea2d396354b98e5573bae34f45c9"};
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
