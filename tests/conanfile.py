from conans import ConanFile, AutoToolsBuildEnvironment
from conans import tools
import os

class ATSConan(ConanFile):
    name = "ats-pthread-ext-tests"
    version = "0.1"
    settings = "os", "compiler", "build_type", "arch"
    generators = "virtualrunenv"
    exports_sources = "*"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": False, "fPIC": False}
    requires = "ats-pthread-extensions/0.1@randy.valis/testing"
    build_requires = "ats-unit-testing/0.1@randy.valis/testing"

    def build(self):
        atools = AutoToolsBuildEnvironment(self)
        atools.libs.append("pthread")
        var = atools.vars
        var['ATSFLAGS'] = self._format_ats()
        atools.make(vars=var)
        atools.make()

    def package(self):
        self.copy("tests", dst="target", keep_path=False)

    def deploy(self):
        self.copy("*", src="target", dst="bin")

    def _format_ats(self):
        return " ".join([ f"-IATS {path}src" for path in self.deps_cpp_info.build_paths ])
