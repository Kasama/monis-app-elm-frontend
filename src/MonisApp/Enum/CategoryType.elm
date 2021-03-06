-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Enum.CategoryType exposing (..)

import Json.Decode as Decode exposing (Decoder)


type CategoryType
    = Expense
    | Income
    | Transfer


list : List CategoryType
list =
    [ Expense, Income, Transfer ]


decoder : Decoder CategoryType
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "EXPENSE" ->
                        Decode.succeed Expense

                    "INCOME" ->
                        Decode.succeed Income

                    "TRANSFER" ->
                        Decode.succeed Transfer

                    _ ->
                        Decode.fail ("Invalid CategoryType type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : CategoryType -> String
toString enum =
    case enum of
        Expense ->
            "EXPENSE"

        Income ->
            "INCOME"

        Transfer ->
            "TRANSFER"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe CategoryType
fromString enumString =
    case enumString of
        "EXPENSE" ->
            Just Expense

        "INCOME" ->
            Just Income

        "TRANSFER" ->
            Just Transfer

        _ ->
            Nothing
