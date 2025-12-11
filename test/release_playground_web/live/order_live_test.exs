defmodule ReleasePlaygroundWeb.OrderLiveTest do
  use ReleasePlaygroundWeb.ConnCase

  import Phoenix.LiveViewTest
  import ReleasePlayground.OrdersFixtures

  @create_attrs %{
    address: "some address",
    total_price: 42,
    total_quantity: 42,
    phone_number: "some phone_number"
  }
  @update_attrs %{
    address: "some updated address",
    total_price: 43,
    total_quantity: 43,
    phone_number: "some updated phone_number"
  }
  @invalid_attrs %{address: nil, total_price: nil, total_quantity: nil, phone_number: nil}
  defp create_order(_) do
    order = order_fixture()

    %{order: order}
  end

  describe "Index" do
    setup [:create_order]

    test "lists all orders", %{conn: conn, order: order} do
      {:ok, _index_live, html} = live(conn, ~p"/orders")

      assert html =~ "Listing Orders"
      assert html =~ order.address
    end

    test "saves new order", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/orders")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Order")
               |> render_click()
               |> follow_redirect(conn, ~p"/orders/new")

      assert render(form_live) =~ "New Order"

      assert form_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#order-form", order: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/orders")

      html = render(index_live)
      assert html =~ "Order created successfully"
      assert html =~ "some address"
    end

    test "updates order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, ~p"/orders")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#orders-#{order.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/orders/#{order}/edit")

      assert render(form_live) =~ "Edit Order"

      assert form_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#order-form", order: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/orders")

      html = render(index_live)
      assert html =~ "Order updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, ~p"/orders")

      assert index_live |> element("#orders-#{order.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#orders-#{order.id}")
    end
  end

  describe "Show" do
    setup [:create_order]

    test "displays order", %{conn: conn, order: order} do
      {:ok, _show_live, html} = live(conn, ~p"/orders/#{order}")

      assert html =~ "Show Order"
      assert html =~ order.address
    end

    test "updates order and returns to show", %{conn: conn, order: order} do
      {:ok, show_live, _html} = live(conn, ~p"/orders/#{order}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/orders/#{order}/edit?return_to=show")

      assert render(form_live) =~ "Edit Order"

      assert form_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#order-form", order: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/orders/#{order}")

      html = render(show_live)
      assert html =~ "Order updated successfully"
      assert html =~ "some updated address"
    end
  end
end
