class OpenspecJ < Formula
  desc "Japanese localization of OpenSpec for spec-driven development"
  homepage "https://github.com/ayumuwall/OpenSpec-J"
  url "https://registry.npmjs.org/@ayumuwall/openspec/-/openspec-2.0.0.tgz"
  version "2.0.0"
  sha256 "a7ec2ca4a9c3f139f4272dac8ed67d44381a81b9e99814f96d8d80ec6a28f3e7"
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
