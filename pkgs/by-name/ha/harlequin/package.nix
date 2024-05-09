{ lib
, python3
, fetchFromGitHub
}:
let
  pname = "harlequin";
  version = "1.20.0";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "harlequin";
    rev = "refs/tags/v${version}";
    fetchSubmodules = false;
    sha256 = "sha256-Ik6LKZQq+7SObV6ovYAPfAkg65ZJqvp6DSVUVBS/qoM=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    duckdb
    numpy
    platformdirs
    poetry-core
    questionary
    rich-click
    shandy-sqlfmt
    textual
    textual-fastdatatable
    textual-textarea
    tomlkit
  ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "textual"
  ];

  meta = with lib; {
    description = "The SQL IDE for Your Terminal";
    homepage = "https://github.com/tconbeer/harlequin";
    licence = licences.mit;
  };
}
