module Types.Models exposing (..)

type alias Model =
    { correct : Bool
    , pristine : Bool
    , typedWords : List String
    , remainWords : List String
    , currentWord : String
    }

type Msg
    = NoOp
    | OnTyping String

type alias Styles = List (String, String)
