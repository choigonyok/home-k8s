#!bin/sh

find . -type f -name '*.yaml' -exec grep -l '<path' {} \\;