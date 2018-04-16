require 'spec_helper'

describe 'pax::repo' do
  let(:pre_condition) { 'include ::pax' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it 'Adds a repository to the catalog' do
        is_expected.to run.with_params('epel')
        expect(catalogue).to contain_pax__repo_helpers__repo('yumrepo/epel')
      end
    end

    context "on #{os} without repository management" do
      let(:facts) { os_facts }
      let(:pre_condition) { "class {'pax': manage_repos => false }" }

      it 'Does not add a repository to the catalog' do
        is_expected.to run.with_params('epel')
        expect(catalogue).not_to contain_pax__repo_helpers__repo('yumrepo/epel')
      end
    end
  end
end
