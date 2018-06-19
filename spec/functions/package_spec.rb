require 'spec_helper'

describe 'pax::package' do
  let(:pre_condition) { 'include ::pax' }

  facts = on_supported_os['centos-7-x86_64']

  context 'on centos without externally included git' do
    let(:facts) { facts }

    it 'Adds the git package to the catalog' do
      is_expected.to run.with_params('git')
      expect(catalogue).to contain_package('git').with_ensure('present')
    end
  end

  context 'on centos with externally included git' do
    let(:facts) { facts }
    let(:pre_condition) do
      'include ::pax
      package {"git": ensure => installed}'
    end

    it 'Fails when asked to add git to the catalog' do
      is_expected.to run.with_params('git').and_raise_error(%r{Duplicate declaration: Package})
    end
  end
end
