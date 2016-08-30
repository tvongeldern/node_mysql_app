echo Building... &&

cat src/node/head.js > index.js &&
cat src/node/_*.js >> index.js &&
cat src/node/foot.js >> index.js &&

rm -f dist/*.html &&
cp src/pages/* dist &&

rm -f dist/*.css &&
cp src/css/* dist &&

rm -f dist/*.js &&
cp src/js/* dist &&

rm -f dist/queries/*.sql &&
cp src/queries/* dist/queries &&

echo Built!
