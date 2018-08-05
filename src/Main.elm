module Main exposing (..)

import Html exposing (Html)
import Time exposing (second)
import Types.Models exposing (Model, Msg(..), initModel)
import Updates exposing (update)
import Views exposing (view)

init : (Model, Cmd Msg)
init =
    ( initModel, Cmd.none )


---- PROGRAM ----

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.pristine || List.isEmpty model.remainWords then
    Sub.none
  else
    Time.every second OnSecondPassed

main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
