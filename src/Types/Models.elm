module Types.Models exposing (..)

import Time exposing (Time)
import Utils.Utils exposing (splitString)

type alias Word = String
type alias SecondsPassed = Int
type alias FailedIndex = Int
type alias WPM = Int

type alias Model =
    { correct : Bool
    , pristine : Bool
    , typedWords : List Word
    , remainWords : List Word
    , currentWord : Word
    , secondsPassed : SecondsPassed
    , wpm : WPM
    , failedIndices: List FailedIndex
    }

type Msg
    = NoOp
    | OnTyping Word
    | OnSecondPassed Time
    | Reset

type alias Styles = List (String, String)

initModel : Model
initModel =
    { correct = False
    , pristine = True
    , typedWords = []
    , remainWords = (splitString "\\s+" generateWords)
    , currentWord = ""
    , secondsPassed = 0
    , wpm = 0
    , failedIndices = []
    }

generateWords : String
generateWords =
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
