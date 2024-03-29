-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Enum.Accounts_constraint exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| unique or primary key constraints on table "accounts"

  - Accounts\_pkey - unique or primary key constraint on columns "id"

-}
type Accounts_constraint
    = Accounts_pkey


list : List Accounts_constraint
list =
    [ Accounts_pkey ]


decoder : Decoder Accounts_constraint
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "accounts_pkey" ->
                        Decode.succeed Accounts_pkey

                    _ ->
                        Decode.fail ("Invalid Accounts_constraint type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : Accounts_constraint -> String
toString enum____ =
    case enum____ of
        Accounts_pkey ->
            "accounts_pkey"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe Accounts_constraint
fromString enumString____ =
    case enumString____ of
        "accounts_pkey" ->
            Just Accounts_pkey

        _ ->
            Nothing
