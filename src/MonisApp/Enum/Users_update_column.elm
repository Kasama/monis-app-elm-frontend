-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Enum.Users_update_column exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| update columns of table "users"

  - Active - column name
  - Email - column name
  - Id - column name
  - Name - column name

-}
type Users_update_column
    = Active
    | Email
    | Id
    | Name


list : List Users_update_column
list =
    [ Active, Email, Id, Name ]


decoder : Decoder Users_update_column
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "active" ->
                        Decode.succeed Active

                    "email" ->
                        Decode.succeed Email

                    "id" ->
                        Decode.succeed Id

                    "name" ->
                        Decode.succeed Name

                    _ ->
                        Decode.fail ("Invalid Users_update_column type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : Users_update_column -> String
toString enum____ =
    case enum____ of
        Active ->
            "active"

        Email ->
            "email"

        Id ->
            "id"

        Name ->
            "name"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe Users_update_column
fromString enumString____ =
    case enumString____ of
        "active" ->
            Just Active

        "email" ->
            Just Email

        "id" ->
            Just Id

        "name" ->
            Just Name

        _ ->
            Nothing
