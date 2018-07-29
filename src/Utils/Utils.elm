module Utils.Utils exposing (..)

import Regex exposing (HowMany(All), Regex, regex)

splitString : String -> String -> List String
splitString reg str =
  Regex.split All (regex reg) str


notBlank : String -> Bool
notBlank str =
  str /= "" && String.all (\c -> c /= ' ') str
