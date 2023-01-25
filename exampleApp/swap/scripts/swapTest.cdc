import StarBazaar from 0xf8d6e0586b0a20c7;
import StarToken from 0xf8d6e0586b0a20c7;
import XToken from "../contracts/XToken.cdc";
import YToken from "../contracts/YToken.cdc";

pub fun main(address: Address) {
    let authAccount: AuthAccount = getAuthAccount(address);
    let poolType: String = "niceFlow";

    log("Initiallizing...");
    
    let starDex <- StarBazaar.createDEXPool(poolType: poolType);
    log("`niceFlow` DEX pool created. Current liquidity: ".concat(starDex.getLiquidity().toString()));
    log("----------------------------------------------------------------")

    let tokenX <- XToken.freeMint(amount: 1000.0);
    let tokenY <- YToken.freeMint(amount: 2000.0);

    let poolVault <- StarBazaar.createPoolVault(tokenX: <-tokenX, tokenY: <- tokenY, poolType: poolType);

    let dustNiceFlow <- starDex.depositLiquidity(pool: <- poolVault);

    log("Afeter depositing. Liquidity: ".concat(starDex.getLiquidity().toString()).concat(" Price Y/X: ").concat(starDex.getPriceY_X().toString()).concat(" Price X/Y: ").concat(starDex.getPriceX_Y().toString()));
    log("----------------------------------------------------------------")

    let halfLiquidity = starDex.getLiquidity() / 2.0;
    let halfDust <- dustNiceFlow.withdraw(amount: halfLiquidity);
    let halfPoolVault <- starDex.withdrawLiquidity(starDust: <- halfDust);

    log("Afeter withdraw half liquidity: ".concat(starDex.getLiquidity().toString()).concat(" Price Y/X: ").concat(starDex.getPriceY_X().toString()).concat(" Price X/Y: ").concat(starDex.getPriceX_Y().toString()));
    log("The amount of `XToken` withdrawed: ".concat(halfPoolVault.getXAmount().toString()));
    log("The amount of `YToken` withdrawed: ".concat(halfPoolVault.getYAmount().toString()));
    log("----------------------------------------------------------------")

    log("The price Y/X before swapping is : ".concat(starDex.getPriceY_X().toString()));
    let inputX <- XToken.freeMint(amount: 200.0);
    let swapedY <- starDex.swap(in_token: <- inputX);
    log("Input 200.0 `XToken`, and we can get ".concat(swapedY.balance.toString()).concat(" `YToken`."));
    log("After swapping the liquidity is: ".concat(starDex.getLiquidity().toString()));
    log("The price Y/X aftet swapping is: ".concat(starDex.getPriceY_X().toString()));
    destroy swapedY;
    log("----------------------------------------------------------------");

    log("The price X/Y before swapping is : ".concat(starDex.getPriceX_Y().toString()));
    let inputY <- YToken.freeMint(amount: 200.0);
    let swapedX <- starDex.swap(in_token: <- inputY);
    log("Input 200.0 `YToken`, and we can get ".concat(swapedX.balance.toString()).concat(" `XToken`."));
    log("After swapping the liquidity is: ".concat(starDex.getLiquidity().toString()));
    log("The price X/Y after swapping is : ".concat(starDex.getPriceX_Y().toString()));
    destroy swapedX;
    log("----------------------------------------------------------------");

    destroy dustNiceFlow;
    destroy halfPoolVault;
    destroy starDex;
}
