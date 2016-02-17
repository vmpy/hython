module Hython.AttributeDict
where

import Control.Monad.IO.Class (MonadIO)
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as HashMap
import Data.Text (Text)

import Hython.Ref

type AttributeDict obj = HashMap Text (Ref obj)

lookup :: (MonadIO m) => Text -> AttributeDict obj -> m (Maybe obj)
lookup attr dict = case HashMap.lookup attr dict of
                       Just ref -> Just <$> readRef ref
                       Nothing  -> return Nothing

fromList :: [(Text, Ref obj)] -> AttributeDict obj
fromList = HashMap.fromList

new :: AttributeDict obj
new = HashMap.empty

set :: (MonadIO m) => Text -> obj -> AttributeDict obj -> m (AttributeDict obj)
set attr obj dict = case HashMap.lookup attr dict of
    Just ref -> do
        writeRef ref obj
        return dict
    Nothing -> do
        ref <- newRef obj
        return $ HashMap.insert attr ref dict
