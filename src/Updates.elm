module Updates exposing (..)

import String exposing (startsWith)
import Types.Models exposing (Model, Msg(..))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp         ->
      (model, Cmd.none)
    OnTyping inputWord  ->
      if List.isEmpty model.remainWords then
        ({ model | currentWord = inputWord}, Cmd.none)
      else if matchEntireWord inputWord model.remainWords then
        (Model True False (model.typedWords ++ [inputWord]) (List.drop 1 model.remainWords) "", Cmd.none)
      else if matchStart inputWord model.remainWords then
        (Model True False model.typedWords model.remainWords inputWord, Cmd.none)
      else
        (Model False False model.typedWords model.remainWords inputWord, Cmd.none)

matchStart : String -> List String -> Bool
matchStart inputWord remainWords =
  List.take 1 remainWords
    |> List.foldl (\word b -> b && (startsWith inputWord word)) True

matchEntireWord : String -> List String -> Bool
matchEntireWord inputWord remainWords =
  List.take 1 remainWords
    |> List.foldl (\word b -> b && ((word ++ " ") == inputWord)) True
