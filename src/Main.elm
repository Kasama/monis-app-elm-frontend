module Main exposing (Msg(..), main)

import Backend.Authentication
import Browser
import Browser.Navigation as Nav
import Html
import Page
import Page.Home as HomePage
import Route exposing (Route)
import Session exposing (Session, StoredSession)
import Url exposing (Url)


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | HomeMsg HomePage.Msg


type alias Model =
    { page : PageModel
    }


type PageModel
    = Home HomePage.Model
    | Redirect Session
    | NotFound Session


sessionOf : Model -> Session
sessionOf model =
    case model.page of
        Redirect session ->
            session

        Home homeModel ->
            HomePage.sessionOf homeModel

        NotFound session ->
            session


updateSession : Model -> (Session -> Session) -> Model
updateSession model updater =
    case model.page of
        Redirect session ->
            { model | page = Redirect <| updater session }

        Home homeModel ->
            { model | page = Home <| HomePage.updateSession homeModel updater }

        NotFound session ->
            { model | page = NotFound <| updater session }


state : StoredSession -> Url -> Nav.Key -> ( Model, Cmd Msg )
state userSession url key =
    changeRoute (Route.fromUrl url)
        { page = Redirect (Session.fromStoredSession key userSession url)
        }


wrapWith : Model -> (a -> PageModel) -> (b -> Msg) -> ( a, Cmd b ) -> ( Model, Cmd Msg )
wrapWith premodel modelWrapper msgWrapper ( model, cmd ) =
    ( { premodel | page = modelWrapper model }, Cmd.map msgWrapper cmd )


changeRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRoute maybeRoute model =
    let
        session =
            sessionOf model
    in
    case maybeRoute of
        Just Route.Home ->
            HomePage.init session
                |> wrapWith model Home HomeMsg

        Just Route.Authorize ->
            let
                authInfo : Maybe Backend.Authentication.AuthInfo
                authInfo =
                    Backend.Authentication.parseCallbackUrl session.url
            in
            case Debug.log "authinfo" authInfo of
                Nothing ->
                    HomePage.init session
                        |> wrapWith model Home HomeMsg

                Just auth ->
                    let
                        newSession =
                            { session
                                | kind =
                                    Session.LoggedIn
                                        { email = ""
                                        , id = ""
                                        , isActive = True
                                        , name = ""
                                        , token = auth.id_token
                                        }
                            }
                    in
                    ( updateSession model (\_ -> newSession), Route.replaceUrl session.navKey Route.Home )

        Just Route.NotFound ->
            ( { model | page = NotFound session }, Cmd.none )

        Nothing ->
            ( { model | page = NotFound session }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ClickedLink request, _ ) ->
            case request of
                Browser.Internal url ->
                    ( model, Nav.pushUrl (.navKey (sessionOf model)) (Url.toString url) )

                Browser.External url ->
                    ( model, Nav.load url )

        ( ChangedUrl url, _ ) ->
            changeRoute (Route.fromUrl url) (updateSession model (\s -> { s | url = url }))

        ( HomeMsg homeMsg, Home homeModel ) ->
            HomePage.update homeMsg homeModel
                |> wrapWith model Home HomeMsg

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
    case model.page of
        Redirect _ ->
            { title = "nothing to see here. Redirecting..."
            , body = [ Html.text "" ]
            }

        Home home ->
            viewPage Page.Home HomeMsg (HomePage.view home)

        NotFound _ ->
            { title = "Page Not Found"
            , body = [ Html.text "Page Not Found" ]
            }


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        Home home ->
            HomePage.subscriptions home
                |> Sub.map HomeMsg

        Redirect _ ->
            Sub.none

        NotFound _ ->
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
