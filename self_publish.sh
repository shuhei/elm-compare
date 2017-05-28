#!/usr/bin/env bash
pushd ./ElmCompare
rm -rf ./elm-stuff
mv elm-package.json elm-package.json.bk
# Install core, etc.
yes | npm run compile
mv -f elm-package.json.bk elm-package.json
popd
python ./elm-ops-tooling/elm_self_publish.py ./elm-native-ui ./ElmCompare
pushd ./ElmCompare
npm run compile
popd
