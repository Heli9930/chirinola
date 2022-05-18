 
# Chirinola

## Requirements
```txt
Elixir ~> 1.12.3
Erlang ~> 22.3.4.21
PostgreSQL ~> 14.1
```

## Up and running
```cmd 
iex -S mix
```
```cmd
iex(1)> Chirinola.MigratorFast.start("some/path/some_try_file.txt")
```
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `chirinola` to your list of dependencies in `mix.exs`:
```elixir
def deps do
  [
    {:chirinola, "~> 0.1.0"}
  ]
end
```
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/chirinola](https://hexdocs.pm/chirinola).
