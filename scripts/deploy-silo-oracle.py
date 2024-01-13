#!/usr/bin/env python3

import boa
import json
import os
import sys
from getpass import getpass
from eth_account import account
from boa.network import NetworkEnv


NETWORK = "http://localhost:8545"
CRVUSD = "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E"
SILOCRVUSD_CRV = "0xb27D1729489d04473631f0AFAca3c3A7389ac9F8"
SILO = "0x96eFdF95Cc47fe90e8f63D2f5Ef9FB8B180dAeB9"


def account_load(fname):
    path = os.path.expanduser(os.path.join('~', '.brownie', 'accounts', fname + '.json'))
    with open(path, 'r') as f:
        pkey = account.decode_keyfile_json(json.load(f), getpass())
        return account.Account.from_key(pkey)


if __name__ == '__main__':
    if '--fork' in sys.argv[1:]:
        boa.env.fork(NETWORK)
        boa.env.eoa = '0xbabe61887f1de2713c6f97e567623453d3C79f67'
    else:
        boa.set_env(NetworkEnv(NETWORK))
        boa.env.add_account(account_load('babe'))
        boa.env._fork_try_prefetch_state = False

    oracle = boa.load('contracts/SiloV2Oracle.vy', CRVUSD, SILOCRVUSD_CRV, SILO)
    print('Oracle deployed at:', oracle.address)

    if '--fork' in sys.argv[1:]:
        import IPython
        IPython.embed()
