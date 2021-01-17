module Objects.Category exposing (Category, categorySelector)

import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import MonisApp.Enum.CategoryType exposing (CategoryType)
import MonisApp.Object as Object
import MonisApp.Object.Category as Category
import MonisApp.Scalar exposing (Id(..))


type alias Category =
    { icon : String
    , id : Id
    , name : String
    , type_ : CategoryType
    }


categorySelector : SelectionSet Category Object.Category
categorySelector =
    SelectionSet.map4 Category
        Category.icon
        Category.id
        Category.name
        Category.type_
