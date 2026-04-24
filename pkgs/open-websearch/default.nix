{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "open-websearch";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "Aas-ee";
    repo = "open-webSearch";
    rev = "v${version}";
    hash = "sha256-ko216HwLEFhVOsyOBTDZNK0MfXL55OFrIM7RR1BRJJM=";
  };

  npmDepsHash = "sha256-yhWFDXEPvm7HWFOiO3X1YRFYpAT0QeZJuFt65yxu+E0=";

  npmBuildScript = "build";

  meta = {
    description = "Web search MCP server";
    mainProgram = "open-websearch";
    homepage = "https://github.com/Aas-ee/open-webSearch";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ "ReStranger" ];
  };
}
