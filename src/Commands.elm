module Commands exposing (..)

import Http
import Json.Decode exposing (index, list, string)
import Random
import RemoteData exposing (RemoteData, WebData)
import Types.Models exposing (Msg(..), Word)
import Utils.Utils exposing (splitString)

fetchWords : Cmd Msg
fetchWords =
  Http.get fetchWordsURL (list string)
    |> RemoteData.sendRequest
    |> Cmd.map OnFetchWords

fetchWordsURL : String
fetchWordsURL =
    "http://localhost:3000/quotes.txt"

randomWords : WebData (List Word) -> Cmd Msg
randomWords data =
  case RemoteData.toMaybe data of
    Just words   ->
      let
        getWords index list =
          List.drop (index - 1) list
            |> List.head
            |> Maybe.map (splitString "\\s+")
      in
        Random.generate (\i -> getWords i words) (Random.int 1 (List.length words))
          |> Cmd.map OnWordsGenerated
    Nothing      ->
      Cmd.none
