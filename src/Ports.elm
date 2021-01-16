port module Ports exposing (localStorageGet, localStorageReceiver, localStorageSet)


port localStorageSet : ( String, Maybe String ) -> Cmd msg


port localStorageGet : String -> Cmd msg


port localStorageReceiver : (Maybe String -> msg) -> Sub msg
