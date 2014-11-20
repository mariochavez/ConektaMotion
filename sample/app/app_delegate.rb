class AppDelegate < PM::Delegate

  def on_load(app, options)
    home = HomeScreen.new(nav_bar: true)
    open home
  end
end
