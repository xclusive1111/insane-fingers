module Main exposing (..)

import Html exposing (Html)
import Types.Models exposing (Model, Msg)
import Updates exposing (update)
import Utils.Utils exposing (splitString)
import Views exposing (view)


init : ( Model, Cmd Msg )
init = ( Model False True [] (splitString "\\s+" generateWords) "", Cmd.none )

generateWords : String
generateWords =
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
  

---- PROGRAM ----

main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
