module Backend.Graphql exposing (..)

import Backend.Endpoint exposing (graphqlEndpoint)
import Graphql.Http as GraphqlHttp exposing (RawError(..))
import Graphql.Operation as Operation
import Graphql.SelectionSet exposing (SelectionSet)
import Objects.User exposing (Token)
import RemoteData as RemoteData exposing (RemoteData)


type alias Data decodesTo =
    RemoteData (GraphqlHttp.Error decodesTo) decodesTo


getErrorMessages : GraphqlHttp.Error data -> List String
getErrorMessages error =
    case error of
        GraphqlHttp.GraphqlError _ graphqlError ->
            graphqlError |> List.map (\e -> e.message)

        GraphqlHttp.HttpError httpError ->
            [ httpError |> Debug.toString ]


authorizationHeader : Maybe Token -> (GraphqlHttp.Request decodesTo -> GraphqlHttp.Request decodesTo)
authorizationHeader maybeToken =
    case maybeToken of
        Nothing ->
            identity

        Just token ->
            GraphqlHttp.withHeader "Authorization" ("Bearer " ++ token)


makeMutationRequest : Maybe Token -> SelectionSet decodesTo Operation.RootMutation -> (Data decodesTo -> msg) -> Cmd msg
makeMutationRequest maybeToken mutation msgWrapper =
    mutation
        |> GraphqlHttp.mutationRequest graphqlEndpoint
        |> authorizationHeader maybeToken
        |> GraphqlHttp.send (RemoteData.fromResult >> msgWrapper)


makeQueryRequest : Maybe Token -> SelectionSet decodesTo Operation.RootQuery -> (Data decodesTo -> msg) -> Cmd msg
makeQueryRequest maybeToken query msgWrapper =
    query
        |> GraphqlHttp.queryRequest graphqlEndpoint
        |> authorizationHeader maybeToken
        |> GraphqlHttp.send (RemoteData.fromResult >> msgWrapper)
