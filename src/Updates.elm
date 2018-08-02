module Updates exposing (..)

import String exposing (startsWith)
import Types.Models exposing (Model, Msg(..), initModel)
import Utils.Utils exposing (calculateWPM)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp         ->
      (model, Cmd.none)
    OnTyping inputWord  ->
      if List.isEmpty model.remainWords then
        ({ model | currentWord = inputWord}, Cmd.none)
      else if matchEntireWord inputWord model.remainWords then
        let
          typedWords = model.typedWords ++ [inputWord]
        in
          ({ model | correct = True
                   , typedWords = typedWords
                   , remainWords = (List.drop 1 model.remainWords)
                   , wpm = calculateWPM typedWords model.secondsPassed
                   , currentWord = ""}, Cmd.none)
      else if matchStart inputWord model.remainWords then
        ({ model | correct = True
                 , pristine = False
                 , currentWord = inputWord}, Cmd.none)
      else
        ({ model | correct = False
                 , pristine = False
                 , currentWord = inputWord}, Cmd.none)
    OneSecondPassed _ ->
      let
        seconds = model.secondsPassed + 1
        wpm = calculateWPM model.typedWords seconds
      in
        ({ model | secondsPassed = seconds, wpm = wpm}, Cmd.none)
    Reset ->
        (initModel, Cmd.none)

matchStart : String -> List String -> Bool
matchStart inputWord remainWords =
  List.take 1 remainWords
    |> List.foldl (\word b -> b && (startsWith inputWord word)) True

matchEntireWord : String -> List String -> Bool
matchEntireWord inputWord remainWords =
  List.take 1 remainWords
    |> List.foldl (\word b -> b && ((word ++ " ") == inputWord)) True
