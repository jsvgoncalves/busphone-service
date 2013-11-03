require 'test_helper'

class BusControllerTest < ActionController::TestCase
  test "should get lines" do
    get :lines
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get validate" do
    get :validate
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get all_tickets" do
    get :all_tickets
    assert_response :success
  end

end
