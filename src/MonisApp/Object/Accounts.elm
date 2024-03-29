-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Object.Accounts exposing (..)

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


created_at : SelectionSet MonisApp.ScalarCodecs.Timestamptz MonisApp.Object.Accounts
created_at =
    Object.selectionForField "ScalarCodecs.Timestamptz" "created_at" [] (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapCodecs |> .codecTimestamptz |> .decoder)


deleted : SelectionSet Bool MonisApp.Object.Accounts
deleted =
    Object.selectionForField "Bool" "deleted" [] Decode.bool


id : SelectionSet MonisApp.ScalarCodecs.Uuid MonisApp.Object.Accounts
id =
    Object.selectionForField "ScalarCodecs.Uuid" "id" [] (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapCodecs |> .codecUuid |> .decoder)


name : SelectionSet String MonisApp.Object.Accounts
name =
    Object.selectionForField "String" "name" [] Decode.string


updated_at : SelectionSet MonisApp.ScalarCodecs.Timestamptz MonisApp.Object.Accounts
updated_at =
    Object.selectionForField "ScalarCodecs.Timestamptz" "updated_at" [] (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapCodecs |> .codecTimestamptz |> .decoder)


{-| An object relationship
-}
user :
    SelectionSet decodesTo MonisApp.Object.Users
    -> SelectionSet decodesTo MonisApp.Object.Accounts
user object____ =
    Object.selectionForCompositeField "user" [] object____ Basics.identity


user_id : SelectionSet String MonisApp.Object.Accounts
user_id =
    Object.selectionForField "String" "user_id" [] Decode.string
