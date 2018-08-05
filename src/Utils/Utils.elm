module Utils.Utils exposing (..)

import Regex exposing (HowMany(All), Regex, regex)

splitString : String -> String -> List String
splitString reg str =
  Regex.split All (regex reg) str


notBlank : String -> Bool
notBlank str =
  str /= "" && String.all (\c -> c /= ' ') str

calculatePercent : List String -> List String -> Int
calculatePercent typed remain =
  (toFloat (List.length typed)) / (toFloat (List.length (typed ++ remain)) )
    |> (*) 100
    |> round

calculateWPM : List String -> Int -> Int
calculateWPM wordsTyped secondsPassed =
  if secondsPassed == 0 then
    0
  else
    countCharacters wordsTyped
      |> (\characterCnt -> (toFloat characterCnt) / 5.0)
      |> (\wordCnt -> wordCnt / ((toFloat secondsPassed) /  60.0))
      |> round

countCharacters : List String -> Int
countCharacters xs =
  List.sum <| List.map String.length xs

calcTypingAccuracy : Int -> Int -> Float
calcTypingAccuracy mistakes totalCharacters =
  let
    accuracyStr = toString <| 100 - ((toFloat mistakes) / (toFloat totalCharacters) * 100)
    num = case String.split(".") accuracyStr of
            [a, b] -> a ++ "." ++ (String.slice 0 1 b)
            [a]    -> a
            _      -> "0"
  in
    Result.withDefault 0.0 (String.toFloat num)
