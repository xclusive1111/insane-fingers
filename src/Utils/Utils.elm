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
    let
      characters = List.map String.length wordsTyped |> List.sum
      words = (toFloat characters) / 5.0
    in
      round (words / ((toFloat secondsPassed) /  60.0))
