class Seabolt < Formula
  desc "Neo4j Bolt Connector for C"
  homepage "https://github.com/neo4j-drivers/seabolt"
  url "https://github.com/neo4j-drivers/seabolt/archive/v1.7.4.tar.gz"
  sha256 "f51c02dfef862d97963a7b67b670750730fcdd7b56a11ce87c8c1d01826397ee"

  depends_on "cmake" => :build
  depends_on "pkg-config"
  depends_on "openssl" => [:build, :test]

  patch :DATA  if MacOS.version == :catalina

  def install
    system "mkdir", "build"
    Dir.chdir('build')
    system "cmake", "..", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
    
    bin.install "bin/seabolt-cli"
  end

  test do
    require "open3"
    Open3.popen3("BOLT_USER= #{bin}/seabolt-cli run \"UNWIND range(1, 3) AS n RETURN n\"") do |_, _, stderr|
      assert_equal "FATAL: Failed to connect", stderr.read.strip
    end
  end
end

__END__
diff --git a/src/seabolt-cli/src/main.c b/src/seabolt-cli/src/main.c
index 41204c2..c286a44 100644
--- a/src/seabolt-cli/src/main.c
+++ b/src/seabolt-cli/src/main.c
@@ -46,7 +46,7 @@
 
 #define TIME_UTC 0
 
-void timespec_get(struct timespec *ts, int type)
+int timespec_get(struct timespec *ts, int type)
 {
     UNUSED(type);
     clock_serv_t cclock;
