module Hython.Frame
where

import Control.Monad.State

import Hython.InterpreterState
import Hython.Object

currentFrame :: Interpreter Frame
currentFrame = do
    currentFrames <- gets frames
    return $ head currentFrames

pushFrame :: String -> Env -> Interpreter ()
pushFrame context env = modify $ \s -> s { frames = newFrame : frames s }
  where
    newFrame = Frame context env

popFrame :: Interpreter ()
popFrame = do
    currentFrames <- gets frames
    case currentFrames of
        []      -> return ()
        (_:fs)  -> modify $ \s -> s { frames = fs }