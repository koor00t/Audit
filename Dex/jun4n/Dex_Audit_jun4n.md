# jun4n

## reentrancy-no-eth
### 설명
재진입 기능을 이용한 버그.


addLiquidity 함수
- 70 Line : require(bool)(ERC20(token_x).transferFrom(msg.sender,address(this),tokenXAmount))
- 71 Line : require(bool)(ERC20(token_y).transferFrom(msg.sender,address(this),tokenYAmount))
- 72 Line : _mint(msg.sender,token_amount)
위 코드로 인해 ERC20._totalSupply에서 교차 함수 재진입이 가능하다.


### 파급력
Impact : Medium

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.




## reentrancy-events
### 설명
비정상적인 이벤트로 인한 재진입 버그.


addLiquidity 함수
- 70 Line : require(bool)(ERC20(token_x).transferFrom(msg.sender,address(this),tokenXAmount))
- 71 Line : require(bool)(ERC20(token_y).transferFrom(msg.sender,address(this),tokenYAmount))
- 72 Line : _mint(msg.sender,token_amount)


### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.
