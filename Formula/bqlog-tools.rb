class BqlogTools < Formula
  desc "Command line tools for BqLog log files"
  homepage "https://github.com/Tencent/BqLog"
  url "https://github.com/Tencent/BqLog/archive/refs/tags/Release_2.7.0.tar.gz"
  sha256 "aed63a3e5b38b35bdb10d6f1eef134e727af4b5e63ead165c5817f4271dd3517"
  license "Apache-2.0"

  head "https://github.com/Tencent/BqLog.git", branch: "develop"

  # The release tag is Release_<version>, which is not the v<version> livecheck assumes.
  livecheck do
    url :stable
    regex(/^Release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build

  # The tools compile the library sources into the executables, so they do not depend on
  # the bqlog formula.
  def install
    args = ["-DBQ_BUILD_LIB=OFF", "-DBQ_BUILD_TOOLS=ON", "-DBQ_WERROR=OFF"]
    # A package manager installs for the native architecture, not a universal binary.
    args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build", "--parallel"
    system "cmake", "--install", "build"
  end

  test do
    assert_predicate bin/"BqLog_CategoryLogGenerator", :executable?
    assert_predicate bin/"BqLog_LogDecoder", :executable?
  end
end
