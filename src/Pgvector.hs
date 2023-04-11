{-# LANGUAGE OverloadedStrings #-}
module Pgvector (Vector (..)) where

import qualified Data.ByteString.Char8 as BS
import Database.PostgreSQL.Simple.FromField
import Database.PostgreSQL.Simple.ToField

data Vector = Vector [Float] deriving (Show)

instance ToField Vector where
    toField = toField . encodeVector

instance FromField Vector where
    fromField f mdat = do
        typ <- typename f
        if typ /= "vector"
            then returnError Incompatible f ""
            else case mdat of
                Nothing  -> returnError UnexpectedNull f ""
                Just dat -> return $! decodeVector (BS.unpack dat)

encodeVector :: Vector -> String
encodeVector (Vector v) = show v

decodeVector :: String -> Vector
decodeVector v = Vector (read v)
