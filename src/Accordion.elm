module Accordion (view) where


import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (class, classList, attribute)
import Html.Events exposing (on)
import Signal exposing (Message)
import Json.Decode


{-| Render an Accordion view.

An accordion is a list of sections, each with a header and body, and each
with a notion of whether it is expanded or collapsed. When the user clicks
a given header, the accordion sends a `Message` requesting that the section
in question swap its expandedness/collapsedness.

Start with a list of `entry` values, each paired with a `Bool` indicating
whether that entry should be expanded.

The first two arguments to `view` are functions which render the title and
the body of a particular accordion section, respectively. These functions will
be passed a single `entry` and should render it appropriately. In the simplest
case, just use `Html.text` to render text only, but you might also want to
render (for example) an icon in the header or structured paragraphs in the body.

The third argument translates header clicks into `Message` values, so you can
update your model as appropriate. It receives a `Bool` indicating whether
the given `entry` is to become expanded, followed by the `entry` itself.

The final argument is the list of entries, each wrapped in a Tuple with a `Bool`
indicating whether it should be expanded.

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
