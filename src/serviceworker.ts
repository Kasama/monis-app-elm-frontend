/// <reference lib="webworker" />

import { } from ".";
import { precacheAndRoute } from 'workbox-precaching';
declare const serviceWorkerOption: { assets: string[] };
declare var self: ServiceWorkerGlobalScope & { __WB_MANIFEST: any };

self.addEventListener("install", (e) => {
  console.log("Service worker got installed:", e);
  self.skipWaiting();
});

self.addEventListener("activated", (e: Event) => {
  console.log("Service worker got activated:", e);
});

self.addEventListener("fetch", (e) => {
  console.log("[Service Worker] Fetched resource ");

  e.request.body
    ?.getReader()
    .read()
    .then((body) => {
      console.log("[Service Worker] request body is", body);
    });
});

const manifests = self.__WB_MANIFEST;
precacheAndRoute(manifests)

const DEBUG_MODE: boolean =
  location.hostname.endsWith(".local") || location.hostname === "localhost";
