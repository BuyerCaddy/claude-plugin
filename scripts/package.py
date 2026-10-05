#!/usr/bin/env python3
"""Build the standalone Claude plugin using only the Python standard library."""

import hashlib
import json
from pathlib import Path
import re
import stat
import sys
import tempfile
from zipfile import ZIP_DEFLATED, ZipFile


ROOT = Path(__file__).resolve().parent.parent
INCLUDE = (".claude-plugin", ".mcp.json", "assets", "skills", "README.md", "INSTALL.md", "LICENSE")
REQUIRED = (
    ".claude-plugin/plugin.json", ".mcp.json", "skills/research/SKILL.md",
    "skills/credits/SKILL.md", "INSTALL.md", "LICENSE",
)
OAUTH_URL = "https://buyercaddy-oauth-gateway-972736928837.us-central1.run.app/mcp"


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def collect_files(path):
    attributes = getattr(path.lstat(), "st_file_attributes", 0)
    if path.is_symlink() or attributes & getattr(stat, "FILE_ATTRIBUTE_REPARSE_POINT", 0):
        raise ValueError("Plugin files must not be symbolic links or junctions: " + str(path))
    if path.is_dir():
        for child in sorted(path.iterdir()):
            yield from collect_files(child)
    elif path.is_file():
        yield path
    else:
        raise ValueError("Expected a regular plugin file: " + str(path))


def build():
    files = sorted(file for name in INCLUDE for file in collect_files(ROOT / name))
    for file in files:
        if file.suffix == ".json":
            read_json(file)
    manifest = read_json(ROOT / ".claude-plugin/plugin.json")
    version = manifest.get("version", "")
    if manifest.get("name") != "buyercaddy" or not isinstance(version, str) or not re.fullmatch(
        r"\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?", version
    ):
        raise ValueError("Expected the buyercaddy manifest and a semantic release version.")
    config = read_json(ROOT / ".mcp.json")
    if config != {"mcpServers": {"buyercaddy": {"type": "http", "url": OAUTH_URL}}}:
        raise ValueError("Expected only the BuyerCaddy OAuth connector with no embedded credential configuration.")

    output = ROOT / "dist"
    output.mkdir(exist_ok=True)
    archive = output / "buyercaddy-claude-plugin.zip"
    with tempfile.NamedTemporaryFile(dir=output, suffix=".tmp", delete=False) as handle:
        temporary = Path(handle.name)
    try:
        with ZipFile(temporary, "w", compression=ZIP_DEFLATED) as package:
            for file in files:
                package.write(file, file.relative_to(ROOT).as_posix())
        with ZipFile(temporary) as package:
            missing = set(REQUIRED) - set(package.namelist())
            if missing:
                raise ValueError("Missing ZIP entries: " + ", ".join(sorted(missing)))
            if package.testzip() is not None:
                raise ValueError("ZIP integrity check failed.")
        temporary.replace(archive)
    finally:
        if temporary.exists():
            temporary.unlink()
    print("Built {} (version {}, {} files)".format(archive, version, len(files)))
    print("SHA256: " + hashlib.sha256(archive.read_bytes()).hexdigest())


if __name__ == "__main__":
    try:
        build()
    except (OSError, ValueError) as error:
        print("Build failed: " + str(error), file=sys.stderr)
        sys.exit(1)
