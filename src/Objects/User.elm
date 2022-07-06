module Objects.User exposing (Token, User, decoder, encoder)

import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import MonisApp.Object exposing (Users)
import MonisApp.Object.Users
import MonisApp.Query as Query
import MonisApp.Scalar exposing (Uuid(..))


type alias Token =
    String


type Login
    = Login Token InternalUser


type alias InternalUser =
    { email : String
    , id : String
    , isActive : Bool
    , name : String
    }


type alias User =
    { email : String
    , id : String
    , isActive : Bool
    , name : String
    , token : Token
    }


userBuilder : Token -> String -> String -> Bool -> String -> User
userBuilder token email id isActive name =
    { token = token
    , email = email
    , id = id
    , isActive = isActive
    , name = name
    }


encoder : User -> Value
encoder u =
    Encode.object
        [ ( "token", Encode.string u.token )
        , ( "email", Encode.string u.email )
        , ( "id", Encode.string u.id )
        , ( "isActive", Encode.bool u.isActive )
        , ( "name", Encode.string u.name )
        ]


decoder : Decoder User
decoder =
    Decode.map5 userBuilder
        (Decode.field "token" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "id" Decode.string)
        (Decode.field "isActive" Decode.bool)
        (Decode.field "name" Decode.string)


user : Login -> User
user (Login token internalUser) =
    { email = internalUser.email
    , id = internalUser.id
    , isActive = internalUser.isActive
    , name = internalUser.name
    , token = token
    }


userQuery : () -> SelectionSet (List InternalUser) RootQuery
userQuery args =
    Query.users identity userSelector


userSelector : SelectionSet InternalUser Users
userSelector =
    SelectionSet.map4 InternalUser
        MonisApp.Object.Users.email
        MonisApp.Object.Users.id
        MonisApp.Object.Users.active
        MonisApp.Object.Users.name
