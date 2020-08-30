test -d freqtrade || git clone https://github.com/freqtrade/freqtrade.git
cd freqtrade
git checkout master
./setup.sh --install
