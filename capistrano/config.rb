namespace :airflow_plateform_docker do
  task :create_symlink_repository, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path}; \
    docker stop $(docker ps -a -q); \
    docker rm $(docker ps -a -q); \
    docker rm $(docker ps -all -q); \
    docker rmi $(docker image ls -q); \
    docker system prune -af --volumes; \
    docker-compose up --build -d database;
    docker-compose up --build -d airflow;
    "
  end
end