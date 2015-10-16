module Widget.RadioGroup (view, RadioGroup) where

import Html exposing (div, span, input, label, text, Attribute, Html)
import Html.Attributes exposing (type', class, for, attribute, property, id, checked)
import Html.Events exposing (on, targetChecked)
import Json.Encode as Encode
import Util exposing ((=>), role)


type alias RadioGroup entry =
    { viewLabel : entry -> Html
    , getId : entry -> String
    , isSelected : entry -> Bool
    , setSelected : entry -> Bool -> Signal.Message
    }

{-
    Creates a div containing radio buttons.

    Provide a radio group record with methods operating on entries, and
    a list of entries, for which radio buttons will be made.
-}
view : RadioGroup entry -> List entry -> Html
view radioGroup radioButtonList =
    let
        buildRadioButton entry =
            let
                isChecked =
                    radioGroup.isSelected entry

                buttonId =
                    radioGroup.getId entry
            in
                span
                    [ class "radio" ]
                    [ input
                        [ type' "radio"
                        , id buttonId
                        , checked isChecked
                        , on "change" targetChecked (radioGroup.setSelected entry)
                        ]
                        []
                    , label
                        [ for buttonId, role "radio", property "aria-checked" (Encode.bool isChecked) ]
                        [ radioGroup.viewLabel entry ]
                    ]

    in
        radioButtonList
            |> List.map buildRadioButton
            |> div [ class "radio-button-group" ]
