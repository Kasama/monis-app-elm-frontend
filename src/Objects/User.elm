module Objects.User exposing (Token, User, decoder, encoder, loginMutation)

import Graphql.Operation exposing (RootMutation)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import MonisApp.Mutation as Mutation
import MonisApp.Object exposing (LoginResult)
import MonisApp.Object.LoginResult as LoginResult
import MonisApp.Object.User as UserResult
import MonisApp.Scalar exposing (Id(..))


type alias Token =
    String


type Login
    = Login Token InternalUser


type alias InternalUser =
    { email : String
    , id : Id
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



-- Newer syntax based on record composition. Not supported by elm-typescript-interop
-- type alias CredentialHolder a =
--     { a
--         | token : Token
--         , id : String
--     }
--
--
-- type alias User =
--     CredentialHolder InternalUser


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


loginMutation : Mutation.LoginRequiredArguments -> SelectionSet (Maybe User) RootMutation
loginMutation args =
    Mutation.login args loginSelector


user : Login -> User
user (Login token internalUser) =
    { email = internalUser.email
    , id =
        case internalUser.id of
            Id id ->
                id
    , isActive = internalUser.isActive
    , name = internalUser.name
    , token = token
    }


loginSelector : SelectionSet User LoginResult
loginSelector =
    SelectionSet.map user
        (SelectionSet.map2 Login
            LoginResult.token
            (LoginResult.user
                (SelectionSet.map4 InternalUser
                    UserResult.email
                    UserResult.id
                    UserResult.isActive
                    UserResult.name
                )
            )
        )
