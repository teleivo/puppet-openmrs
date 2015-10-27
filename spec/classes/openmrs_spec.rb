require 'spec_helper'

describe 'openmrs', :type => :class do
  context 'on Ubuntu 14.04 64bit' do

    context 'with default parameters' do
      let(:params) { {
        :tomcat_catalina_base => '/var/lib/tomcat7',
        :tomcat_user => 'tomcat7',
      } }
      it { is_expected.to compile }
      it { is_expected.to contain_class('tomcat') }
      it { is_expected.to contain_file('/var/lib/tomcat7/openmrs-runtime.properties')
            .with(
              'ensure' => 'present',
              'owner'  => 'tomcat7',
              'group'  => 'tomcat7',
              'mode'   => '0644',
            )
            .with_content(/connection.url=jdbc:mysql:\/\/localhost:3306\/openmrs\?autoReconnect=true&sessionVariables=storage_engine=InnoDB&useUnicode=true&characterEncoding=UTF-8/)
            .with_content(/connection.username=openmrs/)
            .with_content(/connection.password=openmrs/)
            .with_content(/auto_update_database=false/)
            .with_content(/module.allow_web_admin=true/)
            .with_content(/application_data_directory=\/opt\/openmrs/)
      }
      it {
        is_expected.to contain_file('/opt/openmrs').with(
          'ensure' => 'directory',
          'owner'  => 'tomcat7',
          'group'  => 'tomcat7',
          'mode'   => '0755'
        )
      }
      it { is_expected.to contain_mysql_database('openmrs') }
      it { is_expected.to contain_mysql_user('openmrs@localhost') }
    end

    context 'with custom db parameters' do
      $db_host = 'db.example.com'
      $db_name = 'medical'
      $db_owner = 'medicaladmin'
      $db_owner_password = 'admin123'
      let(:params) { {
        :tomcat_catalina_base => '/var/lib/tomcat7',
        :tomcat_user => 'tomcat7',
        :db_host => $db_host,
        :db_name => $db_name,
        :db_owner => $db_owner,
        :db_owner_password => $db_owner_password,
      } }

      it { is_expected.to contain_file('/var/lib/tomcat7/openmrs-runtime.properties')
            .with_content(/connection.url=jdbc:mysql:\/\/db.example.com:3306\/medical\?autoReconnect=true&sessionVariables=storage_engine=InnoDB&useUnicode=true&characterEncoding=UTF-8/)
            .with_content(/connection.username=medicaladmin/)
            .with_content(/connection.password=admin123/)
            .with_content(/auto_update_database=false/)
            .with_content(/module.allow_web_admin=true/)
            .with_content(/application_data_directory=\/opt\/openmrs/)
      }
      it { is_expected.to contain_mysql_database($db_name) }
      it { is_expected.to contain_mysql_user($db_owner + "@" + $db_host) }
    end

    context 'with custom openmrs application directory' do
      $openmrs_application_data_directory = '/var/lib/openmrs'
      let(:params) { {
        :tomcat_catalina_base => '/var/lib/tomcat7',
        :tomcat_user => 'tomcat7',
        :openmrs_application_data_directory => $openmrs_application_data_directory,
      } }

      it { is_expected.to contain_file('/var/lib/tomcat7/openmrs-runtime.properties')
            .with(
              'ensure' => 'present',
              'owner'  => 'tomcat7',
              'group'  => 'tomcat7',
              'mode'   => '0644',
            )
            .with_content(/application_data_directory=\/var\/lib\/openmrs/)
      }
      it {
        is_expected.to contain_file($openmrs_application_data_directory).with(
          'ensure' => 'directory',
          'owner'  => 'tomcat7',
          'group'  => 'tomcat7',
          'mode'   => '0755'
        )
      }
    end
  end
end
