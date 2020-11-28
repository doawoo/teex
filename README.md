# Tex

[![Elixir Escript Build Test](https://github.com/doawoo/tex/workflows/Elixir%20Escript%20Build%20Test/badge.svg)](https://github.com/doawoo/tex/actions)
[![Hex Tex](https://img.shields.io/hexpm/v/tex.svg)](https://hex.pm/packages/tex)
[![HexDocs Tex](https://img.shields.io/badge/hexdocs.pm-tex-blue)](https://hexdocs.pm/tex/)

**Use Elixir like a scripting language, across your system**

**HEY THERE!** This is a very hacky and experimental tool that solves a weird problem. I really wanted to be able to use Elixir like python all over my system environment. But in order to use any of the Hex packages, I needed a proper Mix project. Tex negates that by shimming into your IEx sessions, and injecting the code paths of libraries you install inside your workspaces.

This has no tests yet. This is basically in-dev. Here be dragons!

Contributions appreciated :D

## How To Use

### Install

Install the escript using mix: `mix escript.install hex tex`

**IMPORTANT:** Ensure you add your escript directory to your `PATH` otherwise you won't be able to use the `tex` command from anywhere!

(If you're using asdf-vm it may be something like "/home/USER/.asdf/installs/elixir/VERSION/.mix/escripts/", you'll probably want to set your global elixir properly before installing tex)

#### Run the `tex init` command

![init](https://user-images.githubusercontent.com/61982076/100492322-ba843980-30df-11eb-9016-cd4f3a211750.gif)

Do what it says! Paste the line it generates bewteen the lightbulbs into your `~/.iex.exs` file!

It should look something like: `c /path/to/your/home/.tex.exs`

### Create A Workspace

![workspace](https://user-images.githubusercontent.com/61982076/100492314-afc9a480-30df-11eb-8958-71198e4de8dc.gif)

### Install A Hex Library

![install](https://user-images.githubusercontent.com/61982076/100492320-b821df80-30df-11eb-91d6-c90bfcbda7b9.gif)

### Load Your Workspace!

![usage](https://user-images.githubusercontent.com/61982076/100492318-b5bf8580-30df-11eb-9e85-593e89563389.gif)

You can load any workspace using `Tex.workspace/1` with a string of your workspace name. It will load up the code paths for all your installed libraries in that workspace!


## Advanced Script Usage!

You can even use Elixir and Tex together to create useful scripts that are usable anywhere on your system.

Here's an example script that loads a workspace, uses Jason, and prints the string to STDOUT

```elixir
#! iex

## ^ include the above so you can simply do:
## ./my_script.exs

## Load your tex shim file
Code.require_file "/home/aaron/.tex.exs"

## Pick your tex workspace
## Let's assume this workspace has Jason installed in it
Tex.workspace "test"

## Do some stuff!
## Let's encode a map to JSON and output it to STDOUT

## Encode using Jason
obj_string = Jason.encode!(%{
    "a" => 1,
    "b" => false,
    "c" => %{
      "nested" => "map"
    }
})

# Write to stdout!
IO.puts(obj_string)

# Exit :)
exit(0)

```

You can use the above script simply by running: 


```
chmod +x my_script.exs
./my_script.exs > output.json
```
