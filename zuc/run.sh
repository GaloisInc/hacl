#!/bin/sh
set -e

${SAW:-../bin/saw} zuc-equiv.saw
${SAW:-../bin/saw} zuc-bug.saw
${SAW:-../bin/saw} zuc-nobug.saw
