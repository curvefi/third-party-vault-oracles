# @version 0.3.10

"""
Oracle for Silo V2 vault tokens
"""

from vyper.interfaces import ERC20


struct SiloAssetStorage:
    collateralToken: ERC20
    collateralOnlyToken: ERC20
    debtToken: ERC20
    totalDeposits: uint256
    collateralOnlyDeposits: uint256
    totalBorrowAmount: uint256

interface Silo:
    def assetStorage(asset: ERC20) -> SiloAssetStorage: view


BORROWED_TOKEN: public(immutable(ERC20))
SILO_TOKEN: public(immutable(ERC20))
SILO: public(immutable(Silo))


@external
def __init__(borrowed_token: ERC20, silo_token: ERC20, silo: Silo):
    BORROWED_TOKEN = borrowed_token
    SILO_TOKEN = silo_token
    SILO = silo


@external
@view
def pricePerShare() -> uint256:
    # Use +1 to avoid underflows
    return (SILO.assetStorage(BORROWED_TOKEN).totalDeposits + 1) * 10**18 / (SILO_TOKEN.totalSupply() + 1)
