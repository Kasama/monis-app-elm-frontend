module Backend.Authentication exposing (..)

import Json.Decode as Json
import Url exposing (Protocol(..), Url)
import Url.Parser exposing ((</>), (<?>), Parser)
import Url.Parser.Query
import Config


type Session
    = Guest
    | LoggedIn SessionData


type alias SessionData =
    { token : String
    }


type alias Configuration =
    { authorizationEndpoint : Url
    , tokenEndpoint : Url
    , userInfoEndpoint : Url
    , userInfoDecoder : Json.Decoder UserInfo
    , clientId : String
    , scope : List String
    , redirectUri : String
    , audience : String
    }


type alias UserInfo =
    { name : String
    , picture : String
    }


defaultHttpsUrl : Url
defaultHttpsUrl =
    { protocol = Https
    , host = ""
    , path = ""
    , port_ = Nothing
    , query = Nothing
    , fragment = Nothing
    }


configuration : String -> String -> String -> Configuration
configuration redirectUri host clientId =
    { authorizationEndpoint =
        { defaultHttpsUrl | host = host, path = "/authorize" }
    , tokenEndpoint =
        { defaultHttpsUrl | host = host, path = "/oauth/token" }
    , userInfoEndpoint =
        { defaultHttpsUrl | host = host, path = "/userInfo" }
    , userInfoDecoder =
        Json.map2 UserInfo
            (Json.field "name" Json.string)
            (Json.field "picture" Json.string)
    , clientId = clientId
    , scope = [ "openid", "profile", "email", "offline_access" ]
    , audience = Config.auth0Audience
    , redirectUri = redirectUri
    }


authorizeRedirectUrl : Configuration -> String
authorizeRedirectUrl config =
    let
        authorizationEndpoint =
            config.authorizationEndpoint
    in
    Url.toString <|
        { authorizationEndpoint
            | query =
                Just <|
                    String.join "&"
                        [ "response_type=id_token token"
                        , "nonce=batatinhafrita"
                        , "audience=" ++ config.audience
                        , "client_id=" ++ config.clientId
                        , "redirect_uri=" ++ config.redirectUri
                        , "scope=" ++ String.join " " config.scope
                        ]
        }



-- Auth Token


type alias AuthInfo =
    { token : String
    , id_token : String
    , scopes : List String
    , expires_in : Int
    , token_type : String
    }


authTokenParser : Parser (AuthInfo -> b) b
authTokenParser =
    Url.Parser.query
        (Url.Parser.Query.map5 AuthInfo
            (Url.Parser.Query.string "access_token" |> Url.Parser.Query.map (Maybe.withDefault ""))
            (Url.Parser.Query.string "id_token" |> Url.Parser.Query.map (Maybe.withDefault ""))
            (Url.Parser.Query.string "scope" |> Url.Parser.Query.map (String.split " " << Maybe.withDefault ""))
            (Url.Parser.Query.int "expires_in" |> Url.Parser.Query.map (Maybe.withDefault 0))
            (Url.Parser.Query.string "token_type" |> Url.Parser.Query.map (Maybe.withDefault "Bearer"))
        )


parseCallbackUrl : Url -> Maybe AuthInfo
parseCallbackUrl url =
    let
        usedUrl =
            { url
                | query = Just (url.query |> Maybe.withDefault "" |> Just) |> Maybe.andThen identity
                , path = ""
            }

        parseableUrl =
            Url.toString usedUrl
                |> String.replace "#" "&"
                |> String.replace "?&" "?"
                -- convert fragment into query to allow parsing
                |> Url.fromString
                |> Maybe.withDefault url

        result =
            Url.Parser.parse authTokenParser parseableUrl
    in
    result
        |> Maybe.andThen
            (\r ->
                if r.token == "" || r.expires_in == 0 then
                    Nothing

                else
                    Just r
            )
