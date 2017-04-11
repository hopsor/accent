defmodule Accent.PlugTest do
  use ExUnit.Case
  use Plug.Test

  @opts Accent.Plug.init([])

  describe "init/1" do
    test "sets the \"transformer\" option to the value passed in" do
      assert Accent.Plug.init(%{transformer: Accent.Transformer.CamelCase})
        == %{transformer: Accent.Transformer.CamelCase}
    end

    test "defaults the \"transformer\" option to Accent.Transformer.SnakeCase" do
      assert Accent.Plug.init(%{})
        == %{transformer: Accent.Transformer.SnakeCase}
    end
  end

  describe "call/2" do
    test "converts keys to snake_case by default" do
      conn =
        conn(:get, "/", %{"helloWorld" => "value"})
        |> Accent.Plug.call(@opts)

      assert conn.params == %{"hello_world" => "value"}
    end

    test "converts keys using provided transformer" do
      conn =
        conn(:get, "/", %{"hello_world" => "value"})
        |> Accent.Plug.call(Accent.Plug.init([transformer: Accent.Transformer.CamelCase]))

      assert conn.params == %{"HelloWorld" => "value"}
    end
  end
end
