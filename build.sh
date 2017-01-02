rm -rf _book
gitbook build . _book/
git add -A
git commit -m 'update sources'
git push
mv _book /tmp/heads
git checkout gh-pages
git pull
rm -rf *
mv -f /tmp/heads/* .
git add -A
git commit -m 'update website'
git push
rm -rf /tmp/heads
git checkout master
