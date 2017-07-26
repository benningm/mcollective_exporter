
app_dir = "/usr/src/app"
 
working_directory app_dir
 
#pid "/tmp/unicorn.pid"
 
worker_processes 10
listen "/tmp/unicorn.sock", :backlog => 64
listen "0.0.0.0:80", :tcp_nopush => true
timeout 120

