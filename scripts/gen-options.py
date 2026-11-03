#!/usr/bin/env python3
"""Render options.generated.md from lib/ojuny-options.nix.

Runs one `nix eval` against scripts/gen-options.nix, which uses
lib.evalModules on the option declarations only. No system configuration is
evaluated.
"""

import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
EXPRESSION = ROOT / "scripts" / "gen-options.nix"
OUTPUT = ROOT / "options.generated.md"

HEADER = """<!-- Generated file. Do not edit by hand. -->
# Ojuny Desktop options reference (generated)

Generated from the option declarations in `lib/ojuny-options.nix` through
`lib.evalModules`. Internal options are omitted. Regenerate with
`python3 scripts/gen-options.py`; CI fails when this file is stale.
"""


def code(text):
    fence = "`" if "`" not in text else "``"
    return f"{fence}{text}{fence}"


def collapse(text):
    return " ".join(text.split())


def load():
    result = subprocess.run(
        ["nix", "eval", "--impure", "--json", "-f", str(EXPRESSION)],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        sys.stderr.write(result.stderr)
        raise SystemExit(result.returncode)
    return json.loads(result.stdout)


def section_of(path):
    parts = path.split(".")
    if len(parts) <= 3:
        return "top level"
    return parts[2]


def render(records):
    sections = {}
    for record in records:
        sections.setdefault(section_of(record["path"]), []).append(record)

    order = sorted(sections)
    if "top level" in sections:
        order.remove("top level")
        order.insert(0, "top level")

    lines = [HEADER.rstrip(), "", f"{len(records)} public options under `desktop.ojuny`.", ""]
    for section in order:
        lines.append(f"## {section}")
        lines.append("")
        for record in sorted(sections[section], key=lambda item: item["path"]):
            entry = (
                f"- {code(record['path'])} "
                f"({code(collapse(record['type']))}, "
                f"default {code(collapse(record['default']))})"
            )
            description = collapse(record["description"])
            if description:
                entry += f": {description}"
            lines.append(entry)
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def main():
    records = load()
    OUTPUT.write_text(render(records), encoding="utf-8")
    print(f"wrote {OUTPUT.relative_to(ROOT)} ({len(records)} options)")


if __name__ == "__main__":
    main()
