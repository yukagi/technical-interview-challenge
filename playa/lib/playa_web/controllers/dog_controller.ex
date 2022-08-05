defmodule PlayaWeb.DogController do
  use PlayaWeb, :controller

  alias Playa.Dogs
  alias Playa.Dogs.Dog
  alias Playa.ImageUploader

  def index(conn, _params) do
    dogs = Dogs.list_dogs()
    render(conn, "index.html", dogs: dogs)
  end

  def new(conn, _params) do
    changeset = Dogs.change_dog(%Dog{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"dog" => dog_params}) do
    with {:ok, image_path} <- ImageUploader.upload_image(dog_params),
         {:ok, dog_params} <- ImageUploader.add_image_path_to_params(dog_params, image_path),
         {:ok, dog} <- Dogs.create_dog(dog_params) do
      conn
      |> put_flash(:info, "Dog created successfully.")
      |> redirect(to: Routes.dog_path(conn, :show, dog))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def show(conn, %{"id" => id}) do
    dog = Dogs.get_dog!(id)
    render(conn, "show.html", dog: dog)
  end

  def edit(conn, %{"id" => id}) do
    dog = Dogs.get_dog!(id)
    changeset = Dogs.change_dog(dog)
    render(conn, "edit.html", dog: dog, changeset: changeset)
  end

  def update(conn, %{"id" => id, "dog" => dog_params}) do
    dog = Dogs.get_dog!(id)

    case Dogs.update_dog(dog, dog_params) do
      {:ok, dog} ->
        conn
        |> put_flash(:info, "Dog updated successfully.")
        |> redirect(to: Routes.dog_path(conn, :show, dog))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", dog: dog, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    dog = Dogs.get_dog!(id)
    {:ok, _dog} = Dogs.delete_dog(dog)

    conn
    |> put_flash(:info, "Dog deleted successfully.")
    |> redirect(to: Routes.dog_path(conn, :index))
  end
end