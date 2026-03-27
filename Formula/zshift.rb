class Zshift < Formula
  desc "Supercharged Ctrl+T file navigation for zsh with directory browsing"
  homepage "https://github.com/ayumuwall/zshift"
  url "https://github.com/ayumuwall/zshift/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "40beac8b59b891dc63999818013cbd56658feaf312e07fff43116a750adc9e02"
  license "MIT"

  depends_on "fzf"
  depends_on "zoxide"

  def install
    (share/"zshift").install "zshift.zsh"
  end

  def caveats
    <<~EOS
      To activate zshift, add the following to your ~/.zshrc:

        source $(brew --prefix)/share/zshift/zshift.zsh
    EOS
  end

  test do
    assert_predicate share/"zshift/zshift.zsh", :exist?
  end
end
