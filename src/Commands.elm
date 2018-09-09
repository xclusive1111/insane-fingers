module Commands exposing (..)

import Http
import Json.Decode exposing (index, list, string)
import Random exposing (generate, int)
import RemoteData exposing (RemoteData, WebData)
import Types.Models exposing (Msg(..), Word)
import Utils exposing (getWords)

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
        getWordsAtIdx list index =
          List.drop (index - 1) list
            |> List.head
            |> Maybe.map getWords
      in
        generate (getWordsAtIdx words) (int 1 (List.length words))
          |> Cmd.map OnWordsGenerated
    Nothing      ->
      Cmd.none
