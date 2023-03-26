# Namryeong-Kim

## unchecked-transfer
### 설명
transfer/transferFrom 반환값을 체크하지 않는 버그.
토큰은 전송 실패 시 revert되지 않고 false를 반환합니다.


swap 함수
- 41 Line : tokenX_.transferFrom(msg.sender,address(this),_tokenXAmount)
- 42 Line : tokenY_.transfer(msg.sender,outputAmount)
- 49 Line : tokenY_.transferFrom(msg.sender,address(this),_tokenYAmount)
- 50 Line : tokenX_.transfer(msg.sender,outputAmount)

addLiquidity 함수
- 119 Line : tokenX_.transferFrom(msg.sender,address(this),amountX)
- 120 Line : tokenY_.transferFrom(msg.sender,address(this),amountY)

removeLiquidity 함수
- 153 Line : tokenX_.transfer(msg.sender,amountX)
- 154 Line : tokenY_.transfer(msg.sender,amountY)

### 파급력
Impact : High

### 해결방안
SafeERC20을 사용하거나 transfer/transferFrom 반환값이 체크되어 있는지 확인한다.



## divide-before-multiply
### 설명
나눗셈을 한 결과값에 곱셈을 수행함.


swap 함수
- 38 Line : outputAmount = (reserveY * inputWithFees) / (reserveX + inputWithFees)
- 45 Line : inputWithFees = _tokenYAmount * 999 / 1000
- 46 Line : outputAmount = (reserveX * inputWithFees) / (reserveY + inputWithFees)

### 파급력
Impact : Medium

### 해결방안
나눗셈을 하기전에 곱셈을 하는 로직을 고려한다.



## reentrancy-no-eth
### 설명
재진입 기능을 이용한 버그.


swap 함수
- 41 Line : tokenX_.transferFrom(msg.sender,address(this),_tokenXAmount)
- 42 Line : tokenY_.transfer(msg.sender,outputAmount)
- 49 Line : tokenY_.transferFrom(msg.sender,address(this),_tokenYAmount)
- 50 Line : tokenX_.transfer(msg.sender,outputAmount)
- 53 Line : (reserveX_,reserveY_) = _update()
위 코드로 인해 Dex.reserveX_, Dex.reserveY에서 교차 함수 재진입이 가능하다.


addLiquidity 함수
- 119 Line : tokenX_.transferFrom(msg.sender,address(this),amountX)
- 120 Line : tokenY_.transferFrom(msg.sender,address(this),amountY)
- 122 Line : LPTokenAmount = mint(msg.sender,amountX,amountY)
위 코드로 인해 ERC20._totalSupply에서 교차 함수 재진입이 가능하다.


removeLiquidity 함수
- 153 Line : tokenX_.transfer(msg.sender,amountX)
- 154 Line : tokenY_.transfer(msg.sender,amountY)
- 156 Line : _burn(msg.sender,_LPTokenAmount)
위 코드로 인해 ERC20._balances, ERC20._totalSupply에서 교차 함수 재진입이 가능하다.

### 파급력
Impact : Medium

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.



## reentrancy-benign
### 설명
이중 호출로 인한 재진입 버그.


addLiquidity 함수
- 119 Line : tokenX_.transferFrom(msg.sender,address(this),amountX)
- 120 Line : tokenY_.transferFrom(msg.sender,address(this),amountY)
- 122 Line : LPTokenAmount = mint(msg.sender,amountX,amountY)
- 125 Line : (reserveX_,reserveY_) = _update()


removeLiquidity 함수
- 153 Line : tokenX_.transfer(msg.sender,amountX)
- 154 Line : tokenY_.transfer(msg.sender,amountY)
- 158 Line : (reserveX_,reserveY_) = _update()


### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.



## reentrancy-events
### 설명
비정상적인 이벤트로 인한 재진입 버그.


addLiquidity 함수
- 119 Line : tokenX_.transferFrom(msg.sender,address(this),amountX)
- 120 Line : tokenY_.transferFrom(msg.sender,address(this),amountY)
- 122 Line : LPTokenAmount = mint(msg.sender,amountX,amountY)


removeLiquidity 함수
- 153 Line : tokenX_.transfer(msg.sender,amountX)
- 154 Line : tokenY_.transfer(msg.sender,amountY)
- 156 Line : _burn(msg.sender,_LPTokenAmount)

### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.
