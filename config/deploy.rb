# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "qna"
set :repo_url, "git@github.com:AntonyKhalt0/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'
set :pg_password, '1234' # Example is an ENV value, but you can use a string instead
set :pg_ask_for_password, true # Prompts user for password on execution of setup
# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"
