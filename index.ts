import { Elm } from "./src/Main";

type Flags = {
  user: {
    email: string;
    id: string;
    isActive: boolean;
    name: string;
    token: string;
  };
};

document.addEventListener("DOMContentLoaded", () => {
  const previousSession = localStorage.getItem("session");
  const flags = previousSession
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
    const registration = navigator.serviceWorker.register("./serviceworker.js");
    registration.then((reg) => {
      console.log("Success registering sw:", reg);
    }).catch((err) => {
      console.error("Failed to register sw:", err);
    });
  });
}
