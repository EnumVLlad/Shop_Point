aa_stylesheets = Gem.loaded_specs["activeadmin"].full_gem_path
aa_stylesheets = File.join(aa_stylesheets, "app", "assets", "stylesheets")

Rails.application.config.dartsass.builds = {
  "active_admin.scss" => "active_admin.css"
}

Rails.application.config.dartsass.build_options = ["--style=compressed", "--load-path=#{aa_stylesheets}"]
