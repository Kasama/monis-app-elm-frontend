module Route exposing (Route(..), fromUrl, href, replaceUrl, routePaths, toString)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf)
import Util


type Route
    = Home
    | Authorize
    | NotFound


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home (routeParser Home)
        , Parser.map Authorize (routeParser Authorize)
        , Parser.map NotFound Parser.top
        ]


routeParser : Route -> Parser a a
routeParser route =
    List.map Parser.s (routePaths route)
        |> Util.foldl1 (</>)
        |> Maybe.withDefault Parser.top


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (toString route)


href : Route -> Attribute msg
href route =
    Html.Attributes.href (toString route)


fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse parser


toString : Route -> String
toString route =
    "/" ++ String.join "/" (routePaths route)


routePaths : Route -> List String
routePaths route =
    case route of
        Home ->
            []

        Authorize ->
            [ "auth" ]

        NotFound ->
            [ "notfound" ]
