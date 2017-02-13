{-# LANGUAGE QuasiQuotes         #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import           Control.Exception     (IOException, catch)
import           Control.Monad         (when)
import           Data.Bool             (bool)
import           Data.List             (intercalate)
import           Encoding.Url          (urlEncode)
import           System.Console.Docopt
import           System.Environment    (getArgs)
import           System.Posix          (fileExist)

main :: IO ()
main = do
  args <- parseArgsOrExit patterns =<< getArgs
  when
    (args `isPresent` (command "url"))
    ((args `getAllArgs` argument "input") |> handleUrl)

(|>) = flip ($)

patterns :: Docopt
patterns = [docoptFile|USAGE.txt|]

getArgOrExit = getArgOrExitWith patterns

handleUrl :: [String] -> IO ()
handleUrl options  =
  case options of
    []    -> handleUrlStdin
    [arg] -> handleUrlFileOrWord arg
    args  -> handleUrlWords args

handleUrlStdin :: IO ()
handleUrlStdin =
  (getLine >>= putUrlEncoded >> handleUrlStdin) `catch` \(_ :: IOException) -> return ()

handleUrlFileOrWord :: String -> IO ()
handleUrlFileOrWord arg =
  fileExist arg >>= (putUrlEncoded =<<) . bool (return arg) (readFile arg)

handleUrlWords :: [String] -> IO ()
handleUrlWords = putUrlEncoded . intercalate " "

putUrlEncoded :: String -> IO ()
putUrlEncoded = putStrLn . urlEncode
