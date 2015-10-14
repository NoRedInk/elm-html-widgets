module TestAccordion where

import Html exposing (..)
import Html.Attributes exposing (..)
import Widget.Accordion as (Accordion)
import Signal
import StartApp.Simple as StartApp


type alias AccordionEntry =
    { id : Int
    , expanded : Bool
    , heading : String
    , body : String
    }


main =
    StartApp.start { model = entries, view = view, update = update }


entries : List AccordionEntry
entries =
    [ { id = 0, heading = "Top Thing", body = "Top Content", expanded = False }
    , { id = 1, heading = "Middle Thing", body = "Middle Content", expanded = True }
    , { id = 2, heading = "Bottom Thing", body = "Bottom Content", expanded = False }
    ]


view address entries =
    let
        accordionOpts =
            { viewHeader = .heading >> text
            , viewPanel = .body >> text
            , setExpanded = (\expanded entry -> Signal.message address (Expand entry))
            , getExpanded = .expanded
            }
    in
        Accordion.view accordionOpts entries


type Action
    = NoOp
    | Expand AccordionEntry


update action entries =
    case action of
        NoOp ->
            entries

        Expand entry ->
            List.map (expandIf (\{id} -> id == entry.id)) entries


expandIf : (AccordionEntry -> Bool) -> AccordionEntry -> AccordionEntry
expandIf predicate entry =
    { entry | expanded <- predicate entry }
