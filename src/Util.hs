
module Util ( L8R16
            , makeW16
            , splitW16
            , Flag(..)
            , getFlag
            , setFlag
            , clearFlag
            , modifyFlag
            , makeSRString
            , srFromString
            , b2W8) where

import Data.Word (Word8, Word16)
import Data.Bits ((.|.), (.&.), shiftL, shiftR, testBit, setBit, clearBit)

type L8R16 = Either Word8 Word16

{-# INLINE makeW16 #-}
makeW16 :: Word8 -> Word8 -> Word16
makeW16 l h = (fromIntegral l :: Word16) .|. (fromIntegral h :: Word16) `shiftL` 8

{-# INLINE splitW16 #-}
splitW16 :: Word16 -> (Word8, Word8)
splitW16 w = (fromIntegral (w .&. 0xFF), fromIntegral (w `shiftR` 8))

data Flag = FN | FV | F1 | FB | FD | FI | FZ | FC
            deriving (Enum)

{-# INLINE getFlag #-}
getFlag :: Flag -> Word8 -> Bool
getFlag f w = testBit w (7 - fromEnum f)

{-# INLINE setFlag #-}
setFlag :: Flag -> Word8 -> Word8
setFlag f w = setBit w (7 - fromEnum f)

{-# INLINE clearFlag #-}
clearFlag :: Flag -> Word8 -> Word8
clearFlag f w = clearBit w (7 - fromEnum f)

{-# INLINE modifyFlag #-}
modifyFlag :: Flag -> Bool -> Word8 -> Word8
modifyFlag f b w = if b then setFlag f w else clearFlag f w

makeSRString :: Word8 -> String
makeSRString w =
    map (\(f, s) -> if getFlag f w then s else '·') $ zip [FN .. FC] "NV1BDIZC"

srFromString :: String -> Word8
srFromString s = foldr (\(c, f) sr -> modifyFlag f (c /= '-' && c /= '·') sr) 0 $ zip s [FN .. FC]

{-# INLINE b2W8 #-}
b2W8 :: Bool -> Word8
b2W8 b = if b then 1 else 0

