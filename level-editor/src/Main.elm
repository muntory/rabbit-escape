import Html exposing
    ( Html
    , div
    , img
    , pre
    , programWithFlags
    , table
    , text
    , tr
    , td
    )
import Html.Attributes exposing (class, height, id, src, style, width)
import Window


import Model exposing (Model, UiMode(..), UiState)
import Msg exposing (Msg(..))
import Rabbit exposing (Direction(..), Rabbit)
import Units exposing (..)
import Update exposing (update)
import View exposing (view)
import World exposing
    ( Block(..)
    , BlockMaterial(..)
    , BlockShape(..)
    , World
    , makeBlockGrid
    , makeWorld
    , rabbitsAt
    )
import WorldParser exposing (parse)
import WorldTextRender exposing (render)


type alias Flags =
    { width : Int
    , height : Int
    }


initWorld : World
initWorld =
    let
        p =
            WorldParser.parse
                "Example level"
                (  "######\n"
                ++ "#r   #\n"
                ++ "#  j #\n"
                ++ "######\n"
                )
    in
        case p of
            Ok w -> w
            Err s -> makeWorld "Unexpected Error" (makeBlockGrid []) []


initModel : Flags -> Model
initModel flags =
    { screen =
        { width = Pixels flags.width
        , height = Pixels flags.height
        }
    , world = initWorld
    , uiState =
        { mode = InitialMode
        , block = NoBlock
        }
    --, past = []
    --, future = []
    }


init : Flags -> (Model, Cmd Msg)
init flags =
    (initModel flags, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes(\size -> Resize size.width size.height)
        ]


main =
   programWithFlags
     { init = init
     , view = view
     , update = update
     , subscriptions = subscriptions
     }