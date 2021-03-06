# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cliclac}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephane Bellity"]
  s.date = %q{2009-10-10}
  s.default_executable = %q{cliclac}
  s.description = %q{A port of CouchDB's Futon web interface to MongoDB. For more information, see http://www.github.com/sbellity/cliclac}
  s.email = %q{sbellity@gmail.com}
  s.executables = ["cliclac"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "bin/cliclac",
     "cliclac.gemspec",
     "lib/cliclac.rb",
     "lib/cliclac/adapters/base.rb",
     "lib/cliclac/adapters/mongo.rb",
     "lib/cliclac/app.rb",
     "lib/cliclac/helpers.rb",
     "lib/cliclac/key.rb",
     "lib/cliclac/query.rb",
     "lib/cliclac/utils.rb",
     "public/_utils/_sidebar.html",
     "public/_utils/config.html",
     "public/_utils/couch_tests.html",
     "public/_utils/custom_test.html",
     "public/_utils/database.html",
     "public/_utils/dialog/_compact_database.html",
     "public/_utils/dialog/_create_database.html",
     "public/_utils/dialog/_create_document.html",
     "public/_utils/dialog/_delete_database.html",
     "public/_utils/dialog/_delete_document.html",
     "public/_utils/dialog/_save_view_as.html",
     "public/_utils/dialog/_upload_attachment.html",
     "public/_utils/document.html",
     "public/_utils/favicon.ico",
     "public/_utils/image/add.png",
     "public/_utils/image/apply.gif",
     "public/_utils/image/bg.png",
     "public/_utils/image/cancel.gif",
     "public/_utils/image/compact.png",
     "public/_utils/image/delete-mini.png",
     "public/_utils/image/delete.png",
     "public/_utils/image/grippie.gif",
     "public/_utils/image/hgrad.gif",
     "public/_utils/image/load.png",
     "public/_utils/image/logo.png",
     "public/_utils/image/order-asc.gif",
     "public/_utils/image/order-desc.gif",
     "public/_utils/image/path.gif",
     "public/_utils/image/progress.gif",
     "public/_utils/image/rarrow.png",
     "public/_utils/image/run-mini.png",
     "public/_utils/image/run.png",
     "public/_utils/image/running.png",
     "public/_utils/image/save.png",
     "public/_utils/image/sidebar-toggle.png",
     "public/_utils/image/spinner.gif",
     "public/_utils/image/test_failure.gif",
     "public/_utils/image/test_success.gif",
     "public/_utils/image/thead-key.gif",
     "public/_utils/image/thead.gif",
     "public/_utils/image/toggle-collapse.gif",
     "public/_utils/image/toggle-expand.gif",
     "public/_utils/image/twisty.gif",
     "public/_utils/index.html",
     "public/_utils/replicator.html",
     "public/_utils/script/couch.js",
     "public/_utils/script/couch_test_runner.js",
     "public/_utils/script/couch_tests.js",
     "public/_utils/script/futon.browse.js",
     "public/_utils/script/futon.format.js",
     "public/_utils/script/futon.js",
     "public/_utils/script/jquery.cookies.js",
     "public/_utils/script/jquery.couch.js",
     "public/_utils/script/jquery.dialog.js",
     "public/_utils/script/jquery.editinline.js",
     "public/_utils/script/jquery.form.js",
     "public/_utils/script/jquery.js",
     "public/_utils/script/jquery.resizer.js",
     "public/_utils/script/jquery.suggest.js",
     "public/_utils/script/json2.js",
     "public/_utils/script/test/all_docs.js",
     "public/_utils/script/test/attachment_names.js",
     "public/_utils/script/test/attachment_paths.js",
     "public/_utils/script/test/attachment_views.js",
     "public/_utils/script/test/attachments.js",
     "public/_utils/script/test/basics.js",
     "public/_utils/script/test/bulk_docs.js",
     "public/_utils/script/test/changes.js",
     "public/_utils/script/test/compact.js",
     "public/_utils/script/test/config.js",
     "public/_utils/script/test/conflicts.js",
     "public/_utils/script/test/content_negotiation.js",
     "public/_utils/script/test/copy_doc.js",
     "public/_utils/script/test/delayed_commits.js",
     "public/_utils/script/test/design_docs.js",
     "public/_utils/script/test/design_options.js",
     "public/_utils/script/test/design_paths.js",
     "public/_utils/script/test/etags_head.js",
     "public/_utils/script/test/etags_views.js",
     "public/_utils/script/test/invalid_docids.js",
     "public/_utils/script/test/jsonp.js",
     "public/_utils/script/test/large_docs.js",
     "public/_utils/script/test/list_views.js",
     "public/_utils/script/test/lorem.txt",
     "public/_utils/script/test/lorem_b64.txt",
     "public/_utils/script/test/lots_of_docs.js",
     "public/_utils/script/test/multiple_rows.js",
     "public/_utils/script/test/purge.js",
     "public/_utils/script/test/recreate_doc.js",
     "public/_utils/script/test/reduce.js",
     "public/_utils/script/test/reduce_false.js",
     "public/_utils/script/test/replication.js",
     "public/_utils/script/test/rev_stemming.js",
     "public/_utils/script/test/security_validation.js",
     "public/_utils/script/test/show_documents.js",
     "public/_utils/script/test/stats.js",
     "public/_utils/script/test/utf8.js",
     "public/_utils/script/test/uuids.js",
     "public/_utils/script/test/view_collation.js",
     "public/_utils/script/test/view_conflicts.js",
     "public/_utils/script/test/view_errors.js",
     "public/_utils/script/test/view_include_docs.js",
     "public/_utils/script/test/view_multi_key_all_docs.js",
     "public/_utils/script/test/view_multi_key_design.js",
     "public/_utils/script/test/view_multi_key_temp.js",
     "public/_utils/script/test/view_offsets.js",
     "public/_utils/script/test/view_pagination.js",
     "public/_utils/script/test/view_sandboxing.js",
     "public/_utils/script/test/view_xml.js",
     "public/_utils/status.html",
     "public/_utils/style/layout.css",
     "spec/cliclac/adapters/base_spec.rb",
     "spec/cliclac/adapters/mongo_spec.rb",
     "spec/cliclac/app_spec.rb",
     "spec/cliclac/helpers_spec.rb",
     "spec/cliclac/key_spec.rb",
     "spec/cliclac_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/sbellity/cliclac}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cliclac}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A port of CouchDB's Futon web interface to MongoDB}
  s.test_files = [
    "spec/cliclac/adapters/base_spec.rb",
     "spec/cliclac/adapters/mongo_spec.rb",
     "spec/cliclac/app_spec.rb",
     "spec/cliclac/helpers_spec.rb",
     "spec/cliclac/key_spec.rb",
     "spec/cliclac_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongo>, [">= 0.15"])
      s.add_runtime_dependency(%q<mongo_ext>, [">= 0.15"])
      s.add_runtime_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0.6.3"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.8"])
      s.add_development_dependency(%q<rack-test>, [">= 0.5.0"])
    else
      s.add_dependency(%q<mongo>, [">= 0.15"])
      s.add_dependency(%q<mongo_ext>, [">= 0.15"])
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_dependency(%q<yajl-ruby>, [">= 0.6.3"])
      s.add_dependency(%q<rspec>, [">= 1.2.8"])
      s.add_dependency(%q<rack-test>, [">= 0.5.0"])
    end
  else
    s.add_dependency(%q<mongo>, [">= 0.15"])
    s.add_dependency(%q<mongo_ext>, [">= 0.15"])
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    s.add_dependency(%q<yajl-ruby>, [">= 0.6.3"])
    s.add_dependency(%q<rspec>, [">= 1.2.8"])
    s.add_dependency(%q<rack-test>, [">= 0.5.0"])
  end
end
