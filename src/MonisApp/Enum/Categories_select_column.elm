-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Enum.Categories_select_column exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| select columns of table "categories"

  - Account - column name
  - Created\_at - column name
  - Deleted - column name
  - Icon - column name
  - Id - column name
  - Name - column name
  - Type - column name
  - Updated\_at - column name
  - User\_id - column name

-}
type Categories_select_column
    = Account
    | Created_at
    | Deleted
    | Icon
    | Id
    | Name
    | Type
    | Updated_at
    | User_id


list : List Categories_select_column
list =
    [ Account, Created_at, Deleted, Icon, Id, Name, Type, Updated_at, User_id ]


decoder : Decoder Categories_select_column
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "account" ->
                        Decode.succeed Account

                    "created_at" ->
                        Decode.succeed Created_at

                    "deleted" ->
                        Decode.succeed Deleted

                    "icon" ->
                        Decode.succeed Icon

                    "id" ->
                        Decode.succeed Id

                    "name" ->
                        Decode.succeed Name

                    "type" ->
                        Decode.succeed Type

                    "updated_at" ->
                        Decode.succeed Updated_at

                    "user_id" ->
                        Decode.succeed User_id

                    _ ->
                        Decode.fail ("Invalid Categories_select_column type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : Categories_select_column -> String
toString enum____ =
    case enum____ of
        Account ->
            "account"

        Created_at ->
            "created_at"

        Deleted ->
            "deleted"

        Icon ->
            "icon"

        Id ->
            "id"

        Name ->
            "name"

        Type ->
            "type"

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
fromString : String -> Maybe Categories_select_column
fromString enumString____ =
    case enumString____ of
        "account" ->
            Just Account

        "created_at" ->
            Just Created_at

        "deleted" ->
            Just Deleted

        "icon" ->
            Just Icon

        "id" ->
            Just Id

        "name" ->
            Just Name

        "type" ->
            Just Type

        "updated_at" ->
            Just Updated_at

        "user_id" ->
            Just User_id

        _ ->
            Nothing
