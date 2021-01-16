module Page exposing (Page(..), Root, view)

import Browser exposing (Document)
import Css
import Html exposing (..)
import Html.Events
import Route


type Page
    = Home
    | Login
    | Other


type alias Navbar msg =
    { logoutMsg : msg
    , content : Html msg
    }


type alias Root msg =
    { title : String
    , navBar : Navbar msg
    , content : Html msg
    , footer : Html msg
    }


view : Page -> Root msg -> Document msg
view page { title, content, navBar, footer } =
    { title = title
    , body = [ navWrapper navBar, container content, footer ]
    }


container : Html msg -> Html msg
container inner =
    div
        [ Css.tw "container mx-auto"
        , Css.tw "h-full"
        , Css.tw "flex flex-col"
        , Css.tw "justify-center items-center"
        ]
        [ inner ]


navWrapper : Navbar msg -> Html msg
navWrapper { logoutMsg, content } =
    nav
        [ Css.tw "w-full flex flex-row bg-complement"
        , Css.tw "p-5 mb-5"
        ]
        [ h1 [ Css.tw "text-xl absolute" ] [ a [ Route.href Route.Home ] [ text "MonisApp" ] ]
        , content
        , h2 [ Css.tw "text-l absolute right-5 cursor-pointer" ] [ span [ Html.Events.onClick logoutMsg ] [ text "Logout" ] ]
        ]
