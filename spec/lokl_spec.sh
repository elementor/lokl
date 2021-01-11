# shellcheck shell=sh

Describe 'Default Lokl website'
  Describe 'WP2Static'
    It 'generates zip of exported site files when'
      
      configure_wp2static() {
        # use spec helper for common commands
        # create_lokl_site

        # delete existing test container
        docker rm -f lokltestsite

        # run new container
        # export lokl_php_ver=php7
        export lokl_php_ver=php8
        export lokl_site_name=lokltestsite
        export lokl_site_port=4444

        echo '' >> /tmp/testlog

        env | grep lokl_ >> /tmp/testlog

        # pull down latest version of cript
        wget 'https://raw.githubusercontent.com/leonstafford/lokl-cli/master/cli.sh'

        # create site using noninteractively, using env vars
        sh cli.sh 

        docker exec -it lokltestsite sh -c \
          "wp wp2static addons toggle wp2static-addon-zip && wp wp2static full_workflow"
      }
      
      zip_file_present() {
        processed_site_zip="http://localhost:4444/wp-content/uploads/wp2static-processed-site.zip"


        # TODO: checks on the zip (size, num files, index content?)  
        if wget -q --method=HEAD "$processed_site_zip";
         then
          echo 'found processed zip ' >> /tmp/testlog
          echo 'ZIP FILE PRESENT'
         else
          echo 'NO processed zip ' >> /tmp/testlog
          echo 'ERROR: NO ZIP FILE FOUND'
        fi
      }
      
     When call configure_wp2static
     The output should include 'Finished processing crawled site'
     The result of function zip_file_present should eq 'ZIP FILE PRESENT'
    End
  End
End
