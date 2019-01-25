-- | This module represents the functional bindings to JavaScript's `ArrayBuffer`
-- | objects. See [MDN's spec](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer) for details.

module Data.ArrayBuffer.ArrayBuffer
  ( empty
  , byteLength
  , slice
  ) where

import Data.ArrayBuffer.Types (ArrayBuffer, ByteOffset, ByteLength)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, notNull, null)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)


foreign import emptyImpl :: EffectFn1 ByteLength ArrayBuffer


-- | Create an `ArrayBuffer` with the given capacity.
empty :: ByteLength -> Effect ArrayBuffer
empty l = runEffectFn1 emptyImpl l

-- | Represents the length of an `ArrayBuffer` in bytes.
foreign import byteLength :: ArrayBuffer -> ByteLength

foreign import sliceImpl :: Fn3 ArrayBuffer (Nullable ByteOffset) (Nullable ByteOffset) ArrayBuffer

-- | Returns a new `ArrayBuffer` whose contents are a copy of this ArrayBuffer's bytes from begin, inclusive, up to end, exclusive.
slice :: ArrayBuffer -> Maybe (Tuple ByteOffset (Maybe ByteOffset)) -> ArrayBuffer
slice a mz = case mz of
  Nothing -> runFn3 sliceImpl a null null
  Just (Tuple s me) -> case me of
    Nothing -> runFn3 sliceImpl a (notNull s) null
    Just e -> runFn3 sliceImpl a (notNull s) (notNull e)
