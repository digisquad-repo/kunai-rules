#!/usr/bin/python
#
#
# quick and dirty.
#

from io import StringIO

import os
import sys
from jinja2 import Template
from dotenv import dotenv_values  # load_dotenv 


if len(sys.argv) < 4:
    print(
        "Usage: cat template.j2 | ./render.py <TARGET_VERB> <TARGET_NAME_DETECTION> <TARGET_NAME_DEPENDENCY>"
    )
    sys.exit(1)

env_stdin = sys.stdin.read()
env_vars = dotenv_values(stream=StringIO(env_stdin))

with open(sys.argv[1]) as f:
    template = Template(f.read())

argv_variables = {
    "TARGET_VERB": sys.argv[1],
    "TARGET_NAME_DETECTION": sys.argv[2],
    "TARGET_NAME_DEPENDENCY": sys.argv[3],
    "TARGET_FIRST_TAG": sys.argv[4],
}


merged_vars = {**env_vars, **argv_variables}

output = template.render(merged_vars)
print(output)
