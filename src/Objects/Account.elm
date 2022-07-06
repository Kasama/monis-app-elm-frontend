module Objects.Account exposing (Account)

import MonisApp.Scalar exposing (Uuid)


type alias Account =
    { amount : String
    , currency : String
    , icon : Maybe String
    , id : Uuid
    , isActive : Bool
    , name : String
    }
