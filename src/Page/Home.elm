module Page.Home exposing (Model, Msg(..), init, sessionOf, subscriptions, update, view)

import Backend.Graphql exposing (Data, getErrorMessages)
import Components.Icon as Icon exposing (icon)
import Css
import Html exposing (a, aside, button, div, footer, h1, h2, i, li, main_, nav, p, span, text, ul)
import Html.Events exposing (onClick)
import MonisApp.Enum.AccountType as AccountType exposing (AccountType)
import Objects.Account exposing (Account, accountSelector)
import Objects.Transaction as Transaction exposing (Transaction)
import Page
import RemoteData
import Route
import Session exposing (Session, SessionType(..))


type alias Model =
    { session : Session
    , accounts : List Account
    , selectedAccount : Maybe Account
    , errors : List String
    , transactions : List Transaction
    }


type Msg
    = Noop
    | Logout
    | FetchAccounts
    | GotAccounts (Data (List Account))
    | GotTransactions (Data (List Transaction))
    | SelectAccount Account


sessionOf : Model -> Session
sessionOf =
    .session


init : Session -> ( Model, Cmd Msg )
init session =
    let
        model =
            { session = session
            , accounts = []
            , selectedAccount = Nothing
            , errors = []
            , transactions = []
            }
    in
    ( model, fetchAccounts model )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        session =
            sessionOf model

        debugUpdate =
            Debug.log ("Got update. Msg: " ++ Debug.toString msg ++ " -- Model: " ++ Debug.toString model) 1
    in
    case msg of
        Noop ->
            ( model, Cmd.none )

        Logout ->
            ( { model | session = { session | kind = Session.Guest }, accounts = [] }, Session.cleanSession )

        FetchAccounts ->
            ( model, fetchAccounts model )

        GotAccounts remoteAccounts ->
            case remoteAccounts of
                RemoteData.Success accounts ->
                    ( { model | accounts = accounts }, Cmd.none )

                RemoteData.Failure err ->
                    ( { model | errors = getErrorMessages err }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        GotTransactions remoteTransactions ->
            case remoteTransactions of
                RemoteData.Success transactions ->
                    ( { model | transactions = transactions }, Cmd.none )

                RemoteData.Failure err ->
                    ( { model | errors = getErrorMessages err }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        SelectAccount account ->
            ( { model | selectedAccount = Just account }, fetchTransactions model )


fetchTransactions : Model -> Cmd Msg
fetchTransactions model =
    case ( .kind <| sessionOf model, model.selectedAccount ) of
        ( LoggedIn user, Just acc ) ->
            Backend.Graphql.makeQueryRequest (Just user.token)
                (Transaction.transactionQuery
                    { accountId = Just acc.id
                    , categoryId = Nothing
                    }
                )
                GotTransactions

        ( _, _ ) ->
            Cmd.none


fetchAccounts : Model -> Cmd Msg
fetchAccounts model =
    let
        session =
            sessionOf model
    in
    case session.kind of
        Session.LoggedIn user ->
            Backend.Graphql.makeQueryRequest (Just user.token) accountSelector GotAccounts

        Session.Guest ->
            Cmd.none


view : Model -> Page.Root Msg
view model =
    let
        ifLoggedIn term true false =
            case term of
                Session.LoggedIn user ->
                    true user

                _ ->
                    false

        debugView =
            Debug.log ("Got view. Model: " ++ Debug.toString model) 1
    in
    { title = ifLoggedIn model.session.kind (\user -> "Hello " ++ user.name) "Hello"
    , navBar =
        { logoutMsg = Logout
        , content =
            div
                [ Css.tw "flex-grow flex flex-col justify-center items-center" ]
                [ text "Helloo" ]
        }
    , footer = footer [] []
    , content =
        case model.session.kind of
            Session.Guest ->
                div [ Css.tw "flex flex-col w-1/5" ]
                    [ p [] [ text ("Model: " ++ Debug.toString model) ]
                    , a [ Css.btn "blue", Route.href Route.Login ]
                        [ text "Login now!" ]
                    ]

            Session.LoggedIn user ->
                div
                    [ Css.tw "flex flex-row h-full w-full"
                    ]
                    [ aside [ Css.tw "flex flex-col h-full w-1/5 bg-complement" ]
                        (List.concat
                            (let
                                isSelected account =
                                    case model.selectedAccount of
                                        Just a ->
                                            a.id == account.id

                                        Nothing ->
                                            False

                                ( debitAccounts, creditAccounts ) =
                                    List.partition
                                        (\account ->
                                            case account.type_ of
                                                AccountType.Debit ->
                                                    True

                                                AccountType.Credit ->
                                                    False
                                        )
                                        model.accounts
                             in
                             [ ( "Debit Accounts:", debitAccounts ), ( "Credit Accounts:", creditAccounts ) ]
                                |> List.map
                                    (\( title, accounts ) ->
                                        if List.isEmpty accounts then
                                            []

                                        else
                                            [ h2 [ Css.tw "text-lg py-3 px-5" ] [ text title ]
                                            , ul [ Css.tw "md-shadow" ] <|
                                                List.map
                                                    (\acc ->
                                                        li
                                                            [ Css.tw "p-5"
                                                            , Css.tw
                                                                (if isSelected acc then
                                                                    "bg-highlight"

                                                                 else
                                                                    "hover:bg-accent cursor-pointer"
                                                                )
                                                            , Html.Events.onClick (SelectAccount acc)
                                                            ]
                                                            [ icon <| Maybe.withDefault "piggy-bank" acc.icon
                                                            , span [ Css.tw "ml-2 text-md" ] [ text acc.name ]
                                                            ]
                                                    )
                                                    accounts
                                            ]
                                    )
                            )
                        )
                    , main_
                        [ Css.tw "flex flex-col justify-center items-center"
                        , Css.tw "w-full flex-grow"
                        ]
                        [ nav [] []
                        , div [ Css.tw "flex flex-col w-3/5" ]
                            (case model.selectedAccount of
                                Nothing ->
                                    [ p [] [ text "No account selected." ]
                                    , p [] [ text "Select one on the left panel." ]
                                    ]

                                Just account ->
                                    [ p [] [ text <| "Using account: " ++ account.name ]
                                    , ul []
                                        (List.map (\t -> li [] [ text <| Maybe.withDefault "no comment" t.comment ])
                                            model.transactions
                                        )
                                    ]
                            )
                        ]
                    ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
