defmodule Playa.DogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Playa.Dogs` context.
  """

  @doc """
  Generate a dog.
  """
  def dog_fixture(attrs \\ %{}) do
    {:ok, dog} =
      attrs
      |> Enum.into(%{
        breed: "some breed"
      })
      |> Playa.Dogs.create_dog()

    dog
  end
end