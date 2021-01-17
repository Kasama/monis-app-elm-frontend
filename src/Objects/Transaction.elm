module Objects.Transaction exposing (Transaction, transactionQuery, transactionSelector)

import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import MonisApp.Object as Object
import MonisApp.Object.Transaction as Transaction
import MonisApp.Query as Query
import MonisApp.Scalar exposing (Id(..))
import Objects.Category exposing (Category, categorySelector)


type alias Transaction =
    { category : Category
    , comment : Maybe String
    , id : Id
    , payee : String
    , transactionDate : String
    , value : String
    }


type alias QueryParams =
    { accountId : Maybe Id
    , categoryId : Maybe Id
    }


transactionByIdQuery : Id -> SelectionSet (List Transaction) RootQuery
transactionByIdQuery id =
    Query.transactions (\params -> { params | id = Present id }) transactionSelector


transactionQuery : QueryParams -> SelectionSet (List Transaction) RootQuery
transactionQuery args =
    let
        fromMaybe ma =
            case ma of
                Just a ->
                    Present a

                Nothing ->
                    Absent
    in
    Query.transactions
        (\params ->
            { params
                | accountId = fromMaybe args.accountId
                , categoryId = fromMaybe args.categoryId
            }
        )
        transactionSelector


transactionSelector : SelectionSet Transaction Object.Transaction
transactionSelector =
    SelectionSet.map6 Transaction
        (Transaction.category categorySelector)
        Transaction.comment
        Transaction.id
        Transaction.payee
        Transaction.transactionDate
        Transaction.value
