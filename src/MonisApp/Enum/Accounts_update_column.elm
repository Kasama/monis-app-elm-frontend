-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Enum.Accounts_update_column exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| update columns of table "accounts"

  - Created\_at - column name
  - Deleted - column name
  - Id - column name
  - Name - column name
  - Updated\_at - column name
  - User\_id - column name

-}
type Accounts_update_column
    = Created_at
    | Deleted
    | Id
    | Name
    | Updated_at
    | User_id


list : List Accounts_update_column
list =
    [ Created_at, Deleted, Id, Name, Updated_at, User_id ]


decoder : Decoder Accounts_update_column
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "created_at" ->
                        Decode.succeed Created_at

                    "deleted" ->
                        Decode.succeed Deleted

                    "id" ->
                        Decode.succeed Id

                    "name" ->
                        Decode.succeed Name

                    "updated_at" ->
                        Decode.succeed Updated_at

                    "user_id" ->
                        Decode.succeed User_id

                    _ ->
                        Decode.fail ("Invalid Accounts_update_column type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : Accounts_update_column -> String
toString enum____ =
    case enum____ of
        Created_at ->
            "created_at"

        Deleted ->
            "deleted"

        Id ->
            "id"

        Name ->
            "name"

        Updated_at ->
            "updated_at"

        User_id ->
            "user_id"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe Accounts_update_column
fromString enumString____ =
    case enumString____ of
        "created_at" ->
            Just Created_at

        "deleted" ->
            Just Deleted

        "id" ->
            Just Id

        "name" ->
            Just Name

        "updated_at" ->
            Just Updated_at

        "user_id" ->
            Just User_id

        _ ->
            Nothing
