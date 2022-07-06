module Objects.QueryUtils exposing (..)

import Graphql.OptionalArgument exposing (OptionalArgument(..), fromMaybe)


where_ : (b -> a) -> b -> { c | where_ : OptionalArgument a } -> { c | where_ : OptionalArgument a }
where_ expressionBuilder val opts =
    { opts | where_ = Present <| expressionBuilder val }


and_ : (a -> b) -> List a -> { c | and_ : OptionalArgument (List b) } -> { c | and_ : OptionalArgument (List b) }
and_ expressionBuilder val opts =
    { opts | and_ = Present <| List.map expressionBuilder val }


eq_ : a -> { b | eq_ : OptionalArgument a } -> { b | eq_ : OptionalArgument a }
eq_ val opts =
    { opts | eq_ = Present val }

maybe_eq_ : Maybe a -> { b | eq_ : OptionalArgument a } -> { b | eq_ : OptionalArgument a }
maybe_eq_ val opts =
    { opts | eq_ = fromMaybe val }
