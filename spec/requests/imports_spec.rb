 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/imports", type: :request do
  
  # Import. As you add validations to Import, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Import.create! valid_attributes
      get imports_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      import = Import.create! valid_attributes
      get import_url(import)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_import_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Import" do
        expect {
          post imports_url, params: { import: valid_attributes }
        }.to change(Import, :count).by(1)
      end

      it "redirects to the created import" do
        post imports_url, params: { import: valid_attributes }
        expect(response).to redirect_to(import_url(Import.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Import" do
        expect {
          post imports_url, params: { import: invalid_attributes }
        }.to change(Import, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post imports_url, params: { import: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end
end
