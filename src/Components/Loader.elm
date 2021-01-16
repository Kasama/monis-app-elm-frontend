module Components.Loader exposing (color, puff, rings, size)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


type alias Option =
    Model -> Model


type alias Model =
    { size : Int
    , color : String
    }


init : List Option -> Model
init options =
    List.foldl (<|)
        { size = 32
        , color = "var(--color-bright)"
        }
        options


rings : List (Html.Attribute msg) -> List Option -> Html msg
rings attributes options =
    let
        model =
            init options
    in
    svg
        (attributes
            ++ [ width (String.fromInt model.size)
               , height (String.fromInt model.size)
               , stroke model.color
               , viewBox "0 0 45 45"
               ]
        )
        [ g [ fill "none", fillRule "evenodd", transform "translate(1 1)", strokeWidth "2" ]
            [ circle [ cx "22", cy "22", r "6", strokeOpacity "0" ]
                [ animate
                    [ attributeName "r"
                    , begin "1.5s"
                    , dur "3s"
                    , values "6;22"
                    , calcMode "linear"
                    , repeatCount "indefinite"
                    ]
                    []
                , animate
                    [ attributeName "stroke-opacity"
                    , begin "1.5s"
                    , dur "3s"
                    , values "1;0"
                    , calcMode "linear"
                    , repeatCount "indefinite"
                    ]
                    []
                , animate
                    [ attributeName "stroke-width"
                    , begin "1.5s"
                    , dur "3s"
                    , values "2;0"
                    , calcMode "linear"
                    , repeatCount "indefinite"
                    ]
                    []
                ]
            , circle [ cx "22", cy "22", r "6", strokeOpacity "0" ]
                [ animate
                    [ attributeName "r"
                    , begin "3s"
                    , dur "3s"
                    , values "6;22"
                    , calcMode "linear"
                    , repeatCount "indefinite"
                    ]
                    []
                , animate
                    [ attributeName "stroke-opacity"
                    , begin "3s"
                    , dur "3s"
                    , values "1;0"
                    , calcMode "linear"
                    , repeatCount "indefinite"
                    ]
                    []
                , animate
                    [ attributeName "stroke-width"
                    , begin "3s"
                    , dur "3s"
                    , values "2;0"
                    , calcMode "linear"
                    , repeatCount "indefinite"
                    ]
                    []
                ]
            , circle [ cx "22", cy "22", r "8" ]
                [ animate
                    [ attributeName "r"
                    , begin "0s"
                    , dur "1.5s"
                    , values "6;1;2;3;4;5;6"
                    , calcMode "linear"
                    , repeatCount "indefinite"
                    ]
                    []
                ]
            ]
        ]


puff : List Option -> Html msg
puff options =
    let
        model =
            init options
    in
    svg
        [ width (String.fromInt model.size)
        , height (String.fromInt model.size)
        , stroke model.color
        , viewBox "0 0 44 44"
        ]
        [ g
            [ fill "none"
            , fillRule "evenodd"
            , strokeWidth "2"
            ]
            [ circle
                [ cx "22"
                , cy "22"
                , r "1"
                ]
                [ animate
                    [ attributeName "r"
                    , begin "0s"
                    , dur "1.8s"
                    , values "1; 20"
                    , calcMode "spline"
                    , keyTimes "0; 1"
                    , keySplines "0.165, 0.84, 0.44, 1"
                    , repeatCount "indefinite"
                    ]
                    []
                , animate
                    [ attributeName "stroke-opacity"
                    , begin "0s"
                    , dur "1.8s"
                    , values "1; 0"
                    , calcMode "spline"
                    , keyTimes "0; 1"
                    , keySplines "0.3, 0.61, 0.355, 1"
                    , repeatCount "indefinite"
                    ]
                    []
                ]
            , circle [ cx "22", cy "22", r "1" ]
                [ animate
                    [ attributeName "r"
                    , begin "-0.9s"
                    , dur "1.8s"
                    , values "1; 20"
                    , calcMode "spline"
                    , keyTimes "0; 1"
                    , keySplines "0.165, 0.84, 0.44, 1"
                    , repeatCount "indefinite"
                    ]
                    []
                , animate
                    [ attributeName "stroke-opacity"
                    , begin "-0.9s"
                    , dur "1.8s"
                    , values "1; 0"
                    , calcMode "spline"
                    , keyTimes "0; 1"
                    , keySplines "0.3, 0.61, 0.355, 1"
                    , repeatCount "indefinite"
                    ]
                    []
                ]
            ]
        ]


{-| Size defines the width of the loading indicator,
the height is adjusted accordingly if necessary to
retain the correct aspect ratio.
-}
size : Int -> Option
size v model =
    { model | size = v }


{-| Color defines the primary color of the indicator.
-}
color : String -> Option
color v model =
    { model | color = v }



-- <!-- By Sam Herbert (@sherb), for everyone. More @ http://goo.gl/7AJzbL -->
-- <svg width="38" height="38" viewBox="0 0 38 38" xmlns="http://www.w3.org/2000/svg">
--     <defs>
--         <linearGradient x1="8.042%" y1="0%" x2="65.682%" y2="23.865%" id="a">
--             <stop stop-color="#fff" stop-opacity="0" offset="0%"/>
--             <stop stop-color="#fff" stop-opacity=".631" offset="63.146%"/>
--             <stop stop-color="#fff" offset="100%"/>
--         </linearGradient>
--     </defs>
--     <g fill="none" fill-rule="evenodd">
--         <g transform="translate(1 1)">
--             <path d="M36 18c0-9.94-8.06-18-18-18" id="Oval-2" stroke="url(#a)" stroke-width="2">
--                 <animateTransform
--                     attributeName="transform"
--                     type="rotate"
--                     from="0 18 18"
--                     to="360 18 18"
--                     dur="0.9s"
--                     repeatCount="indefinite" />
--             </path>
--             <circle fill="#fff" cx="36" cy="18" r="1">
--                 <animateTransform
--                     attributeName="transform"
--                     type="rotate"
--                     from="0 18 18"
--                     to="360 18 18"
--                     dur="0.9s"
--                     repeatCount="indefinite" />
--             </circle>
--         </g>
--     </g>
-- </svg>
