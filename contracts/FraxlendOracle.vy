# @version 0.3.10

"""
Oracle for Fraxlend vault tokens
"""

interface Fraxlend:
    def toAssetAmount(shares: uint256, roundUp: bool) -> uint256: view


VAULT: public(immutable(Fraxlend))


@external
def __init__(vault: Fraxlend):
    VAULT = vault


@external
@view
def pricePerShare() -> uint256:
    return VAULT.toAssetAmount(10**18, False)
