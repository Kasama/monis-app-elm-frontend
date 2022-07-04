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

export type Flags = {
  user: Maybe<{
    email: string;
    id: string;
    isActive: boolean;
    name: string;
    token: string;
  }>;
};

export namespace Main {
  function init(options: { node?: HTMLElement | null; flags: Flags }): ElmApp;
}

export as namespace Elm;

export { Elm };
