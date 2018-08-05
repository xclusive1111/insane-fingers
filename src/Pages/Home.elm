module Pages.Home exposing (..)

import Css.Inline exposing (currentWord, negativeWord, positiveWord, typingWord)
import Html exposing (Html, a, button, div, h1, i, img, input, p, span, text)
import Html.Attributes exposing (class, id, src, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Set
import Types.Models exposing (Model, Msg(..), Styles)
import Utils.Utils exposing (calcTypingAccuracy, calculatePercent, calculateWPM, countCharacters)

view : Model -> Html Msg
view model =
    div [ class "ui center aligned grid" ]
      [ div [ class "twelve wide computer sixteen wide mobile left aligned column" ]
          [ div [ class "ui segment" ] [ typingProgress model ]
          , div [ class "ui segment", style typingWord ] (getTypingWords model)
          ]
      , div [ class "eight wide computer sixteen wide mobile column" ]
          [ typingSection model
          ]
      ]

typingSection : Model -> Html Msg
typingSection model =
    if List.isEmpty model.remainWords then
      statsSection model
    else
      typingInput model.currentWord OnTyping

statsSection : Model -> Html Msg
statsSection model =
  let
      wpm = toString model.wpm
      acc = toString <| calcTypingAccuracy (Set.fromList model.failedIndices |> Set.size) (List.length model.typedWords)
  in
    div [ class "" ]
      [ p [] [ text ("Your speed: " ++ wpm ++ "WPM")]
      , p [] [ text ("Accuracy: " ++ acc ++ "%" )]
      , p [] [ text ("Time: " ++ (toString model.secondsPassed) ++ " s")]
      , button [ class "ui icon button", onClick Reset ]
          [ i [ class "big refresh icon" ] [] ]
      ]

typingInput : String -> (String -> Msg) -> Html Msg
typingInput str f =
  div [ class "ui fluid huge input" ]
    [ input [ type_ "text", value str,  onInput f ] []
    , button [ class "ui icon button", onClick Reset ]
        [ i [ class "big refresh icon" ] [] ]
    ]

typingProgress : Model -> Html Msg
typingProgress model =
  let
    percent =
      if List.isEmpty model.remainWords then
        100
      else
        calculatePercent model.typedWords model.remainWords
  in
    div [ class "ui grid" ]
      [ div [ class "two wide column"]
          [ a [ class "ui image label" ]
            [ img [ src "/images/u1.jpg" ] []
            , text "You"
            ]
          ]
      , div [ class "twelve wide column"]
          [ div [ class "ui progress success" ]
            [ div [ class "bar", style [("width", (toString percent) ++ "%")] ]
                [ div [ class "progress"] [ text ((toString percent) ++ "%")] ]
            ]
          ]
      , div [ class "two wide column label" ] [ text ((toString model.wpm) ++ " WPM") ]
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
