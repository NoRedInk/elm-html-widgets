module TestRadioGroup where

import Html exposing (..)
import Widget.RadioGroup as RadioGroup exposing (RadioGroup)
import Signal
import StartApp.Simple as StartApp


type alias RadioGroupEntry =
    { id : Int
    , selected : Bool
    , caption : String
    }


main =
    StartApp.start { model = entries, view = view, update = update }


entries : List RadioGroupEntry
entries =
    [ { id = 0, caption = "Top Thing", selected = False }
    , { id = 1, caption = "Middle Thing", selected = True }
    , { id = 2, caption = "Bottom Thing", selected = False }
    ]


view address entries =
    let
        radioGroup =
            { viewLabel = .caption >> text
            , getId = .id >> toString
            , isSelected = .selected
            , setSelected = (\entry selected -> Signal.message address (Select entry))
            }
    in
        RadioGroup.view radioGroup entries


type Action
    = NoOp
    | Select RadioGroupEntry


update action entries =
    case action of
        NoOp ->
            entries

        Select entry ->
            List.map (selectIf (\{id} -> id == entry.id)) entries


selectIf : (RadioGroupEntry-> Bool) -> RadioGroupEntry -> RadioGroupEntry
selectIf predicate entry =
    { entry | selected <- predicate entry }
