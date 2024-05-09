{ lib
, python3
, fetchFromGitHub
, ...
}:
let
  pname = "textual-fastdatatable";
  version = "0.7.1";
in
python3.pkgs.buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-fastdatatable";
    rev = "refs/tags/v${version}";
    fetchSubmodules = false;
    sha256 = "sha256-VkLugDLjYpx6YUH6y35U/EbB80Y6zTI4i4Bty6LSIkA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    poetry-core
    pyarrow
    textual
  ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ];

  meta = with lib; {
    description = "A performance-focused reimplementation of Textual's DataTable widget, with a pluggable data storage backend.";
    homepage = "https://github.com/tconbeer/textual-fastdatatable";
    licence = licences.mit;
  };
}
