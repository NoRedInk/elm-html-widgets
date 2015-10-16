module Util ((=>), role) where

import Html exposing (Attribute)
import Html.Attributes exposing (attribute)

{- Convenience for making tuples. Looks nicer in conjunction with classList. -}
(=>) : a -> b -> (a, b)
(=>) =
    (,)


{- Convenience for defining role attributes, e.g. <div role="tabpanel"> -}
role : String -> Attribute
role =
    attribute "role"
