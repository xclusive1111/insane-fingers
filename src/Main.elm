module Main exposing (..)

import Browser
import Commands
import Html exposing (Html)
import Time
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
    Time.every 1000 OnSecondPassed

main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
