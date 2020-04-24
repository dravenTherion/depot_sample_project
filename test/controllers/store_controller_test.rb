require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success

    assert_select 'nav.side_nav a', minimum: 4
    assert_select 'main .flex_table-cell.image', minimum: 3
    assert_select 'main .flex_table-cell.description', minimum: 3
    assert_select 'h2', 'Programming Ruby 1.9'
    assert_select '.price', /\₱[,\d]+\.\d\d PHP/

  end

end
