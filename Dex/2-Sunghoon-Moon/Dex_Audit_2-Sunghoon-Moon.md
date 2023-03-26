# 2-Sunghoon-Moon

## unchecked-transfer
### 설명
transfer/transferFrom 반환값을 체크하지 않는 버그.
토큰은 전송 실패 시 revert되지 않고 false를 반환합니다.


swap 함수
- 133 Line : inputToken.transferFrom(msg.sender,address(this),inputAmount)
- 134 Line : outputToken.transfer(msg.sender,outputAmount)

addLiquidity 함수
- 55 Line : tokenX_.transferFrom(msg.sender,address(this),amountX)
- 56 Line : tokenY_.transferFrom(msg.sender,address(this),amountY)

removeLiquidity 함수
- 82 Line : tokenX.transfer(msg.sender,tokenXAmount)
- 83 Line : tokenY.transfer(msg.sender,tokenYAmount)

### 파급력
Impact : High

### 해결방안
SafeERC20을 사용하거나 transfer/transferFrom 반환값이 체크되어 있는지 확인한다.


## incorrect-equality
### 설명
공격자가 쉽게 조작할 수 있는 strict equalities를 사용한다.


addLiquidity 함수
- 38 Line : totalLiquidity == 0
- 47 Line : require(bool)(priceX == priceY)

### 파급력
Impact : Medium

### 해결방안
계정의 토큰 보유량을 확인하기 위해서 strict equality를 사용하면 안된다.




## reentrancy-no-eth
### 설명
재진입 기능을 이용한 버그.


addLiquidity 함수
- 55 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 56 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 59 Line : totalLiquidity += LPTokenAmount
위 코드로 인해 Dex.totalLiquidity에서 교차 함수 재진입이 가능하다.


removeLiquidity 함수
- 82 Line : tokenX.transfer(msg.sender,tokenXAmount)
- 83 Line : tokenY.transfer(msg.sender,tokenYAmount)
- 85 Line : _burn(msg.sender,LPTokenAmount)
위 코드로 인해 ERC20._balances, Dex.totalLiquidity에서 교차 함수 재진입이 가능하다.

### 파급력
Impact : Medium

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.



## reentrancy-benign
### 설명
이중 호출로 인한 재진입 버그.


addLiquidity 함수
- 55 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 56 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 58 Line : _mint(msg.sender,LPTokenAmount)


removeLiquidity 함수
- 82 Line : tokenX.transfer(msg.sender,tokenXAmount)
- 83 Line : tokenY.transfer(msg.sender,tokenYAmount)
- 85 Line : _burn(msg.sender,LPTokenAmount)


### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.



## reentrancy-events
### 설명
비정상적인 이벤트로 인한 재진입 버그.


swap 함수
- 133 Line : inputToken.transferFrom(msg.sender,address(this),inputAmount)
- 134 Line : outputToken.transfer(msg.sender,outputAmount)
- 137 Line : Swap(msg.sender,address(inputToken),address(outputToken),inputAmount,outputAmount)


addLiquidity 함수
- 55 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 56 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 61 Line : AddLiquidity(msg.sender,tokenXAmount,tokenYAmount)


removeLiquidity 함수
- 82 Line : tokenX.transfer(msg.sender,tokenXAmount)
- 83 Line : tokenY.transfer(msg.sender,tokenYAmount)
- 88 Line : RemoveLiquidity(msg.sender,tokenXAmount,tokenYAmount)


### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.




## too-many-digits
### 설명
자릿수가 많은 리터럴은 읽고 검토하기 어렵다.


sqrt 함수
- 165 Line : xx >= 0x100000000000000000000000000000000
- 169 Line : xx >= 0x10000000000000000
- 173 Line : xx >= 0x100000000


### 파급력
Impact : Informational


### 해결방안
솔리디티 문서의 Ether 표현법, Time 표현법, Rational and Interger Literals을 사용해서 표현한다.