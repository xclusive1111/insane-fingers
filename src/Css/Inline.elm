module Css.Inline exposing (..)

import Types.Models exposing (Styles)

typingWord : Styles
typingWord =
    [("font-size", "1.8em"), ("line-height", "1.6em"), ("font-family", "Times New Roman, Times, serif")]

positiveWord : Styles
positiveWord = [("color", "green")] ++ roundCorner

negativeWord : Styles
negativeWord = [("background-color", "red")] ++ roundCorner

currentWord : Styles
currentWord = [("background-color", "#80808085")] ++ roundCorner

roundCorner : Styles
roundCorner =
  [("border-radius", "5px")]
