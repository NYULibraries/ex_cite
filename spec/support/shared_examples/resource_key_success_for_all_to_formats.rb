RSpec.shared_examples "resource_key-stubbed success for all to_format" do |from_format|
  let(:cached_data_converted){ public_send(:"#{to_format}_data") }

  context "to openurl" do
    let(:to_format){ "openurl" }
    its(:status) { is_expected.to eq 200 }
  end
  context "to ris" do
    let(:to_format){ "ris" }
    its(:status) { is_expected.to eq 200 }
  end
  context "to refworks_tagged" do
    let(:to_format){ "refworks_tagged" }
    its(:status) { is_expected.to eq 200 }
  end
  context "to refworks" do
    let(:to_format){ "refworks" }
    let(:nested_resource_cache_key){ nested_resource_key + "to_refworks_tagged" }
    let(:cached_data_converted){ refworks_tagged_data }
    its(:status) { is_expected.to eq 200 }
    it { is_expected.to render_template "ex_cite/cite/external_form" }
  end
  context "to bibtex" do
    let(:to_format){ "bibtex" }
    its(:status) { is_expected.to eq 200 }
  end
  context "to easybib" do
    let(:to_format){ "easybib" }
    let(:cached_data_converted){ "[{\"source\":\"book\",\"book\":{\"title\":null},\"pubtype\":{\"main\":\"pubnonperiodical\"},\"pubnonperiodical\":{},\"contributors\":[]}]" }
    its(:status) { is_expected.to eq 200 }
  end
  context "to easybibpush" do
    let(:to_format){ "easybibpush" }
    let(:nested_resource_cache_key){ nested_resource_key + "to_easybib" }
    let(:cached_data_converted){ "[{\"source\":\"book\",\"book\":{\"title\":null},\"pubtype\":{\"main\":\"pubnonperiodical\"},\"pubnonperiodical\":{},\"contributors\":[]}]" }
    its(:status) { is_expected.to eq 200 }
    it { is_expected.to render_template "ex_cite/cite/external_form" }
  end
  context "to csl" do
    let(:to_format){ "csl" }
    let(:cached_data_converted){ csf_data }
    its(:status) { is_expected.to eq 200 }
  end
  context "to csf" do
    let(:to_format){ "csf" }
    its(:status) { is_expected.to eq 200 }
  end
end
