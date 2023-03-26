# Sophie00Seo

## unchecked-transfer
### 설명
transfer/transferFrom 반환값을 체크하지 않는 버그.
토큰은 전송 실패 시 revert되지 않고 false를 반환합니다.


swap 함수
- 40 Line : _tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 41 Line : _tokenY.transfer(msg.sender,amount_)
- 49 Line : _tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 50 Line : _tokenX.transfer(msg.sender,amount_)

addLiquidity 함수
- 76 Line : _tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 77 Line : _tokenY.transferFrom(msg.sender,address(this),tokenYAmount)

removeLiquidity 함수
- 91 Line : _tokenX.transfer(msg.sender,returnAmountX)
- 92 Line : _tokenY.transfer(msg.sender,returnAmountY)


### 파급력
Impact : High

### 해결방안
SafeERC20을 사용하거나 transfer/transferFrom 반환값이 체크되어 있는지 확인한다.




## divide-before-multiply
### 설명
나눗셈을 한 결과값에 곱셈을 수행함.


swap 함수
- 35 Line : amount_ = _amountY * (tokenXAmount * 999 / 1000) / (_amountX + (tokenXAmount * 999 / 1000))
- 44 Line : amount_ = _amountX * (tokenYAmount * 999 / 1000) / (_amountY + (tokenYAmount * 999 / 1000))

### 파급력
Impact : Medium

### 해결방안
나눗셈을 하기전에 곱셈을 하는 로직을 고려한다.



## reentrancy-no-eth
### 설명
재진입 기능을 이용한 버그.


addLiquidity 함수
- 76 Line : _tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 77 Line : _tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 78 Line : _mint(msg.sender,lpAmount)
위 코드로 인해 ERC20._totalSupply에서 교차 함수 재진입이 가능하다.

### 파급력
Impact : Medium

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.



## events-maths
### 설명
중요한 산술 매개변수에 대한 누락된 이벤트를 감지.


addLiquidity 함수
- 74 Line : _amountX += tokenXAmount
- 75 Line : _amountY += tokenYAmount

removeLiquidity 함수
- 88 Line : _amountX -= returnAmountX
- 89 Line : _amountY -= returnAmountY


### 파급력
Impact : Low

### 해결방안
중요한 매개변수 변경에 대한 이벤트를 발생시킨다.



## missing-zero-check
### 설명
누락된 제로 주소 유효성 검사를 감지한다.

constructor 함수
- 20 Line : _addrX = addrX
- 21 Line : _addrY = addrY

### 파급력
Impact : Low

### 해결방안
주소가 0이 아닌지 확인합니다.



## reentrancy-benign
### 설명
이중 호출로 인한 재진입 버그.


addLiquidity 함수
- 76 Line : _tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 77 Line : _tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 78 Line : _mint(msg.sender,lpAmount)


### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.