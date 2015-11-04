require 'spec_helper'

describe 'openmrs', :type => :class do
  context 'on Ubuntu 14.04 64bit' do
    $tomcat_catalina_base = '/var/lib/tomcat7'
    $tomcat_user = 'tomcat7'
    $openmrs_application_data_directory = '/usr/share/tomcat7/.OpenMRS'

    context 'with default parameters' do
      let(:params) { {
        :tomcat_catalina_base => $tomcat_catalina_base,
        :tomcat_user => $tomcat_user,
        :openmrs_application_data_directory => $openmrs_application_data_directory,
      } }

      it { is_expected.to compile }
      it { is_expected.to contain_class('openmrs') }
      it { is_expected.to contain_class('tomcat') }
      it { is_expected.to contain_file($openmrs_application_data_directory).with(
          'ensure' => 'directory',
          'owner'  => $tomcat_user,
          'group'  => $tomcat_user,
          'mode'   => '0755'
      ) }
      it { is_expected.to contain_tomcat__war('openmrs.war').with(
        'catalina_base' => $tomcat_catalina_base,
        'war_source'    => 'http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Platform_1.11.4/openmrs.war',
      ) }
      it { is_expected.to contain_mysql_database('openmrs') }
      it { is_expected.to contain_mysql_user('openmrs@localhost') }
    end

    context 'with custom db parameters' do
      $db_host = 'db.example.com'
      $db_name = 'medical'
      $db_owner = 'medicaladmin'
      $db_owner_password = 'admin123'
      let(:params) { {
        :tomcat_catalina_base => $tomcat_catalina_base,
        :tomcat_user => $tomcat_user,
        :openmrs_application_data_directory => $openmrs_application_data_directory,
        :db_host => $db_host,
        :db_name => $db_name,
        :db_owner => $db_owner,
        :db_owner_password => $db_owner_password,
      } }

      it { is_expected.to contain_mysql_database($db_name) }
      it { is_expected.to contain_mysql_user($db_owner + "@" + $db_host) }
    end

    context 'with invalid parameters' do
      describe 'given non absolute tomcat_catalina_base' do
        let(:params) {{
          :tomcat_catalina_base => 'var/lib/tomcat7',
          :tomcat_user => $tomcat_user,
          :openmrs_application_data_directory => $openmrs_application_data_directory,
        }}
        it { should_not compile }
      end
      describe 'given non string tomcat_user' do
        let(:params) {{
          :tomcat_catalina_base => $tomcat_catalina_base,
          :tomcat_user => 1232,
          :openmrs_application_data_directory => $openmrs_application_data_directory,
        }}
        it { should_not compile }
      end
      describe 'given non absolute openmrs_application_data_directory' do
        let(:params) {{
          :tomcat_catalina_base => $tomcat_catalina_base,
          :tomcat_user => $tomcat_user,
          :openmrs_application_data_directory => 'lib/openmrs',
        }}
        it { should_not compile }
      end
      describe 'given non string db_host' do
        let(:params) {{
          :tomcat_catalina_base => $tomcat_catalina_base,
          :tomcat_user => $tomcat_user,
          :openmrs_application_data_directory => $openmrs_application_data_directory,
          :db_host => 1242,
        }}
        it { should_not compile }
      end
      describe 'given non string db_name' do
        let(:params) {{
          :tomcat_catalina_base => $tomcat_catalina_base,
          :tomcat_user => $tomcat_user,
          :openmrs_application_data_directory => $openmrs_application_data_directory,
          :db_name => 1242,
        }}
        it { should_not compile }
      end
      describe 'given non string db_owner' do
        let(:params) {{
          :tomcat_catalina_base => $tomcat_catalina_base,
          :tomcat_user => $tomcat_user,
          :openmrs_application_data_directory => $openmrs_application_data_directory,
          :db_owner => 1242,
        }}
        it { should_not compile }
      end
      describe 'given non string db_owner_password' do
        let(:params) {{
          :tomcat_catalina_base => $tomcat_catalina_base,
          :tomcat_user => $tomcat_user,
          :openmrs_application_data_directory => $openmrs_application_data_directory,
          :db_owner_password => 1242,
        }}
        it { should_not compile }
      end
    end
  end
end
