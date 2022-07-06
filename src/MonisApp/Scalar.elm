-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.Scalar exposing (Codecs, Timestamptz(..), Uuid(..), defaultCodecs, defineCodecs, unwrapCodecs, unwrapEncoder)

import Graphql.Codec exposing (Codec)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode


type Timestamptz
    = Timestamptz String


type Uuid
    = Uuid String


defineCodecs :
    { codecTimestamptz : Codec valueTimestamptz
    , codecUuid : Codec valueUuid
    }
    -> Codecs valueTimestamptz valueUuid
defineCodecs definitions =
    Codecs definitions


unwrapCodecs :
    Codecs valueTimestamptz valueUuid
    ->
        { codecTimestamptz : Codec valueTimestamptz
        , codecUuid : Codec valueUuid
        }
unwrapCodecs (Codecs unwrappedCodecs) =
    unwrappedCodecs


unwrapEncoder :
    (RawCodecs valueTimestamptz valueUuid -> Codec getterValue)
    -> Codecs valueTimestamptz valueUuid
    -> getterValue
    -> Graphql.Internal.Encode.Value
unwrapEncoder getter (Codecs unwrappedCodecs) =
    (unwrappedCodecs |> getter |> .encoder) >> Graphql.Internal.Encode.fromJson


type Codecs valueTimestamptz valueUuid
    = Codecs (RawCodecs valueTimestamptz valueUuid)


type alias RawCodecs valueTimestamptz valueUuid =
    { codecTimestamptz : Codec valueTimestamptz
    , codecUuid : Codec valueUuid
    }


defaultCodecs : RawCodecs Timestamptz Uuid
defaultCodecs =
    { codecTimestamptz =
        { encoder = \(Timestamptz raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map Timestamptz
        }
    , codecUuid =
        { encoder = \(Uuid raw) -> Encode.string raw
        , decoder = Object.scalarDecoder |> Decode.map Uuid
        }
    }
