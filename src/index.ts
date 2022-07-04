import { Elm, Flags } from "./Main";

document.addEventListener("DOMContentLoaded", () => {
  const previousSession = localStorage.getItem("session");
  const flags: Flags = previousSession
    ? (JSON.parse(previousSession) as Flags)
    : { user: null };

  const app = Elm.Main.init({
    node: document.getElementById("application"),
    flags,
  });

  app.ports.localStorageSet?.subscribe(function([key, value]) {
    if (value !== null) {
      localStorage.setItem(key, value);
    } else {
      localStorage.removeItem(key);
    }
  });

  app.ports.localStorageGet?.subscribe((key) => {
    let value = localStorage.getItem(key);
    app.ports.localStorageReceiver?.send(value);
  });
});

if ("serviceWorker" in navigator) {
  window.addEventListener('load', () => {
    if (location.hostname === "localhost" || location.hostname.endsWith('.local')) {
      console.log("Skipping sw registration in local env");
      return;
    }
    const registration = (navigator as Navigator).serviceWorker.register("./serviceworker.js");
    registration.then((reg: ServiceWorkerRegistration) => {
      console.log("Success registering sw:", reg);
    }).catch((err: unknown) => {
      console.error("Failed to register sw:", err);
    });
  });
}
