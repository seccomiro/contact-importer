require 'rails_helper'

RSpec.describe "contacts/index", type: :view do
  before(:each) do
    assign(:contacts, [
      Contact.create!(
        name: "Name",
        email: "Email",
        birthdate: "Birthdate",
        phone: "Phone",
        address: "Address",
        credit_card: "Credit Card",
        franchise: "Franchise"
      ),
      Contact.create!(
        name: "Name",
        email: "Email",
        birthdate: "Birthdate",
        phone: "Phone",
        address: "Address",
        credit_card: "Credit Card",
        franchise: "Franchise"
      )
    ])
  end

  it "renders a list of contacts" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Email".to_s, count: 2
    assert_select "tr>td", text: "Birthdate".to_s, count: 2
    assert_select "tr>td", text: "Phone".to_s, count: 2
    assert_select "tr>td", text: "Address".to_s, count: 2
    assert_select "tr>td", text: "Credit Card".to_s, count: 2
    assert_select "tr>td", text: "Franchise".to_s, count: 2
  end
end
