class Toad < Formula
  include Language::Python::Virtualenv

  desc "Unified terminal interface for AI coding agents"
  homepage "https://github.com/batrachianai/toad"
  url "https://files.pythonhosted.org/packages/5e/42/22dea0e287f4e5227d9ceea9f152e83dbc490ae0b54b146da2089c89e7a1/batrachian_toad-0.6.0.tar.gz"
  sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  license "MIT"

  resource "textual-speedups" do
    url "https://files.pythonhosted.org/packages/91/ca/b878beabe3ad2c4aa958f55cb32ba34e7badaa09f73c6e94c87195eb531e/textual_speedups-0.2.1-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/00/b7/e3bf5133d697a08128598c8d0abc5e16377b51465a33756de24fa7dee953/aiosqlite-0.22.1-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "bashlex" do
    url "https://files.pythonhosted.org/packages/f4/be/6985abb1011fda8a523cfe21ed9629e397d6e06fb5bae99750402b25c95b/bashlex-0.18-py2.py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/98/78/01c019cdb5d6498122777c1a43056ebb3ebfeef2076d9d026bfe15583b2b/click-8.3.1-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/6a/09/e21df6aef1e1ffc0c816f0522ddc3f6dcded766c3261813131c78a704470/gitpython-3.1.46-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/a0/61/5c78b91c3143ed5c14207f463aecfc8f9dbb5092fb2869baf37c273b2705/gitdb-4.0.12-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/04/be/d09147ad1ec7934636ad912901c5fd7667e1c858e19d355237db0d0cd5e4/smmap-5.0.2-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "google-re2" do
    url "https://files.pythonhosted.org/packages/5f/ee/8b6f7d94bb689dafdf60de8dd8f8f6296ad40d4d15c933fcda4da7a3a06b/google_re2-1.1.20251105-1-cp314-cp314-macosx_15_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/2a/39/e50c7c3a983047577ee07d2a9e53faf5a69493943ec3f6a384bdc792deb2/httpx-0.28.1-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/7e/f5/f66802a942d491edb555dd61e3a9961140fd64c90bce1eafd741609d334d/httpcore-1.0.9-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/04/4b/29cac41a4d98d144bf5f6d33995617b185d14b22401f75ca86f384e87ff1/h11-0.16.0-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "notify_py" do
    url "https://files.pythonhosted.org/packages/87/b4/649f16520ed0a64c275861dcaf9c1291d079f742aa2bf9102fdd168e4197/notify_py-0.3.43-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/fe/21/e1d1da2586865a159fc73b611f36bdd50b6c4043cb6132d3d5e972988028/loguru-0.6.0-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b7/b9/c538f279a4e237a006a2c98387d081e9eb060d203d8ed34467cc0f0b9b53/packaging-26.0-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ef/3c/2c197d226f9ea224a9ab8d197933f9da0ae0aac5b6e0f884e2b8d9c8e9f7/pathspec-1.0.4-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cb/28/3bfe2fa5a7b9c46fe7e13c97bda14c895fb10fa2ebf1d0abb90e0cea7ee1/platformdirs-4.5.1-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/80/c4/f5af4c1ca8c1eeb2e92ccca14ce8effdeec651d5ab6053c589b074eda6e1/psutil-7.2.2-cp36-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/df/80/fc9d01d5ed37ba4c42ca2b55b4339ae6e200b456be3a1aaddf4a9fa99b8c/pyperclip-1.11.0-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/cd/2c/dc258600a25e1a1f04948073826bebc55e18dbd99dc65a576277a82146fa/setproctitle-1.3.7-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/9c/78/96ddb99933e11d91bc6e05edae23d2687e44213066bcbaca338898c73c47/textual-7.5.0-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/c7/21/705964c7812476f378728bdf590ca4b771ec72385c533964653c68e86bdc/pygments-2.19.2-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "typing_extensions" do
    url "https://files.pythonhosted.org/packages/18/67/36e9267722cc04a6b9f15c7f3441c2363321a3ea07da7ae0c0707beb2a9c/typing_extensions-4.15.0-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/94/54/e7d793b573f298e1c9013b8c4dade17d481164aa517d1d7148619c2cedbf/markdown_it_py-4.0.0-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/b3/38/89ba8ad64ae25be8de66a6d463314cf1eb366222074cfda9ee839c56a4b4/mdurl-0.1.2-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/04/1e/b832de447dee8b582cac175871d2f6c3d5077cc56d5575cadba1fd1cccfa/linkify_it_py-2.0.3-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ef/45/615f5babd880b4bd7d405cc0dc348234c5ffb6ed1ea33e152ede08b2072d/rich-14.3.2-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "textual-serve" do
    url "https://files.pythonhosted.org/packages/b5/fe/108e7773349d500cf363328c3d0b7123e03feda51e310a3a5b136ac8ca71/textual_serve-1.1.3-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/e8/0b/b97660c5fd05d3495b4eb27f2d0ef18dc1dc4eff7511a9bf371397ff0264/aiohttp-3.13.3-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/f1/4f/733c48f270565d78b4544f2baddc2fb2a245e5a8640254b12c36ac7ac68e/multidict-6.7.1-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/11/63/ff458113c5c2dac9a9719ac68ee7c947cb621432bcf28c9972b1c0e83938/yarl-1.22.0-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/0f/15/5bf3b99495fb160b63f95972b81750f18f7f4e02ad051373b669d17d44f2/aiohappyeyeballs-2.6.1-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "aiohttp-jinja2" do
    url "https://files.pythonhosted.org/packages/eb/90/65238d4246307195411b87a07d03539049819b022c01bcc773826f600138/aiohttp_jinja2-1.6-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/fb/76/641ae371508676492379f16e2fa48f4e2c11741bd63c48be4b12a6b09cba/aiosignal-1.4.0-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/3a/2a/7cc015f5b9f5db42b7d48157e23356022889fc354a2813c15934b7cb5c0e/attrs-25.4.0-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/a1/93/72b1736d68f03fda5fdf0f2180fb6caaae3894f1b854d006ac61ecc727ee/frozenlist-1.8.0-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/0e/61/66938bbb5fc52dbdf84594873d5b51fb1f7c7794e9c0f5bd885f30bc507b/idna-3.11-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/62/a1/3d680cbfd5f4b8f15abc1d571870c5fc3e594bb582bc3b64ea099db13e56/jinja2-3.1.6-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b5/64/7660f8a4a8e53c924d0fa05dc3a55c9cee10bbd82b11c5afb27d44b096ce/markupsafe-3.0.3-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b2/fa/89a8ef0468d5833a23fff277b143d0573897cf75bd56670a6d28126c7d68/propcache-0.4.1-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/42/97/4bd4ad97f85a23011dd8a535534bb1035c4e0bac1234d58f438e15cff51f/tree_sitter-0.25.2-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-bash" do
    url "https://files.pythonhosted.org/packages/23/bb/2d2cfbb1f89aaeb1ec892624f069d92d058d06bb66f16b9ec9fb5873ab60/tree_sitter_bash-0.25.1-cp310-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-css" do
    url "https://files.pythonhosted.org/packages/4d/28/ebcbcbba812d3e407f2f393747330eb8843e0c69d159024e33460b622aab/tree_sitter_css-0.25.0-cp310-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-go" do
    url "https://files.pythonhosted.org/packages/32/16/dd4cb124b35e99239ab3624225da07d4cb8da4d8564ed81d03fcb3a6ba9f/tree_sitter_go-0.25.0-cp310-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-html" do
    url "https://files.pythonhosted.org/packages/bd/17/827c315deb156bb8cac541da800c4bd62878f50a28b7498fbb722bddd225/tree_sitter_html-0.23.2-cp39-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-java" do
    url "https://files.pythonhosted.org/packages/57/ef/6406b444e2a93bc72a04e802f4107e9ecf04b8de4a5528830726d210599c/tree_sitter_java-0.23.5-cp39-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-javascript" do
    url "https://files.pythonhosted.org/packages/b1/8f/6b4b2bc90d8ab3955856ce852cc9d1e82c81d7ab9646385f0e75ffd5b5d3/tree_sitter_javascript-0.25.0-cp310-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-json" do
    url "https://files.pythonhosted.org/packages/5c/31/102c15948d97b135611d6a995c97a3933c0e9745f25737723977f58e142c/tree_sitter_json-0.24.8-cp39-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-markdown" do
    url "https://files.pythonhosted.org/packages/6d/9b/65eb5e6a8d7791174644854437d35849d9b4e4ed034d54d2c78810eaf1a6/tree_sitter_markdown-0.5.1-cp39-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-python" do
    url "https://files.pythonhosted.org/packages/e6/1d/60d8c2a0cc63d6ec4ba4e99ce61b802d2e39ef9db799bdf2a8f932a6cd4b/tree_sitter_python-0.25.0-cp310-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-regex" do
    url "https://files.pythonhosted.org/packages/71/06/6b4f995f61952572a94bcfce12d43fc580226551fab9dd0aac4e94465f38/tree_sitter_regex-0.25.0-cp310-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-rust" do
    url "https://files.pythonhosted.org/packages/bf/00/4c400fe94eb3cb141b008b489d582dcd8b41e4168aca5dd8746c47a2b1bc/tree_sitter_rust-0.24.0-cp39-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-sql" do
    url "https://files.pythonhosted.org/packages/05/45/b2bd5f9919ea15c4ae90a156999101ebd4caa4036babe54efaf9d3e77d55/tree_sitter_sql-0.3.11-cp310-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-toml" do
    url "https://files.pythonhosted.org/packages/92/20/ac8a20805339105fe0bbb6beaa99dbbd1159647760ddd786142364e0b7f2/tree_sitter_toml-0.7.0-cp39-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-xml" do
    url "https://files.pythonhosted.org/packages/75/f5/31013d04c4e3b9a55e90168cc222a601c84235ba4953a5a06b5cdf8353c4/tree_sitter_xml-0.7.0-cp39-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "tree-sitter-yaml" do
    url "https://files.pythonhosted.org/packages/18/0d/15a5add06b3932b5e4ce5f5e8e179197097decfe82a0ef000952c8b98216/tree_sitter_yaml-0.7.2-cp310-abi3-macosx_11_0_arm64.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/1b/a9/e3aee762739c1d7528da1c3e06d518503f8b6c439c35549b53735ba52ead/typeguard-4.4.4-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "xdg-base-dirs" do
    url "https://files.pythonhosted.org/packages/fc/03/030b47fd46b60fc87af548e57ff59c2ca84b2a1dadbe721bb0ce33896b2e/xdg_base_dirs-6.0.2-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/38/0e/27be9fdef66e72d64c0cdc3cc2823101b80585f8119b5c112c2e8f5f7dab/anyio-4.12.1-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e6/ad/3cc14f097111b4de0040c83a525973216457bbeeb63739ef1ed275c1c021/certifi-2026.1.4-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/fb/86/dd6e5db36df29e76c7a7699123569a4a18c1623ce68d826ed96c62643cae/mdit_py_plugins-0.5.0-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/37/87/1f677586e8ac487e29672e4b17455758fce261de06a0d086167bb760361a/uc_micro_py-1.0.3-py3-none-any.whl"
    sha256 "cc6d68ab6032e07f6fc993917ac4636ddbcba007b3db046948f58877e93de19f"
  end

  depends_on "python@3.14"

  def install
    venv = virtualenv_create(libexec, "python3.14")

    resources.each do |r|
      next if r.name == "textual-speedups"

      if r.url&.end_with?(".whl")
        r.stage do
          venv.pip_install Pathname.pwd/Dir["*.whl"].fetch(0)
        end
      else
        venv.pip_install r
      end
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "Usage", shell_output("#{bin}/toad --help")
  end
end
