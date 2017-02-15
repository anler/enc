module Encoding.Base64(base64Encode) where

import           Data.ByteString.Base64
import           Data.ByteString.Char8

base64Encode :: String -> String
base64Encode = unpack . encode . pack
