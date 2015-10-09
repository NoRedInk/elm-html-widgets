module Accordion (view) where


import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (class, classList, attribute)
import Html.Events exposing (on)
import Signal exposing (Message)
import Json.Decode


{-| Render an Accordion view.

Example Usage:

    type Action
        = NoOp
        | SetExpanded Int Bool


    sampleEntry =
        { id = 1
        , title = "Walden"
        , synopsis = "A student is bitten by a radioactive spider..."
        }


    Accordion.view
        (.title >> Html.text)
        (.synopsis >> Html.text)
        (\expanded {id} -> Signal.message actions (SetExpanded id expanded))
        [ ( sampleEntry, True ) ]
-}
view :
    (entry -> Html) ->
    (entry -> Html) ->
    (Bool -> entry -> Message) ->
    List (entry, Bool) -> Html
view viewHeader viewPanel toggleExpanded entries =
    let
        viewEntry (entry, expanded) =
            let
                entryClass =
                    classList
                        [ "accordion-entry" => True
                        , "accordion-entry-state-expanded" => expanded
                        , "accordion-entry-state-collapsed" => (not expanded)
                        ]

                entryHeader =
                    div
                        [ class "accordion-entry-header"
                        , on
                            "click"
                            (Json.Decode.succeed ())
                            (\_ -> toggleExpanded (not expanded) entry)
                        ]
                        [ viewHeader entry ]

                entryPanel =
                    div
                        [ class "accordion-entry-panel", role "tabpanel" ]
                        [ viewPanel entry ]
            in
                div
                    [ entryClass, role "tab" ]
                    [ entryHeader, entryPanel ]
    in
        div
            [ class "accordion"
            , role "tablist"
            , attribute "aria-live" "polite"
            ]
            (List.map viewEntry entries)


{- Convenience for making tuples. Looks nicer in conjunction with classList. -}
(=>) : a -> b -> (a, b)
(=>) =
    (,)


{- Convenience for defining role attributes, e.g. <div role="tabpanel"> -}
role : String -> Attribute
role =
    attribute "role"
