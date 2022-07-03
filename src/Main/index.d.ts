export interface ElmApp {
  ports: {
    localStorageSet: Maybe<ElmPort<[string, string]>>;
    localStorageGet: Maybe<ElmPort<string>>;
    localStorageReceiver: Maybe<ElmPort<Maybe<string>>>;
  };
}

export type Maybe<T> = T | undefined | null;

export type ElmPort<T> = {
  subscribe: (f: (value: T) => void) => void,
  send: (value: T) => void,
}

export namespace Main {
  function init(options: { node?: HTMLElement | null; flags: any }): ElmApp;
}

export as namespace Elm;

export { Elm };
