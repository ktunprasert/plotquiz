defmodule Plotquiz.Repo.Migrations.CreateMovie do
  use Ecto.Migration

  def change do
    create table(:movie) do
      add :name, :string
      add :genres, {:array, :string}
      add :description, :string
      add :imdb_rating, :string
      add :rt_rating, :string
      add :release_year, :integer
      add :country_of_origin, :string
      add :actors, {:array, :string}

      timestamps()
    end
  end
end
