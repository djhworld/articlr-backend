require File.dirname(__FILE__) + "/lib/ArticlrBackend"
set :root, File.expand_path(File.dirname(__FILE__) + '/')
set :app_file, File.expand_path(File.dirname(__FILE__) + '/lib/ArticlriBackend.rb')
set :env,     :production
disable :run, :reload
run ArticlrBackend

