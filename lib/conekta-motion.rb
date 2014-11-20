unless defined?(Motion::Project::Config)
  raise "The MotionKit gem must be required within a RubyMotion project Rakefile."
end
require 'dbt'
require 'afmotion'

Motion::Project::App.setup do |app|
  core_lib = File.join(File.dirname(__FILE__), 'conekta-motion')

  # scans app.files until it finds app/ (the default)
  # if found, it inserts just before those files, otherwise it
  # will insert to the end of the list
  insert_point = app.files.find_index { |file| file =~ /^(?:\.\/)?app\// } ||  0
  Dir.glob(File.join(core_lib, '**/*.rb')).reverse.each do |file|
    app.files.insert(insert_point, file)
  end

  DBT.analyze(app)
end
