{-# LANGUAGE OverloadedStrings #-}
module Main where

import Database.PostgreSQL.Simple
import Pgvector

main :: IO ()
main = do
    conn <- connectPostgreSQL "dbname=pgvector_haskell_test"
    _ <- execute_ conn "CREATE EXTENSION IF NOT EXISTS vector"
    _ <- execute_ conn "DROP TABLE IF EXISTS items"

    _ <- execute_ conn "CREATE TABLE items (embedding vector(3))"

    _ <- execute conn
        "INSERT INTO items (embedding) VALUES (?)"
        [Vector [1, 1, 1]]
    _ <- execute conn
        "INSERT INTO items (embedding) VALUES (?)"
        [Vector [2, 2, 2]]
    _ <- execute conn
        "INSERT INTO items (embedding) VALUES (?)"
        [Vector [1, 1, 2]]

    let q = "SELECT embedding FROM items ORDER BY embedding <-> ? LIMIT 5"
    forEach conn q [Vector [1, 1, 1]] $ \(Only embedding) ->
        putStrLn $ show (embedding :: Vector)

    _ <- execute_ conn "CREATE INDEX ON items USING ivfflat (embedding vector_l2_ops) WITH (lists = 1)"

    putStrLn "Success"
