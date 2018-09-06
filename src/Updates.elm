module Updates exposing (update)

import Commands
import String exposing (startsWith)
import Types.Models exposing (..)
import Utils exposing (calcTypingAccuracy, calculateWPM, countCharacters)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OnFetchWords response ->
      ({model | wordList = response }, Commands.randomWords response)
    OnWordsGenerated maybeWords ->
      case maybeWords of
        Just words ->
          ({model | typingStats = model.typingStats |> setRemainWords words}, Cmd.none)
        Nothing    ->
          (model, Cmd.none)
    Reset ->
      (initModel, Commands.fetchWords)
    OnTyping inputWord  ->
      handleOnTyping inputWord model
    OnSecondPassed _ ->
      handleOnSecondPassed model

handleOnTyping : Word -> Model -> (Model, Cmd Msg)
handleOnTyping inputWord model =
  if List.isEmpty (remainWords model) then
    (model.typingStats
        |> setCurrentWord inputWord
        |> asTypingStatsIn model
        , Cmd.none)
  else if (matchLastWord inputWord (remainWords model)) then
    let
      newTypedWords = (typedWords model) ++ [inputWord]
    in
      (model.typingStats
        |> setCorrect True
        |> setTypedWords newTypedWords
        |> setRemainWords []
        |> setWPM (calculateWPM newTypedWords model.typingStats.secondsPassed)
        |> setCurrentWord ""
        |> setPristine True
        |> asTypingStatsIn model
        , Cmd.none)
  else if (matchEntireWord inputWord (remainWords model)) then
    let
      newTypedWords = (typedWords model) ++ [inputWord]
      newRemainWords = List.drop 1 (remainWords model)
    in
      (model.typingStats
        |> setCorrect True
        |> setTypedWords newTypedWords
        |> setRemainWords newRemainWords
        |> setWPM (calculateWPM newTypedWords model.typingStats.secondsPassed)
        |> setCurrentWord ""
        |> asTypingStatsIn model
        , Cmd.none)
  else if matchStart inputWord (remainWords model) then
     (model.typingStats
        |> setCorrect True
        |> setPristine False
        |> setCurrentWord inputWord
        |> asTypingStatsIn model
        , Cmd.none)
  else
     (model.typingStats
        |> setCorrect False
        |> setPristine False
        |> setFailedIndices ((List.length (typedWords model)) :: model.typingStats.failedIndices)
        |> setCurrentWord inputWord
        |> asTypingStatsIn model
        , Cmd.none)

handleOnSecondPassed : Model -> (Model, Cmd Msg)
handleOnSecondPassed model =
  let
    newSecondsPassed = (secondsPassed model) + 1
  in
    (model.typingStats
      |> setSecondsPassed newSecondsPassed
      |> setWPM (calculateWPM model.typingStats.typedWords newSecondsPassed)
      |> asTypingStatsIn model
      , Cmd.none)

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
