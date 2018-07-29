module Views exposing (..)

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class)
import Pages.Home as Home
import Types.Models exposing (Model, Msg)

view : Model -> Html Msg
view model =
  div [ class "ui center aligned grid" ]
      [ div [ class "fourteen wide computer fifteen wide tablet sixteen wide mobile column" ]
          [ div [ class "ui stackable menu" ]
             [ a [ class "item" ] [ text "Item1" ]
             , a [ class "item" ] [ text "Item2" ]
             ]
          , div [ class "ui segment" ]
             [ Home.view model ]
          ]
      ]
