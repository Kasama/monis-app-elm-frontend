-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module MonisApp.InputObject exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import MonisApp.Enum.AccountType
import MonisApp.Interface
import MonisApp.Object
import MonisApp.Scalar
import MonisApp.ScalarCodecs
import MonisApp.Union


buildCreateAccountInput :
    CreateAccountInputRequiredFields
    -> (CreateAccountInputOptionalFields -> CreateAccountInputOptionalFields)
    -> CreateAccountInput
buildCreateAccountInput required fillOptionals =
    let
        optionals =
            fillOptionals
                { amount = Absent, currency = Absent, icon = Absent }
    in
    { amount = optionals.amount, currency = optionals.currency, icon = optionals.icon, name = required.name, type_ = required.type_ }


type alias CreateAccountInputRequiredFields =
    { name : String
    , type_ : MonisApp.Enum.AccountType.AccountType
    }


type alias CreateAccountInputOptionalFields =
    { amount : OptionalArgument String
    , currency : OptionalArgument String
    , icon : OptionalArgument String
    }


{-| Type for the CreateAccountInput input object.
-}
type alias CreateAccountInput =
    { amount : OptionalArgument String
    , currency : OptionalArgument String
    , icon : OptionalArgument String
    , name : String
    , type_ : MonisApp.Enum.AccountType.AccountType
    }


{-| Encode a CreateAccountInput into a value that can be used as an argument.
-}
encodeCreateAccountInput : CreateAccountInput -> Value
encodeCreateAccountInput input =
    Encode.maybeObject
        [ ( "amount", Encode.string |> Encode.optional input.amount ), ( "currency", Encode.string |> Encode.optional input.currency ), ( "icon", Encode.string |> Encode.optional input.icon ), ( "name", Encode.string input.name |> Just ), ( "type", Encode.enum MonisApp.Enum.AccountType.toString input.type_ |> Just ) ]


buildCreateTransactionInput :
    CreateTransactionInputRequiredFields
    -> (CreateTransactionInputOptionalFields -> CreateTransactionInputOptionalFields)
    -> CreateTransactionInput
buildCreateTransactionInput required fillOptionals =
    let
        optionals =
            fillOptionals
                { comment = Absent }
    in
    { accountId = required.accountId, categoryId = required.categoryId, comment = optionals.comment, payee = required.payee, transactionDate = required.transactionDate, value = required.value }


type alias CreateTransactionInputRequiredFields =
    { accountId : MonisApp.ScalarCodecs.Id
    , categoryId : MonisApp.ScalarCodecs.Id
    , payee : String
    , transactionDate : String
    , value : String
    }


type alias CreateTransactionInputOptionalFields =
    { comment : OptionalArgument String }


{-| Type for the CreateTransactionInput input object.
-}
type alias CreateTransactionInput =
    { accountId : MonisApp.ScalarCodecs.Id
    , categoryId : MonisApp.ScalarCodecs.Id
    , comment : OptionalArgument String
    , payee : String
    , transactionDate : String
    , value : String
    }


{-| Encode a CreateTransactionInput into a value that can be used as an argument.
-}
encodeCreateTransactionInput : CreateTransactionInput -> Value
encodeCreateTransactionInput input =
    Encode.maybeObject
        [ ( "accountId", (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapEncoder .codecId) input.accountId |> Just ), ( "categoryId", (MonisApp.ScalarCodecs.codecs |> MonisApp.Scalar.unwrapEncoder .codecId) input.categoryId |> Just ), ( "comment", Encode.string |> Encode.optional input.comment ), ( "payee", Encode.string input.payee |> Just ), ( "transactionDate", Encode.string input.transactionDate |> Just ), ( "value", Encode.string input.value |> Just ) ]


buildDeleteAccountInput :
    DeleteAccountInputRequiredFields
    -> DeleteAccountInput
buildDeleteAccountInput required =
    { id = required.id }


type alias DeleteAccountInputRequiredFields =
    { id : String }


{-| Type for the DeleteAccountInput input object.
-}
type alias DeleteAccountInput =
    { id : String }


{-| Encode a DeleteAccountInput into a value that can be used as an argument.
-}
encodeDeleteAccountInput : DeleteAccountInput -> Value
encodeDeleteAccountInput input =
    Encode.maybeObject
        [ ( "id", Encode.string input.id |> Just ) ]


buildRegisterInput :
    RegisterInputRequiredFields
    -> RegisterInput
buildRegisterInput required =
    { email = required.email, name = required.name, password = required.password, passwordConfirm = required.passwordConfirm }


type alias RegisterInputRequiredFields =
    { email : String
    , name : String
    , password : String
    , passwordConfirm : String
    }


{-| Type for the RegisterInput input object.
-}
type alias RegisterInput =
    { email : String
    , name : String
    , password : String
    , passwordConfirm : String
    }


{-| Encode a RegisterInput into a value that can be used as an argument.
-}
encodeRegisterInput : RegisterInput -> Value
encodeRegisterInput input =
    Encode.maybeObject
        [ ( "email", Encode.string input.email |> Just ), ( "name", Encode.string input.name |> Just ), ( "password", Encode.string input.password |> Just ), ( "passwordConfirm", Encode.string input.passwordConfirm |> Just ) ]