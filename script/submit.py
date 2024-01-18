from eth_account import Account
from os import path


def main():
    p = path.expanduser('~/.foundry/keystores/philogy.eth')
    with open(p, 'r') as f:
        print(f.read())
    account = Account.decrypt(p, 'pulsate-epidemic-splatter')
    print(f'account: {account}')


if __name__ == '__main__':
    main()
