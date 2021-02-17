module Page.Home exposing (Model, Msg(..), init, sessionOf, subscriptions, update, view)

import Backend.Graphql exposing (Data, getErrorMessages)
import Components.Icon exposing (icon)
import Components.Loader as Loader
import Css
import Html exposing (a, aside, div, footer, h2, li, main_, nav, p, span, text, ul)
import Html.Events exposing (onClick)
import MonisApp.Enum.AccountType as AccountType
import Objects.Account exposing (Account, accountSelector)
import Objects.Transaction as Transaction exposing (Transaction)
import Objects.User exposing (User)
import Page
import RemoteData
import Route
import Session exposing (Session, SessionType(..))


type alias Model =
    { session : Session
    , state : HomeState
    , errors : List String
    }


type HomeState
    = Guest
    | NotGuest User WithUser


type WithUser
    = NoAccounts
    | WithAccounts (List Account) WithAccounts


type WithAccounts
    = NoSelectedAccount
    | WithSelectedAccount Account WithSelectedAccount


type WithSelectedAccount
    = NoTransactions
    | WithTransactions (List Transaction)


type Msg
    = Noop
    | Logout
    | FetchAccounts
    | GotAccounts (Data (List Account))
    | GotTransactions (Data (List Transaction))
    | SelectAccount Account
    | ClearError String


sessionOf : Model -> Session
sessionOf =
    .session


init : Session -> ( Model, Cmd Msg )
init session =
    let
        model =
            { session = session
            , state =
                case session.kind of
                    Session.Guest ->
                        Guest

                    Session.LoggedIn user ->
                        NotGuest user NoAccounts
            , errors = []
            }
    in
    ( model, fetchAccounts model )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        session =
            sessionOf model
    in
    case ( msg, model.state ) of
        ( Noop, _ ) ->
            ( model, Cmd.none )

        ( Logout, _ ) ->
            ( { model | session = { session | kind = Session.Guest }, state = Guest }, Session.cleanSession )

        ( ClearError err, _ ) ->
            ( { model | errors = List.filter ((/=) err) model.errors }, Cmd.none )

        ( FetchAccounts, NotGuest _ NoAccounts ) ->
            ( model, fetchAccounts model )

        ( GotAccounts remoteAccounts, NotGuest user NoAccounts ) ->
            case remoteAccounts of
                RemoteData.Success accounts ->
                    ( { model | state = NotGuest user (WithAccounts accounts NoSelectedAccount) }, Cmd.none )

                RemoteData.Failure err ->
                    ( { model | errors = getErrorMessages err }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ( SelectAccount account, NotGuest user (WithAccounts accounts _) ) ->
            let
                newModel =
                    { model | state = NotGuest user (WithAccounts accounts (WithSelectedAccount account NoTransactions)) }
            in
            ( newModel, fetchTransactions newModel )

        ( GotTransactions remoteTransactions, NotGuest user (WithAccounts accounts (WithSelectedAccount selectedAccount NoTransactions)) ) ->
            case remoteTransactions of
                RemoteData.Success transactions ->
                    ( { model | state = NotGuest user (WithAccounts accounts (WithSelectedAccount selectedAccount (WithTransactions transactions))) }, Cmd.none )

                RemoteData.Failure err ->
                    ( { model | errors = getErrorMessages err }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            Debug.todo "This should never happen"


fetchTransactions : Model -> Cmd Msg
fetchTransactions model =
    case model.state of
        NotGuest user (WithAccounts _ (WithSelectedAccount selectedAccount _)) ->
            Backend.Graphql.makeQueryRequest (Just user.token)
                (Transaction.transactionQuery
                    { accountId = Just selectedAccount.id
                    , categoryId = Nothing
                    }
                )
                GotTransactions

        _ ->
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
        div [ Css.tw "flex flex-col w-full h-full" ]
            [ div
                [ Css.tw "flex-col bg-rose-800 p-2 my-10"
                , if List.isEmpty model.errors then
                    Css.tw "hidden"

                  else
                    Css.tw "flex"
                ]
              <|
                List.map
                    (\err ->
                        div [ Css.tw "flex flex-row w-full justify-between" ]
                            [ span [] [ text err ]
                            , span [ Html.Events.onClick (ClearError err) ] [ text "x" ]
                            ]
                    )
                    model.errors
            , case model.state of
                Guest ->
                    div [ Css.tw "flex flex-col w-1/5" ]
                        [ a [ Css.btn "blue", Route.href Route.Login ]
                            [ text "Login now!" ]
                        ]

                NotGuest _ withUserState ->
                    div
                        [ Css.tw "flex flex-row h-full w-full"
                        ]
                        [ aside [ Css.tw "flex flex-col h-full w-1/5 bg-complement" ]
                            (case withUserState of
                                WithAccounts accounts withAccountsState ->
                                    List.concat
                                        (let
                                            isSelected account =
                                                case withAccountsState of
                                                    WithSelectedAccount a _ ->
                                                        a.id == account.id

                                                    NoSelectedAccount ->
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
                                                    accounts
                                         in
                                         [ ( "Debit Accounts:", debitAccounts ), ( "Credit Accounts:", creditAccounts ) ]
                                            |> List.map
                                                (\( title, partialAccounts ) ->
                                                    if List.isEmpty partialAccounts then
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
                                                                                "bg-brightshade-600"

                                                                             else
                                                                                "hover:bg-accentshade-700 cursor-pointer"
                                                                            )
                                                                        , Html.Events.onClick (SelectAccount acc)
                                                                        ]
                                                                        [ icon <| Maybe.withDefault "piggy-bank" acc.icon
                                                                        , span [ Css.tw "ml-2 text-md" ] [ text acc.name ]
                                                                        ]
                                                                )
                                                                partialAccounts
                                                        ]
                                                )
                                        )

                                _ ->
                                    []
                            )
                        , main_
                            [ Css.tw "flex flex-col justify-center items-center"
                            , Css.tw "w-full flex-grow"
                            ]
                            [ nav [] []
                            , div [ Css.tw "flex flex-col w-3/5" ]
                                (case withUserState of
                                    WithAccounts _ (WithSelectedAccount account withTransactionsState) ->
                                        [ p [] [ text <| "Using account: " ++ account.name ]
                                        , ul []
                                            (case withTransactionsState of
                                                WithTransactions transactions ->
                                                    List.map (\t -> li [] [ text <| Maybe.withDefault "no comment" t.comment ])
                                                        transactions

                                                _ ->
                                                    [ Loader.rings [] [] ]
                                            )
                                        ]

                                    WithAccounts _ _ ->
                                        [ p [] [ text "No account selected." ]
                                        , p [] [ text "Select one on the left panel." ]
                                        ]

                                    _ ->
                                        []
                                )
                            ]
                        ]
            ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
