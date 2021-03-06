-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Query exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import MonisApp.Enum.CategoryType
import MonisApp.InputObject
import MonisApp.Interface
import MonisApp.Object
import MonisApp.Scalar
import MonisApp.ScalarCodecs
import MonisApp.Union


accounts :
    SelectionSet decodesTo MonisApp.Object.Account
    -> SelectionSet (List decodesTo) RootQuery
accounts object_ =
    Object.selectionForCompositeField "accounts" [] object_ (identity >> Decode.list)


type alias CategoriesOptionalArguments =
    { type_ : OptionalArgument MonisApp.Enum.CategoryType.CategoryType }


categories :
    (CategoriesOptionalArguments -> CategoriesOptionalArguments)
    -> SelectionSet decodesTo MonisApp.Object.Category
    -> SelectionSet (Maybe (List decodesTo)) RootQuery
categories fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { type_ = Absent }

        optionalArgs =
            [ Argument.optional "type" filledInOptionals.type_ (Encode.enum MonisApp.Enum.CategoryType.toString) ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "categories" optionalArgs object_ (identity >> Decode.list >> Decode.nullable)


type alias NodeRequiredArguments =
    { id : MonisApp.ScalarCodecs.Id }


{-|

  - id - The id of an object.

-}
node :
    NodeRequiredArguments
    -> SelectionSet decodesTo MonisApp.Interface.Node
    -> SelectionSet (Maybe decodesTo) RootQuery
node requiredArgs object_ =
    Object.selectionForCompositeField "node" [ Argument.required "id" requiredArgs.id (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapEncoder .codecId) ] object_ (identity >> Decode.nullable)


type alias TransactionsOptionalArguments =
    { accountId : OptionalArgument MonisApp.ScalarCodecs.Id
    , categoryId : OptionalArgument MonisApp.ScalarCodecs.Id
    , id : OptionalArgument MonisApp.ScalarCodecs.Id
    }


transactions :
    (TransactionsOptionalArguments -> TransactionsOptionalArguments)
    -> SelectionSet decodesTo MonisApp.Object.Transaction
    -> SelectionSet (List decodesTo) RootQuery
transactions fillInOptionals object_ =
    let
        filledInOptionals =
            fillInOptionals { accountId = Absent, categoryId = Absent, id = Absent }

        optionalArgs =
            [ Argument.optional "accountId" filledInOptionals.accountId (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapEncoder .codecId), Argument.optional "categoryId" filledInOptionals.categoryId (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapEncoder .codecId), Argument.optional "id" filledInOptionals.id (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapEncoder .codecId) ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "transactions" optionalArgs object_ (identity >> Decode.list)


user :
    SelectionSet decodesTo MonisApp.Object.User
    -> SelectionSet decodesTo RootQuery
user object_ =
    Object.selectionForCompositeField "user" [] object_ identity
