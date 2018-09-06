module Utils exposing (..)

import Html
import Html.Attributes exposing (style)
import Regex
import String exposing (toFloat)
import Types.Models exposing (Styles)

splitString : String -> String -> List String
splitString reg str =
  Regex.fromString reg
  |> Maybe.map (\regex -> Regex.split regex str)
  |> Maybe.withDefault []

notBlank : String -> Bool
notBlank str =
  str /= "" && String.all (\c -> c /= ' ') str

calculatePercent : List String -> List String -> Int
calculatePercent typed remain =
  (Basics.toFloat (List.length typed)) / (Basics.toFloat (List.length (typed ++ remain)) )
    |> (*) 100
    |> round

calculateWPM : List String -> Int -> Int
calculateWPM wordsTyped secondsPassed =
  if secondsPassed == 0 then
    0
  else
    countCharacters wordsTyped
      |> (\characterCnt -> (Basics.toFloat characterCnt) / 5.0)
      |> (\wordCnt -> wordCnt / ((Basics.toFloat secondsPassed) /  60.0))
      |> round

countCharacters : List String -> Int
countCharacters xs =
  List.sum <| List.map String.length xs

calcTypingAccuracy : Int -> Int -> Float
calcTypingAccuracy a b =
  let
    accuracyStr = String.fromFloat <| (Basics.toFloat a) / (Basics.toFloat b) * 100
    finalAccuracy =
      case String.split(".") accuracyStr of
        [x, y] -> x ++ "." ++ (String.slice 0 1 y)
        [x]    -> x
        _      -> "0"
  in
    Maybe.withDefault 0.0 (String.toFloat finalAccuracy)

getStyles : Styles -> List (Html.Attribute msg)
getStyles =
  List.map (\(key, value) -> style key value)
