class Zshift < Formula
  desc "Supercharged Ctrl+T file navigation for zsh with directory browsing"
  homepage "https://github.com/ayumuwall/zshift"
  url "https://github.com/ayumuwall/zshift/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "9baa278df1a201abda5e718823177771f03d368a9ad575d86740cf703d768953"
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
