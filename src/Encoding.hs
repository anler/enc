{-# LANGUAGE ScopedTypeVariables #-}
module Encoding( urlEncoder
               , base64Encoder
               , Encoder
               , Encode
               ) where

import           Control.Exception          (IOException, catch)
import           Control.Monad              (forever)
import           Control.Monad.IO.Class     (liftIO)
import           Control.Monad.Trans.Reader
import           Data.Bool                  (bool)
import           Data.List                  (intercalate)
import           Encoding.Base64
import           Encoding.Url
import           System.Posix               (fileExist)

type Encoder = String -> String
type Encode = ReaderT Encoder IO

urlEncoder :: [String] -> IO ()
urlEncoder = runEncode urlEncode

base64Encoder :: [String] -> IO ()
base64Encoder = runEncode base64Encode

runEncode :: Encoder -> [String] -> IO ()
runEncode encoder input = do
  runReaderT (encode input) encoder `catch` \(_ :: IOException) -> return ()

encode :: [String] -> Encode ()
encode options =
  case options of
    []    -> encodeStdin
    [arg] -> encodeFileOrWord arg
    args  -> encodeWords args

encodeStdin :: Encode ()
encodeStdin =
  forever $ liftIO getLine >>= putEncoded

encodeFileOrWord :: String -> Encode ()
encodeFileOrWord arg =
  liftIO (fileExist arg) >>= (putEncoded =<<) . bool (return arg) (liftIO (readFile arg))

encodeWords :: [String] -> Encode ()
encodeWords = putEncoded . intercalate " "

putEncoded :: String -> Encode ()
putEncoded input = do
  encoder <- ask
  liftIO $ putStrLn (encoder input)
