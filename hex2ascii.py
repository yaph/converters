#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Convert hexadecimal values to their corresponding ASCII characters.
import argparse


def hex2ascii(s):
    return ''.join([chr(int(s[i * 2:i * 2 + 2], 16)) for i in range(int(len(s) / 2))])


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Convert hexadecimal values to their corresponding ASCII characters.')
    parser.add_argument('hex', type=str, help='A string of not separated hexadecimal values.')

    argv = parser.parse_args()
    print(hex2ascii(argv.hex))