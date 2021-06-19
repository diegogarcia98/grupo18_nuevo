require "test_helper"

class OrdenCompraControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get orden_compra_new_url
    assert_response :success
  end

  test "should get index" do
    get orden_compra_index_url
    assert_response :success
  end

  test "should get show" do
    get orden_compra_show_url
    assert_response :success
  end

  test "should get edit" do
    get orden_compra_edit_url
    assert_response :success
  end
end
