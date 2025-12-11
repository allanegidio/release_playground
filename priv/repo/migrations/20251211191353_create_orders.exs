defmodule ReleasePlayground.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :total_price, :integer
      add :total_quantity, :integer
      add :address, :string
      add :phone_number, :string

      timestamps(type: :utc_datetime)
    end
  end
end
