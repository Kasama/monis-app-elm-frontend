module Components.Icon exposing (icon)

import Css
import Html exposing (Html)


icon : String -> Html msg
icon name =
    Html.i [ Css.fa name ] []
