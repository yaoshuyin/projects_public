```bash
apt remove git
apt install zlib1g zlib1g-dev
wget -c "https://www.kernel.org/pub/software/scm/git/git-2.30.1.tar.gz"
tar xvf git-2.30.1.tar.gz 
cd git-2.30.1
./configure 
make
make install
ln -s /usr/local/bin/git /usr/bin/git
git clone https://github.com/powerline/fonts.git --depth=1
```
