echo "Changing Blog's Background image..."

sed -e 's/bg[0-9][0-9]/bg00/g' ./themes/next/source/css/_custom/custom.styl > ~/Desktop/blog/tmp__.tmp
cat ~/Desktop/blog/tmp__.tmp > ./themes/next/source/css/_custom/custom.styl
rm -rf ~/Desktop/blog/tmp__.tmp

hexo g && hexo d
