module TestAccordion where

import Html exposing (..)
import Html.Attributes exposing (..)
import Accordion
import Signal


accordionOpts =
    { viewHeader = text
    , viewPanel = text
    , setExpanded = (\_ entry -> Signal.message dummyMailbox.address entry)
    , getExpanded = (\_ -> True)
    }


dummyMailbox : Signal.Mailbox String
dummyMailbox =
    Signal.mailbox ""


main =
    Accordion.view accordionOpts [ "foo" ]
        |> Signal.constant
