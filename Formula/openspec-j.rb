class OpenspecJ < Formula
  desc "Japanese localization of OpenSpec for spec-driven development"
  homepage "https://github.com/ayumuwall/OpenSpec-J"
  url "https://registry.npmjs.org/@ayumuwall/openspec/-/openspec-1.15.0.tgz"
  version "1.15.0"
  sha256 "424b3b3a9b9a89fcf590c116880f801cb6a482b38c8a6c8ed4f3f419d8c5dd5d"
  license "MIT"

  depends_on "node"
  conflicts_with "openspec", because: "both install the openspec executable"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"openspec", "completion", "generate")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/openspec --version").strip
    assert_match "バージョン", shell_output("#{bin}/openspec version --help")
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec"
  end
end
