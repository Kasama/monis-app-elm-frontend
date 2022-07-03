module Main exposing (Msg(..), main)

import Browser
import Browser.Navigation as Nav
import Html
import Page
import Page.Home as HomePage
import Page.Login as LoginPage
import Route exposing (Route)
import Session exposing (Session, StoredSession)
import Url exposing (Url)


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | HomeMsg HomePage.Msg
    | LoginMsg LoginPage.Msg


type Model
    = Home HomePage.Model
    | Login LoginPage.Model
    | Redirect Session


sessionOf : Model -> Session
sessionOf model =
    case model of
        Redirect session ->
            session

        Home homeModel ->
            HomePage.sessionOf homeModel

        Login loginModel ->
            LoginPage.sessionOf loginModel


state : StoredSession -> Url -> Nav.Key -> ( Model, Cmd Msg )
state userSession url key =
    changeRoute (Route.fromUrl url)
        (Redirect (Session.fromStoredSession key userSession))


wrapWith : (a -> Model) -> (b -> Msg) -> ( a, Cmd b ) -> ( Model, Cmd Msg )
wrapWith modelWrapper msgWrapper ( model, cmd ) =
    ( modelWrapper model, Cmd.map msgWrapper cmd )


changeRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRoute maybeRoute model =
    let
        session =
            sessionOf model
    in
    case maybeRoute of
        Nothing ->
            LoginPage.init session
                |> wrapWith Login LoginMsg

        Just Route.Home ->
            HomePage.init session
                |> wrapWith Home HomeMsg

        Just Route.Login ->
            LoginPage.init session
                |> wrapWith Login LoginMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ClickedLink request, _ ) ->
            case request of
                Browser.Internal url ->
                    ( model, Nav.pushUrl (.navKey (sessionOf model)) (Url.toString url) )

                Browser.External url ->
                    ( model, Nav.load url )

        ( ChangedUrl url, _ ) ->
            changeRoute (Route.fromUrl url) model

        ( LoginMsg loginMsg, Login loginModel ) ->
            LoginPage.update loginMsg loginModel
                |> wrapWith Login LoginMsg

        ( HomeMsg homeMsg, Home homeModel ) ->
            HomePage.update homeMsg homeModel
                |> wrapWith Home HomeMsg

        ( _, _ ) ->
            ( model, Cmd.none )


viewPage : Page.Page -> (msg -> Msg) -> Page.Root msg -> Browser.Document Msg
viewPage page msgWrapper model =
    let
        { title, body } =
            Page.view page model
    in
    { title = title
    , body = List.map (Html.map msgWrapper) body
    }


view : Model -> Browser.Document Msg
view model =
    case model of
        Redirect _ ->
            { title = "nothing to see here. Redirecting..."
            , body = [ Html.text "" ]
            }

        Home home ->
            viewPage Page.Home HomeMsg (HomePage.view home)

        Login login ->
            viewPage Page.Login LoginMsg (LoginPage.view login)


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Home home ->
            HomePage.subscriptions home
                |> Sub.map HomeMsg

        Login login ->
            LoginPage.subscriptions login
                |> Sub.map LoginMsg

        Redirect _ ->
            Sub.none


main : Program StoredSession Model Msg
main =
    Browser.application
        { init = state
        , update = update
        , view = view
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        }
