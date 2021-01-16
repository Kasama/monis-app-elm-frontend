module Css exposing
    ( btn
    , fa
    , tw
    )

import Html
import Html.Attributes as A


btn : String -> Html.Attribute msg
btn color =
    A.class ("font-bold py-2 px-4 rounded bg-" ++ color ++ "-500 text-bright hover:bg-" ++ color ++ "-700")


tw : String -> Html.Attribute msg
tw classes =
    A.class classes


fa : String -> Html.Attribute msg
fa name =
    A.class <| "fas fa-" ++ name
