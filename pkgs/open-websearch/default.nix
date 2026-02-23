{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "open-websearch";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Aas-ee";
    repo = "open-webSearch";
    rev = "v${version}";
    hash = "sha256-GN2RuVst+uuJzItPOMXI5z87zcRM4gT5iX+SD9AifIQ=";
  };

  npmDepsHash = "sha256-EIlclTiiX5RSJaIqyxPmC6HVcripeJV5iAdBjOmBxYQ=";

  npmBuildScript = "build";

  meta = {
    description = "Web search MCP server";
    homepage = "https://github.com/Aas-ee/open-webSearch";
    license = lib.licenses.mit;
  };
}
