module Page.Login exposing (Model, Msg(..), init, makeRequest, sessionOf, subscriptions, update, view)

import Backend.Graphql
import Browser.Navigation as Nav
import Components.Loader
import Css
import Graphql.Http exposing (RawError(..))
import Html exposing (button, div, footer, form, input, label, nav, span, text)
import Html.Attributes as Attr
import Html.Events as Events
import MonisApp.Mutation exposing (LoginRequiredArguments)
import Objects.User exposing (User, loginMutation)
import Page
import Process
import RemoteData as RemoteData
import Session exposing (Session)
import Task
import Util


type alias ErrorType =
    String


type alias Model =
    { state : State
    , session : Session
    , errors : List ErrorType
    , form : Form
    }


type State
    = Idle
    | Loading


sessionOf : Model -> Session
sessionOf =
    .session


type alias LoginRemoteData =
    Backend.Graphql.Data (Maybe User)


type Msg
    = UpdateEmail String
    | UpdatePassword String
    | GotLogin LoginRemoteData
    | ClearError ErrorType
    | SubmitLogin


type alias Form =
    LoginRequiredArguments


view : Model -> Page.Root Msg
view model =
    let
        textInput lbl inputType onInput =
            div [ Css.tw "flex flex-col", Css.tw "mb-4" ]
                [ label [ Attr.value lbl, Attr.for lbl ] [ text ((lbl |> Util.capitalize) ++ ":") ]
                , input
                    [ Css.tw "border-b-2 outline-none"
                    , Css.tw "transform-gpu focus:scale-105 transition duration-100"
                    , Css.tw "bg-complement border-primary focus:border-accent"
                    , Attr.id lbl
                    , Attr.type_ inputType
                    , Attr.placeholder lbl
                    , Events.onInput onInput
                    ]
                    []
                ]

        debugView =
            Debug.log ("Got view. Model: " ++ Debug.toString model) 1
    in
    { title = "Login"
    , navBar = { logoutMsg = UpdateEmail "", content = nav [] [] }
    , footer = footer [] []
    , content =
        div
            [ Css.tw "mt-20"
            ]
            [ div
                []
                (model.errors
                    |> List.map
                        (\e ->
                            div
                                [ Css.tw "bg-red-500 rounded-md"
                                , Css.tw "my-2 p-1 px-3"
                                ]
                                [ div
                                    [ Css.tw "flex flex-row"
                                    ]
                                    [ text e
                                    , div [ Css.tw "flex-grow" ] []
                                    , button [ Events.onClick <| ClearError e ] [ text "x" ]
                                    ]
                                ]
                        )
                )
            , form
                [ Css.tw "bg-complement"
                , Css.tw "flex flex-grow flex-col"
                , Css.tw "shadow-md p-5 rounded-md"
                , Css.tw "min-w-full w-1/2"
                , Events.onSubmit SubmitLogin
                ]
                [ textInput "e-mail" "text" UpdateEmail
                , textInput "password" "password" UpdatePassword
                , div [ Css.tw "static" ]
                    [ button
                        [ Css.tw "flex flex-flow min-w-full justify-center outline-none"
                        , Css.tw
                            (if List.isEmpty model.errors then
                                ""

                             else
                                "animate-attention"
                            )
                        , Css.btn "green"
                        ]
                        [ div [ Css.tw "float-left" ]
                            (if model.state == Loading then
                                [ Components.Loader.rings [] [ Components.Loader.size 24 ] ]

                             else
                                []
                            )
                        , span [] [ text "Log in" ]
                        ]
                    ]
                ]
            ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        form =
            model.form

        debugUpdate =
            Debug.log ("Got update. Msg: " ++ Debug.toString msg ++ " -- Model: " ++ Debug.toString model) 1
    in
    case msg of
        GotLogin loginResponse ->
            handleGotLogin model loginResponse

        UpdateEmail string ->
            ( { model | form = { form | email = string } }, Cmd.none )

        UpdatePassword string ->
            ( { model | form = { form | password = string } }, Cmd.none )

        SubmitLogin ->
            ( { model | state = Loading }, makeRequest form )

        ClearError errortype ->
            ( { model | errors = List.filter ((/=) errortype) model.errors }, Cmd.none )


handleGotLogin : Model -> LoginRemoteData -> ( Model, Cmd Msg )
handleGotLogin model remoteData =
    let
        session =
            model.session

        newSession data =
            { session | kind = Session.LoggedIn data }

        clearErrorAfter sleep errors =
            Cmd.batch <|
                List.map
                    (\e -> Task.perform (\_ -> ClearError e) <| Process.sleep sleep)
                    errors
    in
    case remoteData of
        RemoteData.Success maybeData ->
            case maybeData of
                Just data ->
                    ( { model | session = newSession data, errors = [], state = Idle }
                    , Cmd.batch
                        [ Nav.back session.navKey 1
                        , Session.saveSession <| newSession data
                        ]
                    )

                Nothing ->
                    let
                        err =
                            [ "No login found" ]
                    in
                    ( { model | errors = err }, clearErrorAfter 2000 err )

        RemoteData.Failure error ->
            let
                err =
                    error |> Backend.Graphql.getErrorMessages
            in
            ( { model | errors = err, state = Idle }, clearErrorAfter 2000 err )

        RemoteData.Loading ->
            ( { model | state = Loading, errors = [] }, Cmd.none )

        RemoteData.NotAsked ->
            ( { model | state = Loading, errors = [] }, Cmd.none )


init : Session -> ( Model, Cmd Msg )
init session =
    ( { state = Idle
      , session = session
      , errors = []
      , form = { email = "", password = "" }
      }
    , Cmd.none
    )


makeRequest : Form -> Cmd Msg
makeRequest form =
    Backend.Graphql.makeMutationRequest Nothing (loginMutation form) GotLogin


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
