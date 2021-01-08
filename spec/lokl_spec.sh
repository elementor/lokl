# shellcheck shell=sh

Describe 'Default Lokl website'
  Describe 'WP2Static'
    It 'generates zip of exported site files when'
      
      configure_wp2static() {
        # use spec helper for common commands
        # create_lokl_site

        # run new container
        export lokl_php_ver=php8 
        export lokl_site_name=lokltestsite
        export lokl_site_port=4444

        echo 'something ' >> /tmp/testlog

        env | grep lokl_ >> /tmp/testlog

        wget 'https://raw.githubusercontent.com/leonstafford/lokl-cli/master/cli.sh'

        sh cli.sh 

        docker exec -it lokltestsite sh -c \
          "wp wp2static option set deployment_method zip && wp wp2static detect && wp wp2static crawl && \
          wp wp2static post_process && wp wp2static deploy"
      }
      
      zip_file_present() {
        # wget http://localhost:4444/wp-content/uploads/wp2static-processed-site.zip
        # do some checks on the zip (size, num files, index content?)  
        echo ""
        return 0
      }
      
     When call configure_wp2static
     The output should include 'something'
     The result of function zip_file_present should be success
    End
  End
End
