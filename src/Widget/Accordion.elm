module Widget.Accordion (Accordion, view, originalView) where


import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (class, classList, attribute)
import Html.Events exposing (on)
import Signal exposing (Message)
import Json.Decode


{-| Functions which indicate how to display your `entry` type as an
accordion section.

`viewHeader` and `viewPanel` will be called with each `entry` to render
the title and body of a particular accordion section, respectively.
These functions will be passed a single `entry` and should render it
appropriately. In the simplest case, just use `Html.text` to render text only,
but you might also want to render (for example) an icon in the header or
structured paragraphs in the body.

`setExpanded` will be called to translate header clicks into `Message` values, so you can
update your model as appropriate. It receives a `Bool` indicating whether
the given `entry` is to become expanded, followed by the `entry` itself.

`getExpanded` will be called with an `entry` to determine whether it ought
to be displayed in expanded form.
-}
type alias Accordion entry =
    { viewHeader : entry -> Html
    , viewPanel : entry -> Html
    , setExpanded : Bool -> entry -> Message
    , getExpanded : entry -> Bool
    }


{-| Render an Accordion view.

An accordion is rendered as a list of sections, each with a header and body, and each
with a notion of whether it is expanded or collapsed. When the user clicks
a given header, the accordion sends a `Message` requesting that the section
in question swap its expandedness/collapsedness.

Provide a list of `entry` values, and an `Accordion` record that indicates
how we can display an `entry` as an accordion section.

Example Usage:

    type Action
        = NoOp
        | SetExpanded Int Bool

    -- You could keep track of `expanded` in a separate data structure, if that
    -- were desirable, by supplying an appropriate `setExpanded` and
    -- `getExpanded` for the `Accordion`, and an appropriate `update` method
    type alias Entry =
        { id : Int
        , title : String
        , synopsis : String
        , expanded : Bool
        }

    sampleEntry : Entry
    sampleEntry =
        { id = 1
        , title = "Walden"
        , synopsis = "A student is bitten by a radioactive spider..."
        , expanded = True
        }

    update : Action -> List Entry -> List Entry
    update action model =
        case action of
            NoOp ->
                model

            SetExpanded id expanded ->
                List.map (\entry ->
                    if entry.id == id
                        then { entry | expanded <- expanded }
                        else entry
                ) model

    accordion : Signal.Address Action -> Accordion Entry
    accordion address =
        { viewHeader = .title >> Html.text
        , viewPanel = .synopsis >> Html.text
        , setExpanded = \expanded {id} -> Signal.message address (SetExpanded id expanded)
        , getExpanded = .expanded
        }

    view : Signal.Address Action -> List Entry -> Html
    view address model =
        Accordion.view (accordion address) model
-}
view : Accordion entry -> List entry -> Html
view accordion entries =
    let
        viewEntry entry =
            let
                expanded =
                    accordion.getExpanded entry

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
                            (\_ -> accordion.setExpanded (not expanded) entry)
                        ]
                        [ accordion.viewHeader entry ]

                entryPanel =
                    div
                        [ class "accordion-entry-panel", role "tabpanel" ]
                        [ accordion.viewPanel entry ]
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


{-| An implementation of the original API, for easy transition to the new API.
-}
originalView :
    (entry -> Html) ->
    (entry -> Html) ->
    (Bool -> entry -> Message) ->
    List (entry, Bool) -> Html
originalView viewHeader viewPanel setExpanded list =
    let
        accordion =
            { viewHeader = viewHeader << fst
            , viewPanel = viewPanel << fst
            , setExpanded = \expanded entry -> setExpanded expanded (fst entry)
            , getExpanded = snd
            }

    in
        view accordion list
