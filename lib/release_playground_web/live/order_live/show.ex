defmodule ReleasePlaygroundWeb.OrderLive.Show do
  use ReleasePlaygroundWeb, :live_view

  alias ReleasePlayground.Orders

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Order {@order.id}
        <:subtitle>This is a order record from your databas NOICE e.</:subtitle>
        <:actions>
          <.button navigate={~p"/orders"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/orders/#{@order}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit order
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Total price">{@order.total_price}</:item>
        <:item title="Total quantity">{@order.total_quantity}</:item>
        <:item title="Address">{@order.address}</:item>
        <:item title="Phone number">{@order.phone_number}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Order")
     |> assign(:order, Orders.get_order!(id))}
  end
end
