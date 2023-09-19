defmodule Plotquiz.Movie.Quiz do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie" do
    field :name, :string
    field :description, :string
    field :genres, {:array, :string}
    field :imdb_rating, :string
    field :rt_rating, :string
    field :release_year, :integer
    field :country_of_origin, :string
    field :actors, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(quiz, attrs) do
    quiz
    |> cast(attrs, [:name, :genres, :description, :imdb_rating, :rt_rating, :release_year, :country_of_origin, :actors])
    |> validate_required([:name, :genres])
  end
end
