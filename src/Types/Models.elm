module Types.Models exposing (..)

import RemoteData exposing (WebData)
import Time exposing (Time)

type alias Word = String
type alias SecondsPassed = Int
type alias FailedIndex = Int
type alias WPM = Int

type alias TypingStats =
    { correct : Bool
    , pristine : Bool
    , typedWords : List Word
    , remainWords : List Word
    , currentWord : Word
    , secondsPassed : SecondsPassed
    , wpm : WPM
    , failedIndices: List FailedIndex
    }

type alias Model =
    { typingStats: TypingStats
    , wordList: WebData (List Word)
    }

type Msg
    = OnTyping Word
    | OnSecondPassed Time
    | OnFetchWords (WebData (List Word))
    | OnWordsGenerated (Maybe (List Word))
    | Reset

type alias Styles = List (String, String)

setTypingStats : TypingStats -> Model -> Model
setTypingStats stats model =
  { model | typingStats = stats }

setCorrect : Bool -> TypingStats -> TypingStats
setCorrect bool typingStats =
  { typingStats | correct = bool }

setTypedWords : List Word -> TypingStats -> TypingStats
setTypedWords wordList typingStats =
  { typingStats | typedWords = wordList }

setRemainWords : List Word -> TypingStats -> TypingStats
setRemainWords wordList typingStats =
  { typingStats | remainWords = wordList }

setWPM : WPM -> TypingStats -> TypingStats
setWPM wpm typingStats =
  { typingStats | wpm = wpm }

setCurrentWord : Word -> TypingStats -> TypingStats
setCurrentWord word typingStats =
  { typingStats | currentWord = word }

setPristine : Bool -> TypingStats -> TypingStats
setPristine bool typingStats =
  { typingStats | pristine = bool }

setFailedIndices : List FailedIndex -> TypingStats -> TypingStats
setFailedIndices failedIndexList typingStats =
  { typingStats | failedIndices = failedIndexList }

setSecondsPassed : SecondsPassed -> TypingStats -> TypingStats
setSecondsPassed seconds typingStats =
  { typingStats | secondsPassed = seconds}

asTypingStatsIn : Model -> TypingStats -> Model
asTypingStatsIn =
  flip setTypingStats

wordList : Model -> WebData (List Word)
wordList model =
    model.wordList

remainWords : Model -> List Word
remainWords model =
    model.typingStats.remainWords

typedWords : Model -> List Word
typedWords model =
    model.typingStats.typedWords

secondsPassed : Model -> SecondsPassed
secondsPassed model =
    model.typingStats.secondsPassed

initModel : Model
initModel =
    { typingStats =
        { correct = False
        , pristine = True
        , typedWords = []
        , remainWords = []
        , currentWord = ""
        , secondsPassed = 0
        , wpm = 0
        , failedIndices = []
        }
    , wordList = RemoteData.Loading
    }
