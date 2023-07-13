#!/bin/bash

python test.py --dataname canoe --mode train
python test.py --dataname canoe --mode test

python test.py --dataname fall --mode train
python test.py --dataname fall --mode test

python test.py --dataname fountain01 --mode train
python test.py --dataname fountain01 --mode test

python test.py --dataname fountain02 --mode train
python test.py --dataname fountain02 --mode test

python test.py --dataname overpass --mode train
python test.py --dataname overpass --mode test

python test.py --dataname boats --mode train
python test.py --dataname boats --mode test

python test.py --dataname blizzard --mode train
python test.py --dataname blizzard --mode test

python test.py --dataname skating --mode train
python test.py --dataname skating --mode test

python test.py --dataname snowFall --mode train
python test.py --dataname snowFall --mode test

python test.py --dataname wetSnow --mode train
python test.py --dataname wetSnow --mode test

