module Utils exposing (..)

import Html
import Html.Attributes exposing (style)
import Http exposing (Body, Error(..), Response)
import Json.Decode as Decode exposing (Decoder, decodeString, field)
import String exposing (toFloat)
import Types.Models exposing (Styles)

getWords : String -> List String
getWords = String.words

decodeErrors : Http.Error -> List String
decodeErrors error =
    case error of
        Http.BadStatus response ->
            response.body
                |> decodeString (field "errors" errorsDecoder)
                |> Result.withDefault [ "Server error" ]

        err ->
            [ "Server error" ]


errorsDecoder : Decoder (List String)
errorsDecoder =
    Decode.keyValuePairs (Decode.list Decode.string)
        |> Decode.map (List.concatMap fromPair)

fromPair : ( String, List String ) -> List String
fromPair ( field, errors ) =
    List.map (\error -> field ++ " " ++ error) errors


getHttpResponseBody : Response Body -> Body
getHttpResponseBody bodyResponse =
    case bodyResponse of
      {url, status, headers, body} -> body

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
