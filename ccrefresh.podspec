Pod::Spec.new do |s|
  s.name         = "ccrefresh"
  s.version      = "0.0.1"
  s.summary      = "快速集成上拉下拉刷新功能"
  s.description  = <<-DESC
                   A longer description of ccrefresh in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/dev-cc/ccrefresh"
  s.license      = 'MIT'
  s.author       = { "huangbaoyu" => "baoyuhuang@163.com" } 
  s.platform     = :ios, '5.0'

  s.source       = { :git => "https://github.com/dev-cc/ccrefresh.git", :commit => "4286d79b8bf462dd2867e80bc7391fe0a41f1792" }
  s.source_files  = 'ccrefresh', 'ccrefresh/*.{h,m}'
end
