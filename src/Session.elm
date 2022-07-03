module Session exposing (Session, SessionType(..), StoredSession, cleanSession, decodeSession, decoder, encodeSession, fromStoredSession, newSession, saveSession)

import Browser.Navigation as Nav
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Objects.User as User exposing (User)
import Ports


type alias Session =
    { navKey : Nav.Key
    , kind : SessionType
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


decoder : Nav.Key -> Decoder Session
decoder navKey =
    Decode.map2 Session
        (Decode.succeed navKey)
        sessionTypeDecoder


type SessionType
    = LoggedIn User
    | Guest


sessionTypeDecoder : Decoder SessionType
sessionTypeDecoder =
    Decode.field "user" (Decode.maybe User.decoder)
        |> Decode.map
            (\mu ->
                case mu of
                    Just user ->
                        LoggedIn user

                    Nothing ->
                        Guest
            )


newSession : Nav.Key -> Maybe User -> Session
newSession navKey maybeUser =
    { navKey = navKey
    , kind =
        case maybeUser of
            Nothing ->
                Guest

            Just user ->
                LoggedIn user
    }


fromStoredSession : Nav.Key -> StoredSession -> Session
fromStoredSession navKey session =
    { navKey = navKey
    , kind =
        case session.user of
            Just user ->
                LoggedIn user

            Nothing ->
                Guest
    }


encodeSession : Session -> String
encodeSession session =
    Encode.encode 0 (encoder session)


decodeSession : Nav.Key -> String -> Result Decode.Error Session
decodeSession navKey sessionStr =
    Decode.decodeString (decoder navKey) sessionStr


sessionLocalStorageKey : String
sessionLocalStorageKey =
    "session"


cleanSession : Cmd msg
cleanSession =
    Ports.localStorageSet ( sessionLocalStorageKey, Nothing )


saveSession : Session -> Cmd msg
saveSession session =
    Ports.localStorageSet ( sessionLocalStorageKey, Just <| encodeSession session )
