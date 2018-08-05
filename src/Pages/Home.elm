module Pages.Home exposing (..)

import Css.Inline exposing (currentWord, negativeWord, positiveWord, typingWord)
import Html exposing (Html, a, button, div, h1, i, img, input, p, span, text)
import Html.Attributes exposing (class, id, src, style, type_, value)
import Html.Events exposing (onClick, onInput)
import RemoteData
import Set
import Types.Models exposing (Model, Msg(..), Styles, TypingStats)
import Utils.Utils exposing (calcTypingAccuracy, calculatePercent, calculateWPM, countCharacters)

view : Model -> Html Msg
view model =
    div [ class "ui center aligned grid" ] (render model)


render : Model -> List (Html Msg)
render model =
  case model.wordList of
    RemoteData.NotAsked      ->
      [ div [ class "twelve wide computer sixteen wide mobile column" ]
          [ div [ class "ui segment" ]
              [ div [ class "ui warning message" ]
                  [ i [ class "close icon"] []
                  , div [ class "header" ] [ text "I'm panic!" ]
                  , p [] [ text "What am I suppose to do???"]
                  ]
              ]
          ]
      ]
    RemoteData.Loading       ->
      [ div [ class "twelve wide computer sixteen wide mobile column" ]
          [ div [ class "ui icon message" ]
              [ i [ class "notched circle loading icon" ] []
              , div [ class "content" ]
                  [ div [ class "header" ] [ text "We're fetching word list for you." ]
                  , p [] []
                  ]
              ]
          ]
      ]
    RemoteData.Success words ->
      [ div [ class "twelve wide computer sixteen wide mobile left aligned column" ]
          [ div [ class "ui segment" ] [ typingProgress model.typingStats ]
          , div [ class "ui segment", style typingWord ] (getTypingWords model.typingStats)
          ]
      , div [ class "eight wide computer sixteen wide mobile column" ]
          [ typingSection model.typingStats
          ]
      ]
    RemoteData.Failure err   ->
      [ div [ class "twelve wide computer sixteen wide mobile column" ]
          [ div [ class "ui segment" ]
              [ div [ class "ui negative message" ]
                  [ i [ class "close icon"] []
                  , div [ class "header" ] [ text "We're sorry we cant't fetch word list for you." ]
                  , p [] [ text (toString err) ]
                  ]
              ]
          ]
      ]

typingSection : TypingStats -> Html Msg
typingSection stats =
    if List.isEmpty stats.remainWords then
      statsSection stats
    else
      typingInput stats.currentWord OnTyping

statsSection : TypingStats -> Html Msg
statsSection stats =
  let
      wpm = toString stats.wpm
      mistakeCnt = (Set.fromList stats.failedIndices) |> Set.size
      totalTypedEntries = mistakeCnt + (List.length stats.typedWords)
      acc = toString <| calcTypingAccuracy mistakeCnt totalTypedEntries
  in
    div [ class "" ]
      [ p [] [ text ("Your speed: " ++ wpm ++ "WPM")]
      , p [] [ text ("Accuracy: " ++ acc ++ "%" )]
      , p [] [ text ("Time: " ++ (toString stats.secondsPassed) ++ " s")]
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

typingProgress : TypingStats -> Html Msg
typingProgress stats =
  let
    percent =
      if List.isEmpty stats.remainWords then
        100
      else
        calculatePercent stats.typedWords stats.remainWords
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
      , div [ class "two wide column label" ] [ text ((toString stats.wpm) ++ " WPM") ]
    ]

wrapBySpan : Styles -> String -> Html Msg
wrapBySpan styles word =
    span [ style styles ] [ text word ]

wordStyles : Styles -> List String -> List (Html Msg)
wordStyles styles wordList =
  List.map (wrapBySpan styles) wordList

currentWordStyle : TypingStats -> Styles
currentWordStyle stats =
  if stats.pristine || stats.correct then
    currentWord
  else
    negativeWord

getTypingWords : TypingStats -> List (Html Msg)
getTypingWords stats =
  (wordStyles positiveWord stats.typedWords)
    ++ (wordStyles (currentWordStyle stats) (List.take 1 stats.remainWords))
    ++ (wordStyles [] (List.drop 1 stats.remainWords))
    |> List.intersperse (span [] [ text " "])
