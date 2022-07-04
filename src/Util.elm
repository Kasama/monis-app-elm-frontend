module Util exposing (..)


capitalize : String -> String
capitalize str =
    str
        |> String.uncons
        |> Maybe.map (\( head, tail ) -> String.cons (Char.toUpper head) tail)
        |> Maybe.withDefault ""


foldl1 : (a -> a -> a) -> List a -> Maybe a
foldl1 f list =
    case list of
        [] ->
            Nothing

        e :: rest ->
            Just (List.foldl f e rest)
