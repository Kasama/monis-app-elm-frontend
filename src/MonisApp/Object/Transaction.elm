-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Object.Transaction exposing (..)

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


account :
    SelectionSet decodesTo MonisApp.Object.Account
    -> SelectionSet decodesTo MonisApp.Object.Transaction
account object_ =
    Object.selectionForCompositeField "account" [] object_ identity


category :
    SelectionSet decodesTo MonisApp.Object.Category
    -> SelectionSet decodesTo MonisApp.Object.Transaction
category object_ =
    Object.selectionForCompositeField "category" [] object_ identity


comment : SelectionSet (Maybe String) MonisApp.Object.Transaction
comment =
    Object.selectionForField "(Maybe String)" "comment" [] (Decode.string |> Decode.nullable)


{-| The ID of an object
-}
id : SelectionSet MonisApp.ScalarCodecs.Id MonisApp.Object.Transaction
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapCodecs |> .codecId |> .decoder)


payee : SelectionSet String MonisApp.Object.Transaction
payee =
    Object.selectionForField "String" "payee" [] Decode.string


transactionDate : SelectionSet String MonisApp.Object.Transaction
transactionDate =
    Object.selectionForField "String" "transactionDate" [] Decode.string


value : SelectionSet String MonisApp.Object.Transaction
value =
    Object.selectionForField "String" "value" [] Decode.string
