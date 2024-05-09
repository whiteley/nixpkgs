{ lib
, python3
, fetchFromGitHub
, ...
}:
let
  pname = "textual-textarea";
  version = "0.13.0";
in
python3.pkgs.buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-textarea";
    rev = "refs/tags/v${version}";
    fetchSubmodules = false;
    sha256 = "sha256-cVXs0CRdTJAYH2VR5TBO/xpNp73zUqTr3D4YRhf5YJY=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    poetry-core
    pyperclip
    textual
  ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "textual"
  ];

  meta = with lib; {
    description = "A text area (multi-line input) with syntax highlighting and autocomplete for Textual.";
    homepage = "https://github.com/tconbeer/textual-textarea";
    licence = licences.mit;
  };
}
