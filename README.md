# pgvector-haskell

[pgvector](https://github.com/pgvector/pgvector) support for Haskell

Supports [postgresql-simple](https://hackage.haskell.org/package/postgresql-simple)

[![Build Status](https://github.com/pgvector/pgvector-haskell/actions/workflows/build.yml/badge.svg)](https://github.com/pgvector/pgvector-haskell/actions)

## Getting Started

Add this line to your application’s `.cabal` under `build-depends`:

```text
pgvector >= 0.1 && < 0.2
```

And follow the instructions for your database library:

- [postgresql-simple](#postgresql-simple)

## postgresql-simple

Import the library

```haskell
import Pgvector
```

Enable the extension

```haskell
execute_ conn "CREATE EXTENSION IF NOT EXISTS vector"
```

Create a table

```haskell
execute_ conn "CREATE TABLE items (embedding vector(3))"
```

Insert a vector

```haskell
execute conn
    "INSERT INTO items (embedding) VALUES (?)"
    [Vector [1, 1, 1]]
```

Get the nearest neighbors

```haskell
let q = "SELECT embedding FROM items ORDER BY embedding <-> ? LIMIT 5"
forEach conn q [Vector [1, 1, 1]] $ \(Only embedding) ->
    putStrLn $ show (embedding :: Vector)
```

Add an approximate index

```haskell
execute_ conn "CREATE INDEX ON items USING hnsw (embedding vector_l2_ops)"
-- or
execute_ conn "CREATE INDEX ON items USING ivfflat (embedding vector_l2_ops) WITH (lists = 100)"
```

Use `vector_ip_ops` for inner product and `vector_cosine_ops` for cosine distance

See a [full example](test/Main.hs)

## History

View the [changelog](https://github.com/pgvector/pgvector-haskell/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/pgvector/pgvector-haskell/issues)
- Fix bugs and [submit pull requests](https://github.com/pgvector/pgvector-haskell/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/pgvector/pgvector-haskell.git
cd pgvector-haskell
createdb pgvector_haskell_test
cabal test
```
