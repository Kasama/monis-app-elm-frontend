-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Object.Categories exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import MonisApp.InputObject
import MonisApp.Interface
import MonisApp.Object
import MonisApp.Scalar
import MonisApp.ScalarCodecs
import MonisApp.Union


account : SelectionSet MonisApp.ScalarCodecs.Uuid MonisApp.Object.Categories
account =
    Object.selectionForField "ScalarCodecs.Uuid" "account" [] (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapCodecs |> .codecUuid |> .decoder)


created_at : SelectionSet MonisApp.ScalarCodecs.Timestamptz MonisApp.Object.Categories
created_at =
    Object.selectionForField "ScalarCodecs.Timestamptz" "created_at" [] (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapCodecs |> .codecTimestamptz |> .decoder)


deleted : SelectionSet Bool MonisApp.Object.Categories
deleted =
    Object.selectionForField "Bool" "deleted" [] Decode.bool


icon : SelectionSet String MonisApp.Object.Categories
icon =
    Object.selectionForField "String" "icon" [] Decode.string


id : SelectionSet MonisApp.ScalarCodecs.Uuid MonisApp.Object.Categories
id =
    Object.selectionForField "ScalarCodecs.Uuid" "id" [] (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapCodecs |> .codecUuid |> .decoder)


name : SelectionSet String MonisApp.Object.Categories
name =
    Object.selectionForField "String" "name" [] Decode.string


type_ : SelectionSet String MonisApp.Object.Categories
type_ =
    Object.selectionForField "String" "type" [] Decode.string


updated_at : SelectionSet MonisApp.ScalarCodecs.Timestamptz MonisApp.Object.Categories
updated_at =
    Object.selectionForField "ScalarCodecs.Timestamptz" "updated_at" [] (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapCodecs |> .codecTimestamptz |> .decoder)


user_id : SelectionSet String MonisApp.Object.Categories
user_id =
    Object.selectionForField "String" "user_id" [] Decode.string