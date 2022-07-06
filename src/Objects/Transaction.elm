module Objects.Transaction exposing (Transaction, transactionQuery, transactionSelector)

import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import MonisApp.InputObject exposing (buildTransactions_bool_exp, buildUuid_comparison_exp)
import MonisApp.Object as Object
import MonisApp.Object.Transactions as Transactions
import MonisApp.Query as Query
import MonisApp.Scalar exposing (Timestamptz, Uuid(..))
import Objects.QueryUtils as QueryUtils exposing (eq_, maybe_eq_)


type alias Transaction =
    { comment : Maybe String
    , id : Uuid
    , payee : String
    , transactionDate : Timestamptz
    , value : Int
    }


type alias QueryParams =
    { accountId : Maybe Uuid
    , categoryId : Maybe Uuid
    }



-- Query Utils


where_ :
    (MonisApp.InputObject.Transactions_bool_expOptionalFields -> MonisApp.InputObject.Transactions_bool_expOptionalFields)
    -> { c | where_ : OptionalArgument MonisApp.InputObject.Transactions_bool_exp }
    -> { c | where_ : OptionalArgument MonisApp.InputObject.Transactions_bool_exp }
where_ =
    QueryUtils.where_ buildTransactions_bool_exp


and_ :
    List
        (MonisApp.InputObject.Transactions_bool_expOptionalFields -> MonisApp.InputObject.Transactions_bool_expOptionalFields)
    -> { c | and_ : OptionalArgument (List MonisApp.InputObject.Transactions_bool_exp) }
    -> { c | and_ : OptionalArgument (List MonisApp.InputObject.Transactions_bool_exp) }
and_ =
    QueryUtils.and_ buildTransactions_bool_exp



-- Queries


transactionByIdQuery : Uuid -> SelectionSet (List Transaction) RootQuery
transactionByIdQuery id =
    let
        id_ val opts =
            { opts | id = Present <| buildUuid_comparison_exp val }
    in
    Query.transactions
        (where_ <|
            id_ <|
                eq_ id
        )
        transactionSelector


transactionQuery : QueryParams -> SelectionSet (List Transaction) RootQuery
transactionQuery args =
    let
        account_id_ val opts =
            { opts | account_id = Present <| buildUuid_comparison_exp val }

        category_id_ val opts =
            { opts | category_id = Present <| buildUuid_comparison_exp val }
    in
    Query.transactions
        (where_ <|
            and_
                [ account_id_ <|
                    maybe_eq_ args.accountId
                , category_id_ <|
                    maybe_eq_ args.categoryId
                ]
        )
        transactionSelector


transactionSelector : SelectionSet Transaction Object.Transactions
transactionSelector =
    SelectionSet.map5 Transaction
        Transactions.comment
        Transactions.id
        Transactions.payee
        Transactions.created_at
        Transactions.amount
