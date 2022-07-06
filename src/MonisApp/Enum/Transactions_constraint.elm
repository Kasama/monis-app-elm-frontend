-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Enum.Transactions_constraint exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| unique or primary key constraints on table "transactions"

  - Transactions\_pkey - unique or primary key constraint on columns "id"

-}
type Transactions_constraint
    = Transactions_pkey


list : List Transactions_constraint
list =
    [ Transactions_pkey ]


decoder : Decoder Transactions_constraint
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "transactions_pkey" ->
                        Decode.succeed Transactions_pkey

                    _ ->
                        Decode.fail ("Invalid Transactions_constraint type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : Transactions_constraint -> String
toString enum____ =
    case enum____ of
        Transactions_pkey ->
            "transactions_pkey"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe Transactions_constraint
fromString enumString____ =
    case enumString____ of
        "transactions_pkey" ->
            Just Transactions_pkey

        _ ->
            Nothing