gitbook build --output="/tmp/heads"
git add -A
git commit -m 'update sources'
git push
git checkout gh-pages
mv /tmp/heads/* .
git add -A
git commit -m 'update website'
git push
rm -rf /tmp/heads
git checkout master
