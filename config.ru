$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'mcollective_exporter/app'

run MCollectiveExporter::App

