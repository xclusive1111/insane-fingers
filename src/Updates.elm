module Updates exposing (..)

import String exposing (startsWith)
import Types.Models exposing (Model, Msg(..), Word, initModel)
import Utils.Utils exposing (calcTypingAccuracy, calculateWPM, countCharacters)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp         ->
      (model, Cmd.none)
    OnTyping inputWord  ->
      if List.isEmpty model.remainWords then
        ({ model | currentWord = inputWord}, Cmd.none)
      else if (matchLastWord inputWord model.remainWords) || (matchEntireWord inputWord model.remainWords) then
        let
          typedWords = model.typedWords ++ [inputWord]
          remainWords = List.drop 1 model.remainWords
        in
          ({ model | correct = True
           , typedWords = typedWords
           , remainWords = remainWords
           , wpm = calculateWPM typedWords model.secondsPassed
           , currentWord = ""
           }, Cmd.none)

      else if matchStart inputWord model.remainWords then
        ({ model | correct = True
                 , pristine = False
                 , currentWord = inputWord}, Cmd.none)
      else
        ({ model | correct = False
                 , pristine = False
                 , failedIndices = (List.length model.typedWords) :: model.failedIndices
                 , currentWord = inputWord}, Cmd.none)
    OnSecondPassed _ ->
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

matchLastWord : Word -> List Word -> Bool
matchLastWord word remainWords =
  if List.length remainWords == 1 then
    List.foldr (\w b -> (w == word) && b) True remainWords
  else
    False

matchEntireWord : String -> List String -> Bool
matchEntireWord inputWord remainWords =
  List.head remainWords
    |> Maybe.map (\w -> inputWord == (w ++ " "))
    |> Maybe.withDefault True
