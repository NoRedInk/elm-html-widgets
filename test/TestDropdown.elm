module TestDropdown where

import Html exposing (..)
import Html.Attributes exposing (..)
import Widget.Dropdown as Dropdown
import Signal


dropdownOpts =
    { viewEntry = text
    , viewSelected = text
    , setSelected = (\entry -> Signal.message dummyMailbox.address entry)
    , setExpanded = (\isExpanded -> Signal.message dummyMailbox.address "")
    }

dummyMailbox : Signal.Mailbox String
dummyMailbox =
    Signal.mailbox ""


main =
    Dropdown.view dropdownOpts True "foo" [ "foo" ]
        |> Signal.constant
