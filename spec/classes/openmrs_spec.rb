require 'spec_helper'

describe 'openmrs', :type => :class do
    $tomcat_catalina_base = '/var/lib/tomcat7'
    $tomcat_user = 'tomcat7'
    $openmrs_application_data_directory = '/usr/share/tomcat7/.OpenMRS'
    $default_db_name = 'openmrs'
    let :valid_required_params do
      {
        :tomcat_catalina_base => $tomcat_catalina_base,
        :tomcat_user => $tomcat_user,
        :openmrs_application_data_directory => $openmrs_application_data_directory,
      }
    end

  context 'on Ubuntu 14.04 64bit' do

    context 'with only required parameters given' do
      let :params do
        valid_required_params
      end
      it { is_expected.to compile }
      it { is_expected.to contain_class('openmrs') }
      it { is_expected.to contain_class('tomcat') }
      it { is_expected.to contain_file($openmrs_application_data_directory).with(
          'ensure' => 'directory',
          'owner'  => $tomcat_user,
          'group'  => $tomcat_user,
          'mode'   => '0755'
      ) }
      it { is_expected.to contain_tomcat__war('openmrs.war')
        .with(
          'catalina_base' => $tomcat_catalina_base,
          'war_source'    => 'http://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Platform_1.11.4/openmrs.war',)
        .that_requires("File[" + $openmrs_application_data_directory + "]")
        .that_requires("Mysql::Db[" + $default_db_name + "]")
      }
      it { is_expected.to contain_mysql_database($default_db_name) }
      it { is_expected.to contain_mysql_user('openmrs@localhost') }
    end

    context 'with custom db parameters' do
      $db_host = 'db.example.com'
      $db_name = 'medical'
      $db_owner = 'medicaladmin'
      $db_owner_password = 'admin123'
      let :params do
        valid_required_params.merge({
          :db_host => $db_host,
          :db_name => $db_name,
          :db_owner => $db_owner,
          :db_owner_password => $db_owner_password,
        })
      end
      it { is_expected.to contain_mysql_database($db_name) }
      it { is_expected.to contain_mysql_user($db_owner + "@" + $db_host) }
    end

    context 'with invalid parameters' do
      describe 'given non absolute tomcat_catalina_base' do
        let :params do
          valid_required_params.merge({
            :tomcat_catalina_base => 'var/lib/tomcat7',
          })
        end
        it { should_not compile }
      end
      describe 'given non string tomcat_user' do
        let :params do
          valid_required_params.merge({
            :tomcat_user => true,
          })
        end
        it { should_not compile }
      end
      describe 'given non absolute openmrs_application_data_directory' do
        let :params do
          valid_required_params.merge({
            :openmrs_application_data_directory => 'lib/openmrs',
          })
        end
        it { should_not compile }
      end
      describe 'given non string db_host' do
        let :params do
          valid_required_params.merge({
            :db_host => true,
          })
        end
        it { should_not compile }
      end
      describe 'given non string db_name' do
        let :params do
          valid_required_params.merge({
            :db_name => true,
          })
        end
        it { should_not compile }
      end
      describe 'given non string db_owner' do
        let :params do
          valid_required_params.merge({
            :db_owner => true,
          })
        end
        it { should_not compile }
      end
      describe 'given non string db_owner_password' do
        let :params do
          valid_required_params.merge({
            :db_owner_password => true,
          })
        end
        it { should_not compile }
      end
    end
  end
end
