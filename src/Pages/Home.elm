module Pages.Home exposing (..)

import Css.Inline exposing (currentWord, negativeWord, positiveWord, typingWord)
import Html exposing (Html, a, button, div, h1, i, img, input, span, text)
import Html.Attributes exposing (class, id, src, style, type_, value)
import Html.Events exposing (onInput)
import Types.Models exposing (Model, Msg(..), Styles)

view : Model -> Html Msg
view model =
    div [ class "ui center aligned grid" ]
      [ div [ class "ten wide computer sixteen wide mobile left aligned column" ]
          [ div [ class "ui segment" ] [ typingProgress ]
          , div [ class "ui segment", style typingWord ] (getTypingWords model)
          ]
      , div [ class "eight wide computer sixteen wide mobile column" ]
          [ typingInput model.currentWord OnTyping
          ]
      ]

typingInput : String -> (String -> Msg) -> Html Msg
typingInput str f =
  div [ class "ui fluid huge input" ]
    [ input [ type_ "text", value str,  onInput f ] []
    , button [ class "ui teal icon button" ]
        [ i [ class "big refresh icon" ] [] ]
    ]

typingProgress : Html Msg
typingProgress =
  div [ class "ui grid" ]
    [ div [ class "two wide column"]
        [ a [ class "ui image label" ]
          [ img [ src "/images/u1.jpg" ] []
          , text "You"
          ]
        ]
    , div [ class "twelve wide column"]
        [ div [ class "ui progress success" ]
          [ div [ class "bar", style [("width", "86%")] ]
              [ div [ class "progress"] [ text "86%"] ]
          ]
        ]
    , div [ class "two wide column label" ] [ text "56 WPM" ]
  ]

wrapBySpan : Styles -> String -> Html Msg
wrapBySpan styles word =
    span [ style styles ] [ text word ]

wordStyles : Styles -> List String -> List (Html Msg)
wordStyles styles wordList =
  List.map (wrapBySpan styles) wordList

currentWordStyle : Model -> Styles
currentWordStyle model =
  if model.pristine || model.correct then
    currentWord
  else
    negativeWord

getTypingWords : Model -> List (Html Msg)
getTypingWords model =
  (wordStyles positiveWord model.typedWords)
    ++ (wordStyles (currentWordStyle model)  (List.take 1 model.remainWords))
    ++ (wordStyles [] (List.drop 1 model.remainWords))
    |> List.intersperse (span [] [ text " "])
