module Main exposing (..)

import Commands
import Html exposing (Html)
import Time exposing (second)
import Types.Models exposing (Model, Msg(..), initModel)
import Updates exposing (update)
import Views exposing (view)

init : (Model, Cmd Msg)
init =
    ( initModel, Commands.fetchWords)


---- PROGRAM ----

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.typingStats.pristine then
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
