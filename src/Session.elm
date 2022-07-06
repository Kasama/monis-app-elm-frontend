module Session exposing (Session, SessionType(..), StoredSession, cleanSession, encodeSession, fromStoredSession, saveSession)

import Browser.Navigation as Nav
import Json.Encode as Encode exposing (Value)
import Objects.User as User exposing (User)
import Ports
import Url exposing (Url)


type alias Session =
    { navKey : Nav.Key
    , kind : SessionType
    , url : Url
    }


type alias StoredSession =
    { user : Maybe User
    }


encoder : Session -> Value
encoder session =
    Encode.object
        (case session.kind of
            Guest ->
                [ ( "user", Encode.null ) ]

            LoggedIn user ->
                [ ( "user", User.encoder user )
                ]
        )


type SessionType
    = LoggedIn User
    | Guest


fromStoredSession : Nav.Key -> StoredSession -> Url -> Session
fromStoredSession navKey session url =
    { navKey = navKey
    , kind =
        case session.user of
            Just user ->
                LoggedIn user

            Nothing ->
                Guest
    , url = url
    }


encodeSession : Session -> String
encodeSession session =
    Encode.encode 0 (encoder session)


sessionLocalStorageKey : String
sessionLocalStorageKey =
    "session"


cleanSession : Cmd msg
cleanSession =
    Ports.localStorageSet ( sessionLocalStorageKey, Nothing )


saveSession : Session -> Cmd msg
saveSession session =
    Ports.localStorageSet ( sessionLocalStorageKey, Just <| encodeSession session )
