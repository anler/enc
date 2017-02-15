{-# LANGUAGE QuasiQuotes #-}
module Main where

import           Control.Monad         (when)
import           Encoding
import           System.Console.Docopt
import           System.Environment    (getArgs)

main :: IO ()
main = do
  args <- parseArgsOrExit patterns =<< getArgs
  let handleWith = ($ (args `getAllArgs` argument "input"))
  when
    (args `isPresent` (command "url"))
    (handleWith urlEncoder)

  when
    (args `isPresent` (command "base64"))
    (handleWith base64Encoder)

patterns :: Docopt
patterns = [docoptFile|USAGE.txt|]

getArgOrExit = getArgOrExitWith patterns
