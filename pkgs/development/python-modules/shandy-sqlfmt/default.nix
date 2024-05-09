{ lib
, python3
, fetchFromGitHub
, ...
}:
let
  pname = "shandy-sqlfmt";
  version = "0.21.3";
in
python3.pkgs.buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "sqlfmt";
    rev = "refs/tags/v${version}";
    fetchSubmodules = false;
    sha256 = "sha256-BbkP6+c+VogwaYG9GK9YlgrtUKDVOlj2MFzzO4J7qOs=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    jinja2
    platformdirs
    poetry-core
    tqdm
  ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ];

  meta = with lib; {
    description = "sqlfmt formats your dbt SQL files so you don't have to.";
    homepage = "https://github.com/tconbeer/sqlfmt";
    licence = licences.mit;
  };
}
