class OpenspecJ < Formula
  desc "Japanese localization of OpenSpec for spec-driven development"
  homepage "https://github.com/ayumuwall/OpenSpec-J"
  url "https://registry.npmjs.org/@ayumuwall/openspec/-/openspec-1.14.1.tgz"
  version "1.14.1"
  sha256 "e233c83b1a2f898c5ec12982a83b4b2ff24827dc9cc3fcd4fc848fb1a807a39f"
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
