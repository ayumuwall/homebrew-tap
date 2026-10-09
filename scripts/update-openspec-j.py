#!/usr/bin/env python3
"""Generate the formula from the public npm stable release; never downgrade."""
import hashlib
import json
import os
from pathlib import Path
import re
import urllib.request

def fetch(url):
    with urllib.request.urlopen(url, timeout=60) as response:
        return response.read()

metadata = json.loads(fetch('https://registry.npmjs.org/@ayumuwall%2fopenspec/latest'))
version = os.environ.get('VERSION') or metadata['version']
if not re.fullmatch(r'\d+\.\d+\.\d+', version) or version != metadata['version']:
    raise SystemExit('Target must equal the stable npm latest version')
url = metadata['dist']['tarball']
if url != f'https://registry.npmjs.org/@ayumuwall/openspec/-/openspec-{version}.tgz':
    raise SystemExit('Unexpected npm tarball URL')
data = fetch(url)
if hashlib.sha1(data).hexdigest() != metadata['dist']['shasum']:
    raise SystemExit('npm tarball integrity mismatch')
sha = hashlib.sha256(data).hexdigest()
formula = Path('Formula/openspec-j.rb')
old = formula.read_text() if formula.exists() else ''
previous = re.search(r'^  version "([\d.]+)"$', old, re.M)
if previous and tuple(map(int, version.split('.'))) < tuple(map(int, previous[1].split('.'))):
    raise SystemExit('Refusing a downgrade')
content = f'''class OpenspecJ < Formula
  desc "Japanese localization of OpenSpec for spec-driven development"
  homepage "https://github.com/ayumuwall/OpenSpec-J"
  url "{url}"
  version "{version}"
  sha256 "{sha}"
  license "MIT"

  depends_on "node"
  conflicts_with "openspec", because: "both install the openspec executable"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"openspec", "completion", "generate")
  end

  test do
    assert_equal version.to_s, shell_output("#{{bin}}/openspec --version").strip
    assert_match "バージョン", shell_output("#{{bin}}/openspec version --help")
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec"
  end
end
'''
formula.write_text(content)
print(f'{version} SHA256={sha} changed={content != old}')
if os.environ.get('GITHUB_OUTPUT'):
    with open(os.environ['GITHUB_OUTPUT'], 'a') as out:
        out.write(f'version={version}\nchanged={str(content != old).lower()}\n')
