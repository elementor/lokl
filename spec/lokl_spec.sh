# shellcheck shell=sh

Describe 'Default Lokl website'
  Describe 'WP2Static'
    It 'generates zip of exported site files when'
      run_docker_php${phpversion}
      
      configure_wp2static() {
        docker exec -it THE_IMAGE sh -c \
          'wp wp2static option set deployment_method zip && wp wp2static detect && wp wp2static crawl && \
          wp wp2static post_process && wp wp2static deploy'
      }
      
      zip_file_present() {
        wget http://localhost:4321/wp-content/uploads/wp2static-processed-site.zip
        # do some checks on the zip (size, num files, index content?)  
      }
      
     When run configure_wp2static()
     The output should satisfy zip_file_present  
     The result of function zip_file_present should be true
  End
End
