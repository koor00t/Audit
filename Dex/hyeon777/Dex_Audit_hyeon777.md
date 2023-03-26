# hyeon777

## unchecked-transfer
### 설명
transfer/transferFrom 반환값을 체크하지 않는 버그.
토큰은 전송 실패 시 revert되지 않고 false를 반환합니다.


swap 함수
- 32 Line : X.transferFrom(msg.sender,address(this),tokenXAmount)
- 33 Line : Y.transfer(msg.sender,outputAmount)
- 42 Line : Y.transferFrom(msg.sender,address(this),tokenYAmount)
- 43 Line : X.transfer(msg.sender,outputAmount)

addLiquidity 함수
- 58 Line : X.transferFrom(msg.sender,address(this),tokenXAmount)
- 60 Line : Y.transferFrom(msg.sender,address(this),tokenYAmount)

removeLiquidity 함수
- 75 Line : X.transfer(msg.sender,_tx)
- 76 Line : Y.transfer(msg.sender,_ty)

### 파급력
Impact : High

### 해결방안
SafeERC20을 사용하거나 transfer/transferFrom 반환값이 체크되어 있는지 확인한다.



## divide-before-multiply
### 설명
나눗셈을 한 결과값에 곱셈을 수행함.


swap 함수
- 26 Line : x_value = tokenXAmount / 1000 * 999
- 36 Line : y_value = tokenYAmount / 1000 * 999


### 파급력
Impact : Medium

### 해결방안
나눗셈을 하기전에 곱셈을 하는 로직을 고려한다.



## incorrect-equality
### 설명
공격자가 쉽게 조작할 수 있는 strict equalities를 사용한다.


addLiquidity 함수
- 53 Line : totalSupply() == 0


### 파급력
Impact : Medium

### 해결방안
계정의 토큰 보유량을 확인하기 위해서 strict equality를 사용하면 안된다.



## reentrancy-no-eth
### 설명
재진입 기능을 이용한 버그.


addLiquidity 함수
- 58 Line : X.transferFrom(msg.sender,address(this),tokenXAmount)
- 59 Line : amountX = reserveX + tokenXAmount
- 7 Line : Dex.amountX
위 코드로 인해 Dex.amountX에서 교차 함수 재진입이 가능하다.


removeLiquidity 함수
- 75 Line : X.transfer(msg.sender,_tx)
- 76 Line : Y.transfer(msg.sender,_ty)
- 77 Line : _burn(msg.sender,LPTokenAmount)
위 코드로 인해 ERC20._totalSupply에서 교차 함수 재진입이 가능하다.

### 파급력
Impact : Medium

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.



## events-maths
### 설명
중요한 산술 매개변수에 대한 누락된 이벤트를 감지.


addLiquidity 함수
- 59 Line : amountX = reserveX + tokenXAmount
- 61 Line : amountY = reserveY + tokenYAmount


### 파급력
Impact : Low

### 해결방안
중요한 매개변수 변경에 대한 이벤트를 발생시킨다.



## reentrancy-benign
### 설명
이중 호출로 인한 재진입 버그.


addLiquidity 함수
- 58 Line : X.transferFrom(msg.sender,address(this),tokenXAmount)
- 60 Line : Y.transferFrom(msg.sender,address(this),tokenYAmount)
- 63 Line : _mint(msg.sender,LPTokenAmount)


removeLiquidity 함수
- 75 Line : X.transfer(msg.sender,_tx)
- 76 Line : Y.transfer(msg.sender,_ty)
- 77 Line : _burn(msg.sender,LPTokenAmount)


### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.



## reentrancy-events
### 설명
비정상적인 이벤트로 인한 재진입 버그.


addLiquidity 함수
- 58 Line : X.transferFrom(msg.sender,address(this),tokenXAmount)
- 60 Line : Y.transferFrom(msg.sender,address(this),tokenYAmount)
- 63 Line : _mint(msg.sender,LPTokenAmount)


removeLiquidity 함수
- 75 Line : X.transfer(msg.sender,_tx)
- 76 Line : Y.transfer(msg.sender,_ty)
- 77 Line : _burn(msg.sender,LPTokenAmount)


### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.
