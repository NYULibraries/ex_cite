require 'rails_helper'

describe CiteroEngine::CiteroEngineController, type: :controller do
  routes { CiteroEngine::Engine.routes }

  describe "GET index" do
    subject{ response }
    let(:csf_data){ "itemType: book" }
    let(:ris_data){ "TY  -  BOOK\nER  -\n\n" }
    let(:openurl_data){ "https://getit.library.nyu.edu/resolve?rft_val_fmt=info:ofi/fmt:kev:mtx:book" }
    let(:bibtex_data){ "@book{????\n}" }
    let(:pnx_data){ "<record><display><type>book</type></display></record>" }
    let(:refworks_tagged_data){ "RT Book, whole\nER \n \n" }

    context "using data" do
      context "with from_format" do
        before { get :index, to_format: to_format, from_format: from_format, data: data }

        context "valid data" do
          let(:data){ public_send(:"#{from_format}_data") }

          include_examples "book success for all from_format and to_format"
        end

        context "invalid data" do
          let(:data){ "$%^$* some nonsense !@#$%^&*}" }

          pending
          # include_examples "bad_request for all from_format and to_format"
        end
      end # end with from_format
    end # end using data

    context "using id" do
      before { get :index, to_format: to_format, id: id }

      context "valid id" do
        around do |example|
          old_acts_as_citable_class = CiteroEngine.acts_as_citable_class
          CiteroEngine.acts_as_citable_class = DummyPersistentCitation
          example.run
          CiteroEngine.acts_as_citable_class = old_acts_as_citable_class
        end
        let(:citation){ DummyPersistentCitation.create(data: data, format: from_format) }
        let(:id){ citation.id }

        context "with valid data" do
          let(:data){ public_send(:"#{from_format}_data") }

          include_examples "book success for all from_format and to_format"
        end

        context "with invalid data" do
          let(:data){ "%^&%^&cbdsds" }

          pending
          # include_examples "bad_request for all from_format and to_format"
        end
      end # end valid id

      context "invalid id" do
        let(:id) { "error" }

        include_examples "bad_request for all from_format and to_format"
      end # end invalid id
    end # end using id

    context "using resource_key" do
      let(:resource_key){ "abcd" }
      let(:converted_to_format) do
        return "refworks_tagged" if to_format == "refworks"
        return "easybib" if to_format == "easybibpush"
        to_format
      end

      context "valid resource_key" do
        context "for single resource" do
          let(:nested_resource_key){ "wxyz" }
          let(:nested_resource_cache_key){ nested_resource_key + "to_" + converted_to_format }
          before do
            allow(Rails.cache).to receive(:fetch).once.with(resource_key).and_return(nested_resource_key)
            allow(Rails.cache).to receive(:fetch).once.with(nested_resource_cache_key).and_return(cached_data_converted) if defined?(cached_data_converted)
          end
          before { get :index, to_format: to_format, resource_key: resource_key }

          include_examples "resource_key-stubbed success for all from_format and to_format"
        end # end for single resource

        context "for collection of resources" do
          let(:nested_resource_keys){ [nested_resource_key1, nested_resource_key2, nested_resource_key3] }
          let(:nested_resource_key1){ "1234" }
          let(:nested_resource_key2){ "5678" }
          let(:nested_resource_key3){ "wxyz" }
          let(:nested_resource_cache_key1){ nested_resource_key1 + "to_" + converted_to_format }
          let(:nested_resource_cache_key2){ nested_resource_key2 + "to_" + converted_to_format }
          let(:nested_resource_cache_key3){ nested_resource_key3 + "to_" + converted_to_format }
          before do
            allow(Rails.cache).to receive(:fetch).once.with(resource_key).and_return(nested_resource_keys)
            allow(Rails.cache).to receive(:fetch).once.with(nested_resource_cache_key1).and_return(cached_data_converted) if defined?(cached_data_converted)
            allow(Rails.cache).to receive(:fetch).once.with(nested_resource_cache_key2).and_return(cached_data_converted) if defined?(cached_data_converted)
            allow(Rails.cache).to receive(:fetch).once.with(nested_resource_cache_key3).and_return(cached_data_converted) if defined?(cached_data_converted)
          end
          before { get :index, to_format: to_format, resource_key: resource_key }

          include_examples "resource_key-stubbed success for all from_format and to_format"
        end
      end # end valid resource_key

      context "invalid resource_key" do
        before { allow(Rails.cache).to receive(:fetch).once.with(resource_key).and_return(nil) }
        before { get :index, to_format: to_format, resource_key: resource_key }

        include_examples "bad_request for all from_format and to_format"
      end # end invalid resource_key
    end

    context "using openurl" do
      before { get :index, to_format: to_format, rft_val_fmt: "info:ofi/fmt:kev:mtx:book" }
      let(:data){ "http://test.host" + URI.decode(request.fullpath) }

      include_examples "book success for all to_format", "openurl"
    end
  end
end
