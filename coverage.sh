rm -rf coverage
mkdir coverage
find . -name '*.lcov.info' -exec cp {} coverage/ \; 2>/dev/null
find coverage -name '*.lcov.info' -exec echo -a {} \; | xargs lcov -o coverage/lcov.info
if [ -f coverage/lcov.info ]; then
  clean_coverage clean --exclusions-file coverage_exclusions coverage/lcov.info
  python3 -m lcov_cobertura coverage/lcov.info -o coverage/coverage.xml
  genhtml -o coverage/html coverage/lcov.info
else
  echo "No coverage file found"
fi