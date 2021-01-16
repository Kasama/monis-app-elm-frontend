module Objects.Account exposing (Account, accountSelector)

import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import MonisApp.Enum.AccountType exposing (AccountType(..))
import MonisApp.Object.Account as AccountResult
import MonisApp.Query as Query
import MonisApp.Scalar exposing (Id)


type alias Account =
    { amount : String
    , currency : String
    , icon : Maybe String
    , id : Id
    , isActive : Bool
    , name : String
    , type_ : AccountType
    }


accountSelector : SelectionSet (List Account) RootQuery
accountSelector =
    Query.accounts
        (SelectionSet.map7 Account
            AccountResult.amount
            AccountResult.currency
            AccountResult.icon
            AccountResult.id
            AccountResult.isActive
            AccountResult.name
            AccountResult.type_
        )


accountQuery =
    Query.accounts
